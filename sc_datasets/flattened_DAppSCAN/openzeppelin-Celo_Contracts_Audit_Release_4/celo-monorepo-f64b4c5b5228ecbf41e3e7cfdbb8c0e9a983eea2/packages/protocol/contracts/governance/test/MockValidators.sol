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

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/governance/test/MockValidators.sol

pragma solidity ^0.5.13;

/**
 * @title Holds a list of addresses of validators
 */
contract MockValidators {
  using SafeMath for uint256;

  uint256 private constant FIXED1_UINT = 1000000000000000000000000;

  mapping(address => bool) public isValidator;
  mapping(address => bool) public isValidatorGroup;
  mapping(address => uint256) private numGroupMembers;
  mapping(address => uint256) private lockedGoldRequirements;
  mapping(address => bool) private doesNotMeetAccountLockedGoldRequirements;
  mapping(address => address[]) private members;
  mapping(address => address) private affiliations;
  uint256 private numRegisteredValidators;

  function updateEcdsaPublicKey(address, address, bytes calldata) external returns (bool) {
    return true;
  }

  function updatePublicKeys(address, address, bytes calldata, bytes calldata, bytes calldata)
    external
    returns (bool)
  {
    return true;
  }

  function setValidator(address account) external {
    isValidator[account] = true;
  }

  function setValidatorGroup(address group) external {
    isValidatorGroup[group] = true;
  }

  function affiliate(address group) external returns (bool) {
    affiliations[msg.sender] = group;
    return true;
  }

  function setDoesNotMeetAccountLockedGoldRequirements(address account) external {
    doesNotMeetAccountLockedGoldRequirements[account] = true;
  }

  function meetsAccountLockedGoldRequirements(address account) external view returns (bool) {
    return !doesNotMeetAccountLockedGoldRequirements[account];
  }

  function getGroupNumMembers(address group) public view returns (uint256) {
    return members[group].length;
  }

  function setNumRegisteredValidators(uint256 value) external {
    numRegisteredValidators = value;
  }

  function getNumRegisteredValidators() external view returns (uint256) {
    return numRegisteredValidators;
  }

  function setMembers(address group, address[] calldata _members) external {
    members[group] = _members;
  }

  function setAccountLockedGoldRequirement(address account, uint256 value) external {
    lockedGoldRequirements[account] = value;
  }

  function getAccountLockedGoldRequirement(address account) external view returns (uint256) {
    return lockedGoldRequirements[account];
  }

  function calculateGroupEpochScore(uint256[] calldata uptimes) external view returns (uint256) {
    return uptimes[0];
  }

  function getTopGroupValidators(address group, uint256 n)
    external
    view
    returns (address[] memory)
  {
    require(n <= members[group].length);
    address[] memory validators = new address[](n);
    for (uint256 i = 0; i < n; i = i.add(1)) {
      validators[i] = members[group][i];
    }
    return validators;
  }

  function getGroupsNumMembers(address[] calldata groups) external view returns (uint256[] memory) {
    uint256[] memory numMembers = new uint256[](groups.length);
    for (uint256 i = 0; i < groups.length; i = i.add(1)) {
      numMembers[i] = getGroupNumMembers(groups[i]);
    }
    return numMembers;
  }

  function groupMembershipInEpoch(address addr, uint256, uint256) external view returns (address) {
    return affiliations[addr];
  }

  function halveSlashingMultiplier(address) external {}

  function forceDeaffiliateIfValidator(address validator) external {}
  function getValidatorGroupSlashingMultiplier(address) external view returns (uint256) {
    return FIXED1_UINT;
  }
}
