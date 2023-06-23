pragma solidity ^0.5.16;

pragma experimental ABIEncoderV2;

// Inheritance
import "./Collateral.sol";
import "./interfaces/ICollateral.sol";

// Internal references
import "./CollateralState.sol";

// This contract handles the payable aspects of eth loans.
contract CollateralEth is Collateral, ICollateralEth {

    mapping(address => uint) public pendingWithdrawals;

    constructor(
        CollateralState _state,
        address _owner,
        address _manager,
        address _resolver,
        bytes32 _collateralKey,
        bytes32[] memory _synths,
        uint _minimumCollateralisation,
        uint _interestRate,
        uint _liquidationPenalty
    ) 
    public 
    Collateral(
        _state, 
        _owner, 
        _manager,
        _resolver, 
        _collateralKey, 
        _synths, 
        _minimumCollateralisation, 
        _interestRate, 
        _liquidationPenalty
        )
    { }

    function open(uint amount, bytes32 currency) external payable {
        openInternal(msg.value, amount, currency);
    }
    
    function close(uint id) external {
        uint256 collateral = closeInternal(msg.sender, id);

        pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(collateral);
    }

    function deposit(address borrower, uint id) external payable {
        depositInternal(borrower, id, msg.value);
    }

    function withdraw(uint id, uint withdrawAmount) external {
        uint amount = withdrawInternal(id, withdrawAmount);

        pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(amount);
    }

    function repay(address account, uint id, uint amount) external {
        repayInternal(account, msg.sender, id, amount);
    }

    function liquidate(address borrower, uint id, uint amount) external {
        uint collateralLiquidated = liquidateInternal(borrower, id, amount);

        pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(collateralLiquidated);
    }

    function claim(uint amount) external {
        require(pendingWithdrawals[msg.sender] >= amount, "You cannot withdraw more than your total balance");

        pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].sub(amount);

// SWC-Message call with hardcoded gas amount: L78
        msg.sender.transfer(amount);
    }
}