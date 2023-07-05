// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/NonZeroAddressGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract NonZeroAddressGuard {

    modifier nonZeroAddress(address _address) {
        require(_address != address(0), "Address must be non-zero");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/ErrorReporter.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenErrorReporter {
    enum Error {
        NO_ERROR,
        C_LEND_REJECTION,
        C_REDEEM_REJECTION,
        C_BORRROW_REJECTION,
        C_REPAY_REJECTION,
        C_CREATE_REJECTION,
        INSUFFICIENT_FUNDS,
        AMOUNT_LOWER_THAN_0,
        AMOUNT_HIGHER,
        AMOUNT_LOWER_THAN_MIN_DEPOSIT,
        NOT_ENOUGH_CASH,
        LOAN_HAS_DEBT,
        LOAN_IS_OVERDUE,
        LOAN_IS_NOT_CLOSED,
        LOAN_ASSET_ALREADY_USED,
        LOAN_IS_ALREADY_CLOSED,
        LOAN_PENALTY_NOT_PAYED,
        WRONG_BORROWER,
        TRANSFER_FAILED,
        LPP_TRANSFER_FAILED,
        POOL_NOT_FOUND
    }

    event Failure(uint256 error, uint256 detail);

    function fail(Error err, uint256 info) internal returns (uint256) {
        emit Failure(uint256(err), info);

        return uint256(err);
    }

    function toString(Error err) internal pure returns (string memory) {
        return ErrorReporter.uint2str(uint256(err));
    }
}

contract ControllerErrorReporter {
    enum Error {
        NO_ERROR,
        POOL_NOT_ACTIVE,
        BORROW_CAP_EXCEEDED,
        NOT_ALLOWED_TO_CREATE_CREDIT_LINE,
        BORROWER_NOT_CREATED,
        BORROWER_IS_WHITELISTED,
        BORROWER_NOT_WHITELISTED,
        ALREADY_WHITELISTED,
        INVALID_OWNER,
        MATURITY_DATE_EXPIRED,
        ASSET_REDEEMED,
        AMPT_TOKEN_TRANSFER_FAILED,
        LENDER_NOT_WHITELISTED,
        BORROWER_NOT_MEMBER,
        LENDER_NOT_CREATED
    }

    event Failure(uint256 error, uint256 detail);

    function fail(Error err) internal returns (uint256) {
        emit Failure(uint256(err), 0);

        return uint256(err);
    }

    function toString(Error err) internal pure returns (string memory) {
        return ErrorReporter.uint2str(uint256(err));
    }
}

library ErrorReporter {
    function check(uint256 err) internal pure {
        require(err == 0, uint2str(uint256(err)));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/CarefulMath.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract CarefulMath {

    enum MathError {
        NO_ERROR,
        DIVISION_BY_ZERO,
        INTEGER_OVERFLOW,
        INTEGER_UNDERFLOW
    }

    function mulUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (a == 0) {
            return (MathError.NO_ERROR, 0);
        }

        uint c = a * b;

        if (c / a != b) {
            return (MathError.INTEGER_OVERFLOW, 0);
        } else {
            return (MathError.NO_ERROR, c);
        }
    }

    function mulThenAddUInt(uint a, uint b, uint c) internal pure returns(MathError, uint) {
        (MathError err, uint mul) = mulUInt(a, b);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return addUInt(mul, c);
    }

    function divUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (b == 0) {
            return (MathError.DIVISION_BY_ZERO, 0);
        }

        return (MathError.NO_ERROR, a / b);
    }

    function subUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (b <= a) {
            return (MathError.NO_ERROR, a - b);
        } else {
            return (MathError.INTEGER_UNDERFLOW, 0);
        }
    }

    function subThenDivUInt(uint a, uint b, uint c) internal pure returns(MathError, uint) {
        (MathError err, uint sub) = subUInt(a, b);

        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return divUInt(sub, c);
    }

    function addUInt(uint a, uint b) internal pure returns(MathError, uint) {
        uint c = a + b;

        if (c >= a) {
            return (MathError.NO_ERROR, c);
        } else {
            return (MathError.INTEGER_OVERFLOW, 0);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/Exponential.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Exponential is CarefulMath {
    uint constant expScale = 1e18;
    uint constant halfScale = expScale / 2;
    uint constant mantissaOne = expScale;

    struct Exp {
        uint mantissa;
    }

    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: rational}));
    }

    function truncate(Exp memory exp) pure internal returns(uint) {
        return exp.mantissa / expScale;
    }

     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
    }

    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(product));
    }

    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }
        return addUInt(truncate(product), addend);
    }

    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
    }

    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint numerator) = mulUInt(expScale, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return getExp(numerator, divisor.mantissa);
    }

    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(fraction));
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/Counters.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Liquidity/Borrower.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract Borrowable is ReentrancyGuard, NonZeroAddressGuard, Exponential, TokenErrorReporter {
    using Counters for Counters.Counter;

    Counters.Counter private _loanIds;

    struct CreditLine {
        address borrower;
        uint256 borrowCap;
        uint256 borrowIndex;
        uint256 principal;
        uint256 lockedAsset;
        uint256 interestRate;
        uint256 accrualBlockNumber;
        bool isClosed;
    }

    struct PenaltyInfo {
        uint256 maturity;
        uint256 index;
        uint256 timestamp;
        bool isOpened;
    }

    CreditLine[] public creditLines;
    mapping(uint256 => PenaltyInfo) public penaltyInfo;

    mapping(uint256 => bool) public lockedAssetsIds;
    mapping(address => uint256[]) internal loansIdsByAddress;

    event CreditLineOpened(uint256 indexed loanId, uint256 indexed tokenId, address borrower, uint256 amount, uint256 maturity, uint256 interestRate);
    event CreditLineClosed(uint256 indexed loanId);
    event Borrowed(uint256 indexed loanId, uint256 _amount);
    event Repayed(uint256 indexed loanId, uint256 _amount, uint256 penaltyAmount);
    event AssetUnlocked(uint256 indexed tokenId);

    modifier onlyIfActive(uint256 _loanId, address borrower_) {
        _isActive(_loanId, borrower_);
        _;
    }

    function _isActive(uint256 _loanId, address borrower_) internal view {
        require(creditLines[_loanId].isClosed == false, toString(Error.LOAN_IS_ALREADY_CLOSED));
        require(creditLines[_loanId].borrower == borrower_, toString(Error.WRONG_BORROWER));
    }

    function totalPrincipal() public virtual view returns (uint256) {
        uint256 total = 0;
        for (uint8 i = 0; i < creditLines.length; i++) {
            total += creditLines[i].principal;
        }
        return total;
    }

    function totalInterestRate() public virtual view returns (uint256) {
        uint256 total = 0;
        for (uint8 i = 0; i < creditLines.length; i++) {
            total += creditLines[i].interestRate;
        }
        if (total != 0){
            return total / creditLines.length;
        }
        return total;
    }

    /** @dev used by rewards contract */
    function getBorrowerTotalPrincipal(address _borrower) external view returns (uint256) {
        uint256 balance;

        for(uint8 i=0; i < loansIdsByAddress[_borrower].length; i++) {
            uint256 loanId = loansIdsByAddress[_borrower][i];

            uint256 principal = creditLines[loanId].principal;
            bool penaltyStarted = penaltyInfo[loanId].isOpened;
            balance += penaltyStarted ? 0 : principal;
        }
        return balance;
    }

    function getBorrowerBalance(address _borrower) external view returns (uint256) {
        uint256 balance;

        for(uint8 i=0; i < loansIdsByAddress[_borrower].length; i++) {
            balance += borrowBalanceSnapshot(loansIdsByAddress[_borrower][i]);
        }
        return balance;
    }

    function borrowerSnapshot(uint256 loanId) external view returns (uint256, uint256) {
        (,uint256 penaltyAmount) = getPenaltyIndexAndFee(loanId);
        return (borrowBalanceSnapshot(loanId), penaltyAmount);
    }

    function getBorrowerLoans(address _borrower) external view returns(uint256[] memory) {
        return loansIdsByAddress[_borrower];
    }

    function createCreditLineInternal(address borrower, uint256 tokenId, uint256 borrowCap, uint256 interestRate, uint256 maturity) internal returns (uint256) {
        require(lockedAssetsIds[tokenId] == false, toString(Error.LOAN_ASSET_ALREADY_USED));
        uint256 loanId = _loanIds.current();
        _loanIds;

        lockedAssetsIds[tokenId] = true;
        loansIdsByAddress[borrower].push(loanId);

        creditLines.push(CreditLine({
            borrower: borrower,
            borrowCap: borrowCap,
            borrowIndex: mantissaOne,
            principal: 0,
            lockedAsset: tokenId,
            interestRate: interestRate,
            accrualBlockNumber: getBlockNumber(),
            isClosed: false
        }));

        penaltyInfo[loanId] = PenaltyInfo({
            maturity: maturity,
            index: mantissaOne,
            timestamp: maturity + 30 days,
            isOpened: false
        });

        emit CreditLineOpened(loanId, tokenId, borrower, borrowCap, maturity, interestRate);

        _loanIds.increment();
        return uint256(Error.NO_ERROR);
    }

    function closeCreditLineInternal(address borrower, uint256 loanId) internal onlyIfActive(loanId, borrower) returns (uint256) {
        CreditLine storage creditLine = creditLines[loanId];
        require(creditLine.principal == 0, "Debt should be 0");

        lockedAssetsIds[creditLine.lockedAsset] = false;
        creditLine.isClosed = true;
        delete penaltyInfo[loanId];

        emit CreditLineClosed(loanId);
        return redeemAsset(creditLine.lockedAsset);
    }

    function unlockAssetInternal(address borrower, uint256 loanId) internal returns (MathError, uint256) {
        CreditLine storage creditLine = creditLines[loanId];

        require(creditLine.borrower == borrower, toString(Error.WRONG_BORROWER));
        require(creditLine.isClosed == true, toString(Error.LOAN_IS_NOT_CLOSED));

        uint256 lockedAsset = creditLine.lockedAsset;
        // remove loan from the list
        delete creditLines[loanId];
        delete penaltyInfo[loanId];

        emit AssetUnlocked(lockedAsset);
        return (MathError.NO_ERROR, lockedAsset);
    }

    struct BorrowLocalVars {
        MathError mathErr;
        uint256 availableAmount;
        uint256 currentBorrowBalance;
        uint256 newBorrowIndex;
        uint256 newPrincipal;
        uint256 currentTimestamp;
    }
    function borrowInternal(uint256 loanId, address borrower, uint256 amount) internal nonReentrant onlyIfActive(loanId, borrower) returns (uint256) {
        uint256 allowed = borrowAllowed(address(this), borrower, amount);
        require(allowed == 0, ErrorReporter.uint2str(allowed));
        
        CreditLine storage creditLine = creditLines[loanId];
        BorrowLocalVars memory vars;

        vars.currentTimestamp = getBlockTimestamp();
        require(vars.currentTimestamp < penaltyInfo[loanId].maturity, toString(Error.LOAN_IS_OVERDUE));

        (vars.mathErr, vars.availableAmount) = subUInt(creditLine.borrowCap, creditLine.principal);
        ErrorReporter.check(uint256(vars.mathErr));
        require(vars.availableAmount >= amount, toString(Error.INSUFFICIENT_FUNDS));

        vars.currentBorrowBalance = borrowBalanceSnapshot(loanId);
        vars.newBorrowIndex = getBorrowIndex(loanId);

        (vars.mathErr, vars.newPrincipal) = addUInt(vars.currentBorrowBalance, amount);
        require(vars.mathErr == MathError.NO_ERROR, "borrow: principal failed");

        creditLine.principal = vars.newPrincipal;
        creditLine.borrowIndex = vars.newBorrowIndex;
        creditLine.accrualBlockNumber = getBlockNumber();

        assert(_transferTokensOnBorrow(address(this), borrower, amount));
        emit Borrowed(loanId, amount);

        return uint256(Error.NO_ERROR);
    }

    struct RepayLocalVars {
        MathError mathErr;
        uint256 currentBorrowBalance;
        uint256 actualRepayAmount;
        uint256 penaltyIndex;
        uint256 penaltyAmount;
    }
    function repayInternal(uint256 loanId, address payer, address borrower, uint256 amount) internal onlyIfActive(loanId, borrower) nonReentrant returns (uint256) {
        uint256 allowed = repayAllowed(address(this), payer, borrower, amount);
        require(allowed == 0, toString(Error.C_REPAY_REJECTION));

        CreditLine storage creditLine = creditLines[loanId];
        PenaltyInfo storage _penaltyInfo = penaltyInfo[loanId];
        RepayLocalVars memory vars;

        vars.currentBorrowBalance = borrowBalanceSnapshot(loanId);
        (vars.penaltyIndex, vars.penaltyAmount) = getPenaltyIndexAndFee(loanId);

        if (vars.penaltyIndex - 1e18 > 1) {
            if (!_penaltyInfo.isOpened) {
                _penaltyInfo.isOpened = true;
            }
            _penaltyInfo.timestamp = getBlockTimestamp();
            (vars.mathErr, vars.actualRepayAmount) = addUInt(vars.currentBorrowBalance, vars.penaltyAmount);
            require(vars.mathErr == MathError.NO_ERROR, "repay: penalty amount failed");
        } else {
            vars.actualRepayAmount = vars.currentBorrowBalance;
        }

        if (amount == type(uint256).max) {
            amount = vars.actualRepayAmount;
        }
        require(vars.actualRepayAmount >= amount, toString(Error.AMOUNT_HIGHER));

        (vars.mathErr, creditLine.principal) = subUInt(vars.actualRepayAmount, amount);
        require(vars.mathErr == MathError.NO_ERROR, "repay: principal failed");
        
        creditLine.borrowIndex = getBorrowIndex(loanId);
        creditLine.accrualBlockNumber = getBlockNumber();
        _penaltyInfo.index = vars.penaltyIndex;

        assert(_transferTokensOnRepay(payer, address(this), amount, vars.penaltyAmount));
        
        emit Repayed(loanId, amount, vars.penaltyAmount);
        if (creditLine.principal == 0) {
            require(closeCreditLineInternal(borrower, loanId) == 0, "close failed");
        }

        return uint256(Error.NO_ERROR);
    }
    
    struct BorrowBalanceLocalVars {
        MathError mathErr;
        uint256 principalTimesIndex;
        uint256 borrowBalance;
        uint256 borrowIndex;
    }
    function borrowBalanceSnapshot(uint256 loanId) internal view returns (uint256) {
        CreditLine storage creditLine = creditLines[loanId];
        if(creditLine.principal == 0) {
            return 0;
        }

        BorrowBalanceLocalVars memory vars;

        vars.borrowIndex = getBorrowIndex(loanId);
        (vars.mathErr, vars.principalTimesIndex) = mulUInt(creditLine.principal, vars.borrowIndex);
        require(vars.mathErr == MathError.NO_ERROR, "principal times failed");

        (vars.mathErr, vars.borrowBalance) = divUInt(vars.principalTimesIndex, creditLine.borrowIndex);
        require(vars.mathErr == MathError.NO_ERROR, "borrowBalance failed");

        return vars.borrowBalance;
    }

    function _transferTokensOnBorrow(address from, address to, uint256 amount) internal virtual returns (bool);
    function _transferTokensOnRepay(address from, address to, uint256 amount, uint256 penaltyAmount) internal virtual returns (bool);

    function borrowAllowed(address _pool, address _borrower, uint256 _amount) internal virtual returns (uint256);
    function repayAllowed(address _pool, address _payer, address _borrower, uint256 _amount) internal virtual returns (uint256);
    function redeemAsset(uint256 tokenId) internal virtual returns (uint256);

    function getBorrowIndex(uint256 loanId) public virtual view returns (uint256);
    function getTotalBorrowBalance() public virtual view returns (uint256);
    function getPenaltyIndexAndFee(uint256 loanId) public virtual view returns (uint256, uint256);
    function getBlockNumber() public virtual returns(uint256);
    function getBlockTimestamp() public virtual returns(uint256);
}
