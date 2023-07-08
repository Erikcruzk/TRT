// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/specs/harnesses/IRegistryExtended.sol

pragma solidity ^0.5.13;

contract IRegistryExtended {
  /* does not extend IRegistry to avoid overriding issues */
  // SG: Instrumentation
  function isValidating(address) external returns (bool);
  function getTotalWeight() external returns (uint256);
  function getVoterFromAccount(address) external returns (address);
  function getAccountWeight(address) external returns (uint256);
  function getAccountFromVoter(address voter) external returns (address);

}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/specs/harnesses/RegistryHarness.sol

pragma solidity ^0.5.13;


contract RegistryHarness is IRegistryExtended {
  using SafeMath for uint256;

  bytes32 constant ATTESTATIONS_REGISTRY_ID = keccak256(abi.encodePacked("Attestations"));
  bytes32 constant LOCKED_GOLD_REGISTRY_ID = keccak256(abi.encodePacked("LockedGold"));
  bytes32 constant GAS_CURRENCY_WHITELIST_REGISTRY_ID = keccak256(
    abi.encodePacked("GasCurrencyWhitelist")
  );
  bytes32 constant GOLD_TOKEN_REGISTRY_ID = keccak256(abi.encodePacked("GoldToken"));
  bytes32 constant GOVERNANCE_REGISTRY_ID = keccak256(abi.encodePacked("Governance"));
  bytes32 constant RESERVE_REGISTRY_ID = keccak256(abi.encodePacked("Reserve"));
  bytes32 constant RANDOM_REGISTRY_ID = keccak256(abi.encodePacked("Random"));
  bytes32 constant SORTED_ORACLES_REGISTRY_ID = keccak256(abi.encodePacked("SortedOracles"));
  bytes32 constant VALIDATORS_REGISTRY_ID = keccak256(abi.encodePacked("Validators"));

  uint256 constant iamValidators = 1;
  uint256 constant iamGoldToken = 2;
  uint256 constant iamGovernance = 3;
  uint256 constant iamLockedGold = 4;

  uint256 whoami;

  function getAddressFor(bytes32 identifier) public returns (address) {
    if (identifier == VALIDATORS_REGISTRY_ID) {
      whoami = iamValidators;
    } else if (identifier == GOLD_TOKEN_REGISTRY_ID) {
      whoami = iamGoldToken;
    } else if (identifier == GOVERNANCE_REGISTRY_ID) {
      whoami = iamGovernance;
    } else if (identifier == LOCKED_GOLD_REGISTRY_ID) {
      whoami = iamLockedGold;
    }

    // Need to statically reason that registry always returns itself now.
    // In particular if can call state-modifying code through the registry (goldToken?).
    return address(this);
  }

  function getAddressForOrDie(bytes32 identifier) external returns (address) {
    address _addr = getAddressFor(identifier);

    require(_addr != address(0), "Identifier not recognized");
    return _addr;
  }

  // Local fields from other contracts are prefixed with contract name.
  // Ex: contractName_fieldName
  mapping(address => bool) validators_validating;
  mapping(address => bool) governance_isVoting;
  mapping(address => bool) validators_isVoting;

  uint256 lockedGold_totalWeight;
  mapping(address => uint256) lockedGold_accountWeight;
  mapping(address => address) lockedGold_accountFromVoter;
  mapping(address => address) lockedGold_voterFromAccount;
  mapping(address => bool) lockedGold_isVotingFrozen;

  mapping(address => uint256) goldToken_balanceOf;

  uint256 randomIndex;
  mapping(uint256 => bool) randomBoolMap;
  mapping(uint256 => uint256) randomUInt256Map;
  mapping(uint256 => address) randomAddressMap;

  function isValidating(address account) external returns (bool) {
    if (whoami == iamValidators) {
      return validators_validating[account];
    } else {
      return getRandomBool();
    }
  }

  function isVoting(address x) external returns (bool) {
    if (whoami == iamValidators) {
      return validators_isVoting[x];
    } else if (whoami == iamGovernance) {
      return governance_isVoting[x];
    } else {
      return getRandomBool();
    }
  }

  function getTotalWeight() external returns (uint256) {
    if (true || whoami == iamLockedGold) {
      return lockedGold_totalWeight;
    } else {
      return getRandomUInt256();
    }
  }

  function getAccountWeight(address account) external returns (uint256) {
    if (true || whoami == iamLockedGold) {
      return lockedGold_accountWeight[account];
    } else {
      return getRandomUInt256();
    }
  }

  function getAccountFromVoter(address voter) external returns (address) {
    if (true || whoami == iamLockedGold) {
      return lockedGold_accountFromVoter[voter];
    } else {
      return getRandomAddress();
    }
  }

  function getVoterFromAccount(address account) external returns (address) {
    if (true || whoami == iamLockedGold) {
      return lockedGold_voterFromAccount[account];
    } else {
      return getRandomAddress();
    }
  }

  function isVotingFrozen(address account) external returns (bool) {
    if (whoami == iamLockedGold) {
      return lockedGold_isVotingFrozen[account];
    } else {
      return getRandomBool();
    }
  }

  function transfer(address recipient, uint256 value) external returns (bool) {
    goldToken_balanceOf[msg.sender] = getRandomUInt256().sub(value);
    goldToken_balanceOf[recipient] = getRandomUInt256().add(value);
    return getRandomBool();
  }

  function getRandomBool() public returns (bool) {
    randomIndex = randomIndex.add(1);
    return randomBoolMap[randomIndex];
  }

  function getRandomUInt256() public returns (uint256) {
    randomIndex = randomIndex.add(1);
    return randomUInt256Map[randomIndex];
  }

  function getRandomAddress() public returns (address) {
    randomIndex = randomIndex.add(1);
    return randomAddressMap[randomIndex];
  }

}
