


pragma solidity 0.8.7;


















library Errors {
  
  string public constant CALLER_NOT_POOL_ADMIN = '33'; 

  
  string public constant VL_INVALID_AMOUNT = '1'; 
  string public constant VL_NO_ACTIVE_RESERVE = '2'; 
  string public constant VL_RESERVE_FROZEN = '3'; 
  string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; 
  string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; 
  string public constant VL_BORROWING_NOT_ENABLED = '7'; 
  string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = '8'; 
  string public constant VL_COLLATERAL_BALANCE_IS_0 = '9'; 
  string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; 
  string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; 
  string public constant VL_STABLE_BORROWING_NOT_ENABLED = '12'; 
  string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; 
  string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; 
  string public constant VL_NO_DEBT_OF_SELECTED_TYPE = '15'; 
  string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; 
  string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; 
  string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; 
  string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; 
  string public constant VL_SUPPLIED_ASSETS_ALREADY_IN_USE = '20'; 
  string public constant P_NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; 
  string public constant P_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; 
  string public constant P_LIQUIDATION_CALL_FAILED = '23'; 
  string public constant P_NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; 
  string public constant P_REQUESTED_AMOUNT_TOO_SMALL = '25'; 
  string public constant P_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; 
  string public constant P_CALLER_NOT_POOL_CONFIGURATOR = '27'; 
  string public constant P_INCONSISTENT_FLASHLOAN_PARAMS = '28';
  string public constant CT_CALLER_MUST_BE_POOL = '29'; 
  string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; 
  string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = '31'; 
  string public constant RL_RESERVE_ALREADY_INITIALIZED = '32'; 
  string public constant PC_RESERVE_LIQUIDITY_NOT_0 = '34'; 
  string public constant PC_INVALID_ATOKEN_POOL_ADDRESS = '35'; 
  string public constant PC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = '36'; 
  string public constant PC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = '37'; 
  string public constant PC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '38'; 
  string public constant PC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '39'; 
  string public constant PC_INVALID_ADDRESSES_PROVIDER_ID = '40'; 
  string public constant PC_INVALID_CONFIGURATION = '75'; 
  string public constant PC_CALLER_NOT_EMERGENCY_ADMIN = '76'; 
  string public constant PAPR_PROVIDER_NOT_REGISTERED = '41'; 
  string public constant VL_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; 
  string public constant VL_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; 
  string public constant VL_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; 
  string public constant VL_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; 
  string public constant P_INVALID_FLASHLOAN_MODE = '47'; 
  string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
  string public constant MATH_ADDITION_OVERFLOW = '49';
  string public constant MATH_DIVISION_BY_ZERO = '50';
  string public constant CT_INVALID_MINT_AMOUNT = '56'; 
  string public constant CT_INVALID_BURN_AMOUNT = '58'; 
  string public constant P_REENTRANCY_NOT_ALLOWED = '62';
  string public constant P_CALLER_MUST_BE_AN_ATOKEN = '63';
  string public constant P_IS_PAUSED = '64'; 
  string public constant P_NO_MORE_RESERVES_ALLOWED = '65';
  string public constant P_INVALID_FLASH_LOAN_EXECUTOR_RETURN = '66';
  string public constant RC_INVALID_LTV = '67';
  string public constant RC_INVALID_LIQ_THRESHOLD = '68';
  string public constant RC_INVALID_LIQ_BONUS = '69';
  string public constant RC_INVALID_DECIMALS = '70';
  string public constant RC_INVALID_RESERVE_FACTOR = '71';
  string public constant PAPR_INVALID_ADDRESSES_PROVIDER_ID = '72';
  string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = '73';
  string public constant P_INCONSISTENT_PARAMS_LENGTH = '74';
  string public constant UL_INVALID_INDEX = '77';
  string public constant P_NOT_CONTRACT = '78';
  string public constant SDT_STABLE_DEBT_OVERFLOW = '79'; 
  string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
  string public constant VL_BORROW_CAP_EXCEEDED = '81';
  string public constant RC_INVALID_BORROW_CAP = '82';
  string public constant VL_SUPPLY_CAP_EXCEEDED = '83';
  string public constant RC_INVALID_SUPPLY_CAP = '84';
  string public constant PC_CALLER_NOT_EMERGENCY_OR_POOL_ADMIN = '85';
  string public constant VL_RESERVE_PAUSED = '86';
  string public constant PC_CALLER_NOT_RISK_OR_POOL_ADMIN = '87';
  string public constant RL_ATOKEN_SUPPLY_NOT_ZERO = '88';
  string public constant RL_STABLE_DEBT_NOT_ZERO = '89';
  string public constant RL_VARIABLE_DEBT_SUPPLY_NOT_ZERO = '90';
  string public constant VL_LTV_VALIDATION_FAILED = '93';
  string public constant VL_SAME_BLOCK_BORROW_REPAY = '94';
  string public constant PC_FLASHLOAN_PREMIUMS_MISMATCH = '95';
  string public constant PC_FLASHLOAN_PREMIUM_INVALID = '96';
  string public constant RC_INVALID_LIQUIDATION_PROTOCOL_FEE = '97';
  string public constant RC_INVALID_EMODE_CATEGORY = '98';
  string public constant VL_INCONSISTENT_EMODE_CATEGORY = '99';
  string public constant HLP_UINT128_OVERFLOW = '100';
  string public constant PC_CALLER_NOT_ASSET_LISTING_OR_POOL_ADMIN = '101';
  string public constant P_CALLER_NOT_BRIDGE = '102';
  string public constant RC_INVALID_UNBACKED_MINT_CAP = '103';
  string public constant VL_UNBACKED_MINT_CAP_EXCEEDED = '104';
  string public constant VL_PRICE_ORACLE_SENTINEL_CHECK_FAILED = '105';
  string public constant RC_INVALID_DEBT_CEILING = '106';
  string public constant VL_INVALID_ISOLATION_MODE_BORROW_CATEGORY = '107';
  string public constant VL_DEBT_CEILING_CROSSED = '108';
  string public constant SL_USER_IN_ISOLATION_MODE = '109';
  string public constant PC_BRIDGE_PROTOCOL_FEE_INVALID = '110';
}




pragma solidity 0.8.7;







library WadRayMath {
  uint256 internal constant WAD = 1e18;
  uint256 internal constant HALF_WAD = WAD / 2;

  uint256 public constant RAY = 1e27;
  uint256 internal constant HALF_RAY = RAY / 2;

  uint256 internal constant WAD_RAY_RATIO = 1e9;

  



  function wad() internal pure returns (uint256) {
    return WAD;
  }

  


  function halfRay() internal pure returns (uint256) {
    return HALF_RAY;
  }

  


  function halfWad() internal pure returns (uint256) {
    return HALF_WAD;
  }

  





  function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      if (a == 0 || b == 0) {
        return 0;
      }

      require(a <= (type(uint256).max - HALF_WAD) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * b + HALF_WAD) / WAD;
    }
  }

  





  function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      uint256 halfB = b / 2;

      require(a <= (type(uint256).max - halfB) / WAD, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * WAD + halfB) / b;
    }
  }

  





  function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      if (a == 0 || b == 0) {
        return 0;
      }

      require(a <= (type(uint256).max - HALF_RAY) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * b + HALF_RAY) / RAY;
    }
  }

  





  function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      uint256 halfB = b / 2;

      require(a <= (type(uint256).max - halfB) / RAY, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * RAY + halfB) / b;
    }
  }

  




  function rayToWad(uint256 a) internal pure returns (uint256) {
    unchecked {
      uint256 halfRatio = WAD_RAY_RATIO / 2;
      uint256 result = halfRatio + a;
      require(result >= halfRatio, Errors.MATH_ADDITION_OVERFLOW);

      return result / WAD_RAY_RATIO;
    }
  }

  




  function wadToRay(uint256 a) internal pure returns (uint256 result) {
    unchecked {
      require(
        (result = a * WAD_RAY_RATIO) / WAD_RAY_RATIO == a,
        Errors.MATH_MULTIPLICATION_OVERFLOW
      );
    }
  }
}