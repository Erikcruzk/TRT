




pragma solidity ^0.8.0;











abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}






pragma solidity ^0.8.0;













abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    


    constructor() {
        _transferOwnership(_msgSender());
    }

    


    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    


    function owner() public view virtual returns (address) {
        return _owner;
    }

    


    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    






    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    



    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    



    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}




pragma solidity 0.8.3;

interface IFeeModel {
    function beneficiary() external view returns (address payable);

    function getInterestFeeAmount(address pool, uint256 interestAmount)
        external
        view
        returns (uint256 feeAmount);

    function getEarlyWithdrawFeeAmount(
        address pool,
        uint64 depositID,
        uint256 withdrawnDepositAmount
    ) external view returns (uint256 feeAmount);
}




pragma solidity 0.8.3;


contract PercentageFeeModel is IFeeModel, Ownable {
    uint256 internal constant PRECISION = 10**18;
    uint256 internal constant MAX_INTEREST_FEE = 50 * 10**16; 
    uint256 internal constant MAX_EARLY_WITHDRAW_FEE = 5 * 10**16; 

    struct FeeOverride {
        bool isOverridden;
        uint256 fee;
    }

    address payable public override beneficiary;
    mapping(address => FeeOverride) public interestFeeOverrideForPool;
    mapping(address => FeeOverride) public earlyWithdrawFeeOverrideForPool;
    mapping(address => mapping(uint64 => FeeOverride))
        public earlyWithdrawFeeOverrideForDeposit;

    uint256 public interestFee;
    uint256 public earlyWithdrawFee;

    event SetBeneficiary(address newBeneficiary);
    event SetInterestFee(uint256 newValue);
    event SetEarlyWithdrawFee(uint256 newValue);
    event OverrideInterestFeeForPool(address indexed pool, uint256 newFee);
    event OverrideEarlyWithdrawFeeForPool(address indexed pool, uint256 newFee);
    event OverrideEarlyWithdrawFeeForDeposit(
        address indexed pool,
        uint64 indexed depositID,
        uint256 newFee
    );

    constructor(
        address payable _beneficiary,
        uint256 _interestFee,
        uint256 _earlyWithdrawFee
    ) {
        require(
            _beneficiary != address(0) &&
                _interestFee <= MAX_INTEREST_FEE &&
                _earlyWithdrawFee <= MAX_EARLY_WITHDRAW_FEE,
            "PercentageFeeModel: invalid input"
        );
        beneficiary = _beneficiary;
        interestFee = _interestFee;
        earlyWithdrawFee = _earlyWithdrawFee;
    }

    function getInterestFeeAmount(address pool, uint256 interestAmount)
        external
        view
        override
        returns (uint256 feeAmount)
    {
        uint256 feeRate;
        FeeOverride memory feeOverrideForPool =
            interestFeeOverrideForPool[pool];
        if (feeOverrideForPool.isOverridden) {
            
            feeRate = feeOverrideForPool.fee;
        } else {
            
            feeRate = interestFee;
        }
        return (interestAmount * feeRate) / PRECISION;
    }

    function getEarlyWithdrawFeeAmount(
        address pool,
        uint64 depositID,
        uint256 withdrawnDepositAmount
    ) external view override returns (uint256 feeAmount) {
        uint256 feeRate;
        FeeOverride memory feeOverrideForDeposit =
            earlyWithdrawFeeOverrideForDeposit[pool][depositID];
        if (feeOverrideForDeposit.isOverridden) {
            
            feeRate = feeOverrideForDeposit.fee;
        } else {
            FeeOverride memory feeOverrideForPool =
                earlyWithdrawFeeOverrideForPool[pool];
            if (feeOverrideForPool.isOverridden) {
                
                feeRate = feeOverrideForPool.fee;
            } else {
                
                feeRate = earlyWithdrawFee;
            }
        }
        return (withdrawnDepositAmount * feeRate) / PRECISION;
    }

    function setBeneficiary(address payable newValue) external onlyOwner {
        require(newValue != address(0), "PercentageFeeModel: 0 address");
        beneficiary = newValue;
        emit SetBeneficiary(newValue);
    }

    function setInterestFee(uint256 newValue) external onlyOwner {
        require(newValue <= MAX_INTEREST_FEE, "PercentageFeeModel: too big");
        interestFee = newValue;
        emit SetInterestFee(newValue);
    }

    function setEarlyWithdrawFee(uint256 newValue) external onlyOwner {
        require(
            newValue <= MAX_EARLY_WITHDRAW_FEE,
            "PercentageFeeModel: too big"
        );
        earlyWithdrawFee = newValue;
        emit SetEarlyWithdrawFee(newValue);
    }

    function overrideInterestFeeForPool(address pool, uint256 newFee)
        external
        onlyOwner
    {
        require(newFee <= interestFee, "PercentageFeeModel: too big");
        interestFeeOverrideForPool[pool] = FeeOverride({
            isOverridden: true,
            fee: newFee
        });
        emit OverrideInterestFeeForPool(pool, newFee);
    }

    function overrideEarlyWithdrawFeeForPool(address pool, uint256 newFee)
        external
        onlyOwner
    {
        require(newFee <= earlyWithdrawFee, "PercentageFeeModel: too big");
        earlyWithdrawFeeOverrideForPool[pool] = FeeOverride({
            isOverridden: true,
            fee: newFee
        });
        emit OverrideEarlyWithdrawFeeForPool(pool, newFee);
    }

    function overrideEarlyWithdrawFeeForDeposit(
        address pool,
        uint64 depositID,
        uint256 newFee
    ) external onlyOwner {
        require(newFee <= earlyWithdrawFee, "PercentageFeeModel: too big");
        earlyWithdrawFeeOverrideForDeposit[pool][depositID] = FeeOverride({
            isOverridden: true,
            fee: newFee
        });
        emit OverrideEarlyWithdrawFeeForDeposit(pool, depositID, newFee);
    }
}