pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

import "@openzeppelin/contracts/math/SafeMath.sol";

import "../../interface/RocketStorageInterface.sol";
import "../../interface/casper/DepositInterface.sol";
import "../../interface/deposit/RocketDepositPoolInterface.sol";
import "../../interface/minipool/RocketMinipoolInterface.sol";
import "../../interface/minipool/RocketMinipoolManagerInterface.sol";
import "../../interface/minipool/RocketMinipoolQueueInterface.sol";
import "../../interface/network/RocketNetworkWithdrawalInterface.sol";
import "../../interface/node/RocketNodeManagerInterface.sol";
import "../../interface/dao/protocol/settings/RocketDAOProtocolSettingsMinipoolInterface.sol";
import "../../interface/dao/protocol/settings/RocketDAOProtocolSettingsNetworkInterface.sol";
import "../../interface/token/RocketTokenNETHInterface.sol";
import "../../types/MinipoolDeposit.sol";
import "../../types/MinipoolStatus.sol";

// An individual minipool in the Rocket Pool network

contract RocketMinipoolDelegate is RocketMinipoolInterface {

    // Libs
    using SafeMath for uint;

    // Main Rocket Pool storage contract
    RocketStorageInterface rocketStorage = RocketStorageInterface(0);

    // Status
    MinipoolStatus private status;
    uint256 private statusBlock;
    uint256 private statusTime;

    // Deposit type
    MinipoolDeposit private depositType;

    // Node details
    address private nodeAddress;
    uint256 private nodeFee;
    uint256 private nodeDepositBalance;
    uint256 private nodeRefundBalance;
    bool private nodeDepositAssigned;
    bool private nodeWithdrawn;

    // User deposit details
    uint256 private userDepositBalance;
    bool private userDepositAssigned;
    uint256 private userDepositAssignedTime;

    // Staking details
    uint256 private stakingStartBalance;
    uint256 private stakingEndBalance;
    bool private validatorBalanceWithdrawn;

    // Events
    event StatusUpdated(uint8 indexed status, uint256 time);
    event EtherDeposited(address indexed from, uint256 amount, uint256 time);
    event EtherWithdrawn(address indexed to, uint256 amount, uint256 time);
    event NethWithdrawn(address indexed to, uint256 amount, uint256 time);

    // Status getters
    function getStatus() override public view returns (MinipoolStatus) { return status; }
    function getStatusBlock() override public view returns (uint256) { return statusBlock; }
    function getStatusTime() override public view returns (uint256) { return statusTime; }

    // Deposit type getter
    function getDepositType() override public view returns (MinipoolDeposit) { return depositType; }

    // Node detail getters
    function getNodeAddress() override public view returns (address) { return nodeAddress; }
    function getNodeFee() override public view returns (uint256) { return nodeFee; }
    function getNodeDepositBalance() override public view returns (uint256) { return nodeDepositBalance; }
    function getNodeRefundBalance() override public view returns (uint256) { return nodeRefundBalance; }
    function getNodeDepositAssigned() override public view returns (bool) { return nodeDepositAssigned; }
    function getNodeWithdrawn() override public view returns (bool) { return nodeWithdrawn; }

    // User deposit detail getters
    function getUserDepositBalance() override public view returns (uint256) { return userDepositBalance; }
    function getUserDepositAssigned() override public view returns (bool) { return userDepositAssigned; }
    function getUserDepositAssignedTime() override public view returns (uint256) { return userDepositAssignedTime; }

    // Staking detail getters
    function getStakingStartBalance() override public view returns (uint256) { return stakingStartBalance; }
    function getStakingEndBalance() override public view returns (uint256) { return stakingEndBalance; }
    function getValidatorBalanceWithdrawn() override public view returns (bool) { return validatorBalanceWithdrawn; }

    // Get the withdrawal credentials for the minipool contract
    function getWithdrawalCredentials() override public view returns (bytes memory) {
        return abi.encodePacked(byte(0x01), bytes11(0x0), address(this));
    }

    // Only allow access from the owning node address
    modifier onlyMinipoolOwner(address _nodeAddress) {
        require(_nodeAddress == nodeAddress, "Invalid minipool owner");
        _;
    }

    // Only allow access from the latest version of the specified Rocket Pool contract
    modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
        require(_contractAddress == getContractAddress(_contractName), "Invalid or outdated contract");
        _;
    }

    // Require that the address is a registered minipool
    // Prevents methods from being run directly on the delegate contract
    modifier onlyRegisteredMinipool(address _minipoolAddress) {
        require(rocketStorage.getBool(keccak256(abi.encodePacked("minipool.exists", _minipoolAddress))), "Invalid minipool");
        _;
    }

    // Get the address of a Rocket Pool network contract
    function getContractAddress(string memory _contractName) private view returns (address) {
        address contractAddress = rocketStorage.getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
        require(contractAddress != address(0x0), "Contract not found");
        return contractAddress;
    }

    // Assign the node deposit to the minipool
    // Only accepts calls from the RocketNodeDeposit contract
    function nodeDeposit() override external payable onlyRegisteredMinipool(address(this)) onlyLatestContract("rocketNodeDeposit", msg.sender) {
        // Check current status & node deposit status
        require(status == MinipoolStatus.Initialized, "The node deposit can only be assigned while initialized");
        require(!nodeDepositAssigned, "The node deposit has already been assigned");
        // Load contracts
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        // Check deposit amount
        require(msg.value == rocketDAOProtocolSettingsMinipool.getDepositNodeAmount(depositType), "Invalid node deposit amount");
        // Update node deposit details
        nodeDepositBalance = msg.value;
        nodeDepositAssigned = true;
        // Emit ether deposited event
        emit EtherDeposited(msg.sender, msg.value, block.timestamp);
        // Progress full minipool to prelaunch
        if (depositType == MinipoolDeposit.Full) { setStatus(MinipoolStatus.Prelaunch); }
    }

    // Assign user deposited ETH to the minipool and mark it as prelaunch
    // Only accepts calls from the RocketDepositPool contract
    function userDeposit() override external payable onlyRegisteredMinipool(address(this)) onlyLatestContract("rocketDepositPool", msg.sender) {
        // Check current status & user deposit status
        require(status >= MinipoolStatus.Initialized && status <= MinipoolStatus.Staking, "The user deposit can only be assigned while initialized, in prelaunch, or staking");
        require(!userDepositAssigned, "The user deposit has already been assigned");
        // Load contracts
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        // Check deposit amount
        require(msg.value == rocketDAOProtocolSettingsMinipool.getDepositUserAmount(depositType), "Invalid user deposit amount");
        // Update user deposit details
        userDepositBalance = msg.value;
        userDepositAssigned = true;
        userDepositAssignedTime = block.timestamp;
        // Refinance full minipool
        if (depositType == MinipoolDeposit.Full) {
            // Update node balances
            nodeDepositBalance = nodeDepositBalance.sub(msg.value);
            nodeRefundBalance = nodeRefundBalance.add(msg.value);
        }
        // Emit ether deposited event
        emit EtherDeposited(msg.sender, msg.value, block.timestamp);
        // Progress initialized minipool to prelaunch
        if (status == MinipoolStatus.Initialized) { setStatus(MinipoolStatus.Prelaunch); }
    }

    // Refund node ETH refinanced from user deposited ETH
    function refund() override external onlyRegisteredMinipool(address(this)) onlyMinipoolOwner(msg.sender) {
        // Check refund balance
        require(nodeRefundBalance > 0, "No amount of the node deposit is available for refund");
        // Refund node
        refundNode();
    }

    // Progress the minipool to staking, sending its ETH deposit to the VRC
    // Only accepts calls from the minipool owner (node)
    function stake(bytes calldata _validatorPubkey, bytes calldata _validatorSignature, bytes32 _depositDataRoot) override external onlyRegisteredMinipool(address(this)) onlyMinipoolOwner(msg.sender) {
        // Check current status
        require(status == MinipoolStatus.Prelaunch, "The minipool can only begin staking while in prelaunch");
        // Load contracts
        DepositInterface casperDeposit = DepositInterface(getContractAddress("casperDeposit"));
        RocketMinipoolManagerInterface rocketMinipoolManager = RocketMinipoolManagerInterface(getContractAddress("rocketMinipoolManager"));
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        // Get launch amount
        uint256 launchAmount = rocketDAOProtocolSettingsMinipool.getLaunchBalance();
        // Check minipool balance
        require(address(this).balance >= launchAmount, "Insufficient balance to begin staking");
        // Check validator pubkey is not in use
        require(rocketMinipoolManager.getMinipoolByPubkey(_validatorPubkey) == address(0x0), "Validator pubkey is already in use");
        // Send staking deposit to casper
        casperDeposit.deposit{value: launchAmount}(_validatorPubkey, getWithdrawalCredentials(), _validatorSignature, _depositDataRoot);
        // Set minipool pubkey
        rocketMinipoolManager.setMinipoolPubkey(_validatorPubkey);
        // Progress to staking
        setStatus(MinipoolStatus.Staking);
    }

    // Mark the minipool as withdrawable and record its final balance
    // Only accepts calls from the RocketMinipoolStatus contract
    function setWithdrawable(uint256 _stakingStartBalance, uint256 _stakingEndBalance) override external onlyRegisteredMinipool(address(this)) onlyLatestContract("rocketMinipoolStatus", msg.sender) {
        // Check current status
        require(status == MinipoolStatus.Staking, "The minipool can only become withdrawable while staking");
        // Set staking details
        stakingStartBalance = _stakingStartBalance;
        stakingEndBalance = _stakingEndBalance;
        // Remove minipool from queue
        RocketMinipoolQueueInterface rocketMinipoolQueue = RocketMinipoolQueueInterface(getContractAddress("rocketMinipoolQueue"));
        if (!userDepositAssigned) { rocketMinipoolQueue.removeMinipool(); }
        // Progress to withdrawable
        setStatus(MinipoolStatus.Withdrawable);
    }

        // Withdraw node balances & rewards from the minipool and close it
    // Only accepts calls from the minipool owner (node)
    function withdraw() override external onlyRegisteredMinipool(address(this)) onlyMinipoolOwner(msg.sender) {
        // Check current status
        require(status == MinipoolStatus.Withdrawable, "The minipool can only be withdrawn from while withdrawable");
        require(!nodeWithdrawn, "The minipool has already been withdrawn from");
        // Load contracts
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        RocketTokenNETHInterface rocketTokenNETH = RocketTokenNETHInterface(getContractAddress("rocketTokenNETH"));
        // Check withdrawal delay has passed
        require(block.number.sub(statusBlock) >= rocketDAOProtocolSettingsMinipool.getWithdrawalDelay() || validatorBalanceWithdrawn, "The minipool cannot be withdrawn from until after the withdrawal delay period");
        // Set node withdrawn status
        nodeWithdrawn = true;
        // Transfer nETH balance to node operator
        uint256 nethBalance = rocketTokenNETH.balanceOf(address(this));
        if (nethBalance > 0) {
            // Get node withdrawal address
            RocketNodeManagerInterface rocketNodeManager = RocketNodeManagerInterface(getContractAddress("rocketNodeManager"));
            address nodeWithdrawalAddress = rocketNodeManager.getNodeWithdrawalAddress(nodeAddress);
            // Transfer
            require(rocketTokenNETH.transfer(nodeWithdrawalAddress, nethBalance), "nETH balance was not successfully transferred to node operator");
            // Emit nETH withdrawn event
            emit NethWithdrawn(nodeWithdrawalAddress, nethBalance, block.timestamp);
        }
        // Transfer refunded ETH to node operator
        if (nodeRefundBalance > 0) { refundNode(); }
        // Destroy minipool if validator balance has been withdrawn
        if (validatorBalanceWithdrawn) { destroy(); }
    }


    // If there is enough ETH available, payout and close the pool
    // This will most likely be called by oracle nodes in the future
    // It is payable to allow for very small amounts of ETH to be sent in the tx if the final amount is every so slightly innacurate to what the SWC sends
    function payout() override external payable onlyRegisteredMinipool(address(this)) { 
        // Check current status
        require(status == MinipoolStatus.Withdrawable, "The minipool's validator balance can only be sent while withdrawable");
        require(!validatorBalanceWithdrawn, "The minipool's validator balance has already been sent");
        // load contracts
        RocketMinipoolManagerInterface rocketMinipoolManager = RocketMinipoolManagerInterface(getContractAddress("rocketMinipoolManager"));
        RocketNetworkWithdrawalInterface rocketNetworkWithdrawal = RocketNetworkWithdrawalInterface(getContractAddress("rocketNetworkWithdrawal"));
        // Check sender address or withdrawn balance before processing withdrawal
        uint256 withdrawnBalance = address(this).balance.sub(nodeRefundBalance);
        if (withdrawnBalance >= rocketMinipoolManager.getMinipoolWithdrawalTotalBalance(address(this))) {
            // Set validator balance withdrawn status
            validatorBalanceWithdrawn = true;
            // Process validator withdrawal for minipool
            rocketNetworkWithdrawal.processWithdrawal{value: withdrawnBalance}();
            // Destroy minipool if node has withdrawn
            if (nodeWithdrawn) { destroy(); }
        }
    }

    // Dissolve the minipool, returning user deposited ETH to the deposit pool
    // Only accepts calls from the minipool owner (node), or from any address if timed out
    function dissolve() override external onlyRegisteredMinipool(address(this)) {
        // Check current status
        require(status == MinipoolStatus.Initialized || status == MinipoolStatus.Prelaunch, "The minipool can only be dissolved while initialized or in prelaunch");
        // Load contracts
        RocketDepositPoolInterface rocketDepositPool = RocketDepositPoolInterface(getContractAddress("rocketDepositPool"));
        RocketMinipoolQueueInterface rocketMinipoolQueue = RocketMinipoolQueueInterface(getContractAddress("rocketMinipoolQueue"));
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        // Check if being dissolved by minipool owner or minipool is timed out
        require(
            msg.sender == nodeAddress ||
            (status == MinipoolStatus.Prelaunch && block.number.sub(statusBlock) >= rocketDAOProtocolSettingsMinipool.getLaunchTimeout()),
            "The minipool can only be dissolved by its owner unless it has timed out"
        );
        // Transfer user balance to deposit pool
        if (userDepositBalance > 0) {
            // Transfer
            rocketDepositPool.recycleDissolvedDeposit{value: userDepositBalance}();
            userDepositBalance = 0;
            // Emit ether withdrawn event
            emit EtherWithdrawn(address(rocketDepositPool), userDepositBalance, block.timestamp);
        }
        // Remove minipool from queue
        if (!userDepositAssigned) { rocketMinipoolQueue.removeMinipool(); }
        // Progress to dissolved
        setStatus(MinipoolStatus.Dissolved);
    }

    // Withdraw node balances from the minipool and close it
    // Only accepts calls from the minipool owner (node)
    function close() override external onlyRegisteredMinipool(address(this)) onlyMinipoolOwner(msg.sender) {
        // Check current status
        require(status == MinipoolStatus.Dissolved, "The minipool can only be closed while dissolved");
        // Transfer node balance to node operator
        uint256 nodeBalance = nodeDepositBalance.add(nodeRefundBalance);
        if (nodeBalance > 0) {
            // Update node balances
            nodeDepositBalance = 0;
            nodeRefundBalance = 0;
            // Get node withdrawal address
            RocketNodeManagerInterface rocketNodeManager = RocketNodeManagerInterface(getContractAddress("rocketNodeManager"));
            address nodeWithdrawalAddress = rocketNodeManager.getNodeWithdrawalAddress(nodeAddress);
            // Transfer balance
            (bool success,) = nodeWithdrawalAddress.call{value: nodeBalance}("");
            require(success, "Node ETH balance was not successfully transferred to node operator");
            // Emit ether withdrawn event
            emit EtherWithdrawn(nodeWithdrawalAddress, nodeBalance, block.timestamp);
        }
        // Destroy minipool
        destroy();
    }

    // Set the minipool's current status
    function setStatus(MinipoolStatus _status) private {
        // Update status
        status = _status;
        statusBlock = block.number;
        statusTime = block.timestamp;
        // Emit status updated event
        emit StatusUpdated(uint8(_status), block.timestamp);
    }

    // Transfer refunded ETH balance to the node operator
    function refundNode() private {
        // Update refund balance
        uint256 refundAmount = nodeRefundBalance;
        nodeRefundBalance = 0;
        // Get node withdrawal address
        RocketNodeManagerInterface rocketNodeManager = RocketNodeManagerInterface(getContractAddress("rocketNodeManager"));
        address nodeWithdrawalAddress = rocketNodeManager.getNodeWithdrawalAddress(nodeAddress);
        // Transfer refund amount
        (bool success,) = nodeWithdrawalAddress.call{value: refundAmount}("");
        require(success, "ETH refund amount was not successfully transferred to node operator");
        // Emit ether withdrawn event
        emit EtherWithdrawn(nodeWithdrawalAddress, refundAmount, block.timestamp);
    }

    // Destroy the minipool
    function destroy() private {
        // Destroy minipool
        RocketMinipoolManagerInterface rocketMinipoolManager = RocketMinipoolManagerInterface(getContractAddress("rocketMinipoolManager"));
        rocketMinipoolManager.destroyMinipool();
        // Self destruct & send any remaining ETH to vault
        selfdestruct(payable(nodeAddress));
    }

}
