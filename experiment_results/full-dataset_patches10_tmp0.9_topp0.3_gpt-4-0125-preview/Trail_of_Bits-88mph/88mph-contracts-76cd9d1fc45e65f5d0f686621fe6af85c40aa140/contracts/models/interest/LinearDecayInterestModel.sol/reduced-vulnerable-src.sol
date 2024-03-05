


pragma solidity 0.8.3;


library DecMath {
    uint256 internal constant PRECISION = 10**18;

    function decmul(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * b) / PRECISION;
    }

    function decdiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * PRECISION) / b;
    }
}




pragma solidity 0.8.3;

interface IInterestModel {
    function calculateInterestAmount(
        uint256 depositAmount,
        uint256 depositPeriodInSeconds,
        uint256 moneyMarketInterestRatePerSecond,
        bool surplusIsNegative,
        uint256 surplusAmount
    ) external view returns (uint256 interestAmount);
}




pragma solidity 0.8.3;


contract LinearDecayInterestModel is IInterestModel {
    using DecMath for uint256;

    uint256 public constant PRECISION = 10**18;
    uint256 public multiplierIntercept;
    uint256 public multiplierSlope;

    constructor(uint256 _multiplierIntercept, uint256 _multiplierSlope) {
        multiplierIntercept = _multiplierIntercept;
        multiplierSlope = _multiplierSlope;
    }

    function getIRMultiplier(uint256 depositPeriodInSeconds)
        public
        view
        returns (uint256)
    {
        uint256 multiplierDecrease = depositPeriodInSeconds * multiplierSlope;
        if (multiplierDecrease >= multiplierIntercept) {
            return 0;
        } else {
            return multiplierIntercept - multiplierDecrease;
        }
    }

    function calculateInterestAmount(
        uint256 depositAmount,
        uint256 depositPeriodInSeconds,
        uint256 moneyMarketInterestRatePerSecond,
        bool, 
        uint256 
    ) external view override returns (uint256 interestAmount) {
        
        interestAmount =
            ((depositAmount * PRECISION)
                .decmul(moneyMarketInterestRatePerSecond)
                .decmul(getIRMultiplier(depositPeriodInSeconds)) *
                depositPeriodInSeconds) /
            PRECISION;
    }
}