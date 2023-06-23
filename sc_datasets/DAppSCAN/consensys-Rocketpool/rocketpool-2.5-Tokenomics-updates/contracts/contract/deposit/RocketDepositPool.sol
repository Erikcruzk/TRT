pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

import "@openzeppelin/contracts/math/SafeMath.sol";

import "../RocketBase.sol";
import "../../interface/RocketVaultInterface.sol";
import "../../interface/RocketVaultWithdrawerInterface.sol";
import "../../interface/deposit/RocketDepositPoolInterface.sol";
import "../../interface/minipool/RocketMinipoolInterface.sol";
import "../../interface/minipool/RocketMinipoolQueueInterface.sol";
import "../../interface/dao/protocol/settings/RocketDAOProtocolSettingsDepositInterface.sol";
import "../../interface/token/RocketTokenRETHInterface.sol";


// The main entry point for deposits into the RP network
// Accepts user deposits and mints rETH; handles assignment of deposited ETH to minipools

contract RocketDepositPool is RocketBase, RocketDepositPoolInterface, RocketVaultWithdrawerInterface {

    // Libs
    using SafeMath for uint;

    // Events
    event DepositReceived(address indexed from, uint256 amount, uint256 time);
    event DepositRecycled(address indexed from, uint256 amount, uint256 time);
    event DepositAssigned(address indexed minipool, uint256 amount, uint256 time);
    event ExcessWithdrawn(address indexed to, uint256 amount, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        version = 1;
    }

    // Current deposit pool balance
    function getBalance() override public view returns (uint256) {
        RocketVaultInterface rocketVault = RocketVaultInterface(getContractAddress("rocketVault"));
        return rocketVault.balanceOf("rocketDepositPool");
    }

    // Excess deposit pool balance (in excess of minipool queue capacity)
    function getExcessBalance() override public view returns (uint256) {
        // Get minipool queue capacity
        RocketMinipoolQueueInterface rocketMinipoolQueue = RocketMinipoolQueueInterface(getContractAddress("rocketMinipoolQueue"));
        uint256 minipoolCapacity = rocketMinipoolQueue.getEffectiveCapacity();
        // Calculate and return
        uint256 balance = getBalance();
        if (minipoolCapacity >= balance) { return 0; }
        else { return balance.sub(minipoolCapacity); }
    }

    // Receive a vault withdrawal
    // Only accepts calls from the RocketVault contract
    function receiveVaultWithdrawalETH() override external payable onlyLatestContract("rocketDepositPool", address(this)) onlyLatestContract("rocketVault", msg.sender) {}

    // Accept a deposit from a user
    function deposit() override external payable onlyLatestContract("rocketDepositPool", address(this)) {
        // Load contracts
        RocketDAOProtocolSettingsDepositInterface rocketDAOProtocolSettingsDeposit = RocketDAOProtocolSettingsDepositInterface(getContractAddress("rocketDAOProtocolSettingsDeposit"));
        RocketTokenRETHInterface rocketTokenRETH = RocketTokenRETHInterface(getContractAddress("rocketTokenRETH"));
        // Check deposit settings
        require(rocketDAOProtocolSettingsDeposit.getDepositEnabled(), "Deposits into Rocket Pool are currently disabled");
        require(msg.value >= rocketDAOProtocolSettingsDeposit.getMinimumDeposit(), "The deposited amount is less than the minimum deposit size");
        require(getBalance().add(msg.value) <= rocketDAOProtocolSettingsDeposit.getMaximumDepositPoolSize(), "The deposit pool size after depositing exceeds the maximum size");
        // Mint rETH to user account
        rocketTokenRETH.mint(msg.value, msg.sender);
        // Emit deposit received event
        emit DepositReceived(msg.sender, msg.value, block.timestamp);
        // Process deposit
        processDeposit();
    }

    // Recycle a deposit from a dissolved minipool
    // Only accepts calls from registered minipools
    function recycleDissolvedDeposit() override external payable onlyLatestContract("rocketDepositPool", address(this)) onlyRegisteredMinipool(msg.sender) {
        emit DepositRecycled(msg.sender, msg.value, block.timestamp);
        processDeposit();
    }

    // Recycle a deposit from a withdrawn minipool
    // Only accepts calls from the RocketNetworkWithdrawal contract
    function recycleWithdrawnDeposit() override external payable onlyLatestContract("rocketDepositPool", address(this)) onlyLatestContract("rocketNetworkWithdrawal", msg.sender) {
        emit DepositRecycled(msg.sender, msg.value, block.timestamp);
        processDeposit();
    }

    // Recycle a liquidated RPL stake from a slashed minipool
    // Only accepts calls from the RocketAuctionManager contract
    function recycleLiquidatedStake() override external payable onlyLatestContract("rocketDepositPool", address(this)) onlyLatestContract("rocketAuctionManager", msg.sender) {
        emit DepositRecycled(msg.sender, msg.value, block.timestamp);
        processDeposit();
    }

    // Process a deposit
    function processDeposit() private {
        // Load contracts
        RocketDAOProtocolSettingsDepositInterface rocketDAOProtocolSettingsDeposit = RocketDAOProtocolSettingsDepositInterface(getContractAddress("rocketDAOProtocolSettingsDeposit"));
        RocketVaultInterface rocketVault = RocketVaultInterface(getContractAddress("rocketVault"));
        // Transfer ETH to vault
        rocketVault.depositEther{value: msg.value}();
        // Assign deposits if enabled
        if (rocketDAOProtocolSettingsDeposit.getAssignDepositsEnabled()) { assignDeposits(); }
    }

    // Assign deposits to available minipools
    function assignDeposits() override public onlyLatestContract("rocketDepositPool", address(this)) {
        // Load contracts
        RocketDAOProtocolSettingsDepositInterface rocketDAOProtocolSettingsDeposit = RocketDAOProtocolSettingsDepositInterface(getContractAddress("rocketDAOProtocolSettingsDeposit"));
        RocketMinipoolQueueInterface rocketMinipoolQueue = RocketMinipoolQueueInterface(getContractAddress("rocketMinipoolQueue"));
        RocketVaultInterface rocketVault = RocketVaultInterface(getContractAddress("rocketVault"));
        // Check deposit settings
        require(rocketDAOProtocolSettingsDeposit.getAssignDepositsEnabled(), "Deposit assignments are currently disabled");
        // Assign deposits
        // SWC-DoS With Block Gas Limit: L116-129
        for (uint256 i = 0; i < rocketDAOProtocolSettingsDeposit.getMaximumDepositAssignments(); ++i) {
            // Get & check next available minipool capacity
            uint256 minipoolCapacity = rocketMinipoolQueue.getNextCapacity();
            if (minipoolCapacity == 0 || getBalance() < minipoolCapacity) { break; }
            // Dequeue next available minipool
            address minipoolAddress = rocketMinipoolQueue.dequeueMinipool();
            RocketMinipoolInterface minipool = RocketMinipoolInterface(minipoolAddress);
            // Withdraw ETH from vault
            rocketVault.withdrawEther(minipoolCapacity);
            // Assign deposit to minipool
            minipool.userDeposit{value: minipoolCapacity}();
            // Emit deposit assigned event
            emit DepositAssigned(minipoolAddress, minipoolCapacity, block.timestamp);
        }
    }

    // Withdraw excess deposit pool balance for rETH collateral
    function withdrawExcessBalance(uint256 _amount) override external onlyLatestContract("rocketDepositPool", address(this)) onlyLatestContract("rocketTokenRETH", msg.sender) {
        // Load contracts
        RocketTokenRETHInterface rocketTokenRETH = RocketTokenRETHInterface(getContractAddress("rocketTokenRETH"));
        RocketVaultInterface rocketVault = RocketVaultInterface(getContractAddress("rocketVault"));
        // Check amount
        require(_amount <= getExcessBalance(), "Insufficient excess balance for withdrawal");
        // Withdraw ETH from vault
        rocketVault.withdrawEther(_amount);
        // Transfer to rETH contract
        rocketTokenRETH.depositExcess{value: _amount}();
        // Emit excess withdrawn event
        emit ExcessWithdrawn(msg.sender, _amount, block.timestamp);
    }

}
