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

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/common/linkedlists/LinkedList.sol

pragma solidity ^0.5.13;

/**
 * @title Maintains a doubly linked list keyed by bytes32.
 * @dev Following the `next` pointers will lead you to the head, rather than the tail.
 */
library LinkedList {
  using SafeMath for uint256;

  struct Element {
    bytes32 previousKey;
    bytes32 nextKey;
    bool exists;
  }

  struct List {
    bytes32 head;
    bytes32 tail;
    uint256 numElements;
    mapping(bytes32 => Element) elements;
  }

  /**
   * @notice Inserts an element into a doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   * @param previousKey The key of the element that comes before the element to insert.
   * @param nextKey The key of the element that comes after the element to insert.
   */
  function insert(List storage list, bytes32 key, bytes32 previousKey, bytes32 nextKey) internal {
    require(key != bytes32(0), "Key must be defined");
    require(!contains(list, key), "Can't insert an existing element");
    require(
      previousKey != key && nextKey != key,
      "Key cannot be the same as previousKey or nextKey"
    );

    Element storage element = list.elements[key];
    element.exists = true;

    if (list.numElements == 0) {
      list.tail = key;
      list.head = key;
    } else {
      require(
        previousKey != bytes32(0) || nextKey != bytes32(0),
        "Either previousKey or nextKey must be defined"
      );

      element.previousKey = previousKey;
      element.nextKey = nextKey;

      if (previousKey != bytes32(0)) {
        require(
          contains(list, previousKey),
          "If previousKey is defined, it must exist in the list"
        );
        Element storage previousElement = list.elements[previousKey];
        require(previousElement.nextKey == nextKey, "previousKey must be adjacent to nextKey");
        previousElement.nextKey = key;
      } else {
        list.tail = key;
      }

      if (nextKey != bytes32(0)) {
        require(contains(list, nextKey), "If nextKey is defined, it must exist in the list");
        Element storage nextElement = list.elements[nextKey];
        require(nextElement.previousKey == previousKey, "previousKey must be adjacent to nextKey");
        nextElement.previousKey = key;
      } else {
        list.head = key;
      }
    }

    list.numElements = list.numElements.add(1);
  }

  /**
   * @notice Inserts an element at the tail of the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   */
  function push(List storage list, bytes32 key) internal {
    insert(list, key, bytes32(0), list.tail);
  }

  /**
   * @notice Removes an element from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to remove.
   */
  function remove(List storage list, bytes32 key) internal {
    Element storage element = list.elements[key];
    require(key != bytes32(0) && contains(list, key), "key not in list");
    if (element.previousKey != bytes32(0)) {
      Element storage previousElement = list.elements[element.previousKey];
      previousElement.nextKey = element.nextKey;
    } else {
      list.tail = element.nextKey;
    }

    if (element.nextKey != bytes32(0)) {
      Element storage nextElement = list.elements[element.nextKey];
      nextElement.previousKey = element.previousKey;
    } else {
      list.head = element.previousKey;
    }

    delete list.elements[key];
    list.numElements = list.numElements.sub(1);
  }

  /**
   * @notice Updates an element in the list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @param previousKey The key of the element that comes before the updated element.
   * @param nextKey The key of the element that comes after the updated element.
   */
  function update(List storage list, bytes32 key, bytes32 previousKey, bytes32 nextKey) internal {
    require(
      key != bytes32(0) && key != previousKey && key != nextKey && contains(list, key),
      "key on in list"
    );
    remove(list, key);
    insert(list, key, previousKey, nextKey);
  }

  /**
   * @notice Returns whether or not a particular key is present in the sorted list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @return Whether or not the key is in the sorted list.
   */
  function contains(List storage list, bytes32 key) internal view returns (bool) {
    return list.elements[key].exists;
  }

  /**
   * @notice Returns the keys of the N elements at the head of the list.
   * @param list A storage pointer to the underlying list.
   * @param n The number of elements to return.
   * @return The keys of the N elements at the head of the list.
   * @dev Reverts if n is greater than the number of elements in the list.
   */
  function headN(List storage list, uint256 n) internal view returns (bytes32[] memory) {
    require(n <= list.numElements, "not enough elements");
    bytes32[] memory keys = new bytes32[](n);
    bytes32 key = list.head;
    for (uint256 i = 0; i < n; i = i.add(1)) {
      keys[i] = key;
      key = list.elements[key].previousKey;
    }
    return keys;
  }

  /**
   * @notice Gets all element keys from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @return All element keys from head to tail.
   */
  function getKeys(List storage list) internal view returns (bytes32[] memory) {
    return headN(list, list.numElements);
  }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/common/linkedlists/SortedLinkedList.sol

pragma solidity ^0.5.13;


/**
 * @title Maintains a sorted list of unsigned ints keyed by bytes32.
 */
library SortedLinkedList {
  using SafeMath for uint256;
  using LinkedList for LinkedList.List;

  struct List {
    LinkedList.List list;
    mapping(bytes32 => uint256) values;
  }

  /**
   * @notice Inserts an element into a doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   * @param value The element value.
   * @param lesserKey The key of the element less than the element to insert.
   * @param greaterKey The key of the element greater than the element to insert.
   */
  function insert(
    List storage list,
    bytes32 key,
    uint256 value,
    bytes32 lesserKey,
    bytes32 greaterKey
  ) internal {
    require(
      key != bytes32(0) && key != lesserKey && key != greaterKey && !contains(list, key),
      "invalid key"
    );
    require(
      (lesserKey != bytes32(0) || greaterKey != bytes32(0)) || list.list.numElements == 0,
      "greater and lesser key zero"
    );
    require(contains(list, lesserKey) || lesserKey == bytes32(0), "invalid lesser key");
    require(contains(list, greaterKey) || greaterKey == bytes32(0), "invalid greater key");
    (lesserKey, greaterKey) = getLesserAndGreater(list, value, lesserKey, greaterKey);
    list.list.insert(key, lesserKey, greaterKey);
    list.values[key] = value;
  }

  /**
   * @notice Removes an element from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to remove.
   */
  function remove(List storage list, bytes32 key) internal {
    list.list.remove(key);
    list.values[key] = 0;
  }

  /**
   * @notice Updates an element in the list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @param value The element value.
   * @param lesserKey The key of the element will be just left of `key` after the update.
   * @param greaterKey The key of the element will be just right of `key` after the update.
   * @dev Note that only one of "lesserKey" or "greaterKey" needs to be correct to reduce friction.
   */
  function update(
    List storage list,
    bytes32 key,
    uint256 value,
    bytes32 lesserKey,
    bytes32 greaterKey
  ) internal {
    remove(list, key);
    insert(list, key, value, lesserKey, greaterKey);
  }

  /**
   * @notice Inserts an element at the tail of the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   */
  function push(List storage list, bytes32 key) internal {
    insert(list, key, 0, bytes32(0), list.list.tail);
  }

  /**
   * @notice Removes N elements from the head of the list and returns their keys.
   * @param list A storage pointer to the underlying list.
   * @param n The number of elements to pop.
   * @return The keys of the popped elements.
   */
  function popN(List storage list, uint256 n) internal returns (bytes32[] memory) {
    require(n <= list.list.numElements, "not enough elements");
    bytes32[] memory keys = new bytes32[](n);
    for (uint256 i = 0; i < n; i = i.add(1)) {
      bytes32 key = list.list.head;
      keys[i] = key;
      remove(list, key);
    }
    return keys;
  }

  /**
   * @notice Returns whether or not a particular key is present in the sorted list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @return Whether or not the key is in the sorted list.
   */
  function contains(List storage list, bytes32 key) internal view returns (bool) {
    return list.list.contains(key);
  }

  /**
   * @notice Returns the value for a particular key in the sorted list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @return The element value.
   */
  function getValue(List storage list, bytes32 key) internal view returns (uint256) {
    return list.values[key];
  }

  /**
   * @notice Gets all elements from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @return An unpacked list of elements from largest to smallest.
   */
  function getElements(List storage list)
    internal
    view
    returns (bytes32[] memory, uint256[] memory)
  {
    bytes32[] memory keys = getKeys(list);
    uint256[] memory values = new uint256[](keys.length);
    for (uint256 i = 0; i < keys.length; i = i.add(1)) {
      values[i] = list.values[keys[i]];
    }
    return (keys, values);
  }

  /**
   * @notice Gets all element keys from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @return All element keys from head to tail.
   */
  function getKeys(List storage list) internal view returns (bytes32[] memory) {
    return list.list.getKeys();
  }

  /**
   * @notice Returns first N greatest elements of the list.
   * @param list A storage pointer to the underlying list.
   * @param n The number of elements to return.
   * @return The keys of the first n elements.
   * @dev Reverts if n is greater than the number of elements in the list.
   */
  function headN(List storage list, uint256 n) internal view returns (bytes32[] memory) {
    return list.list.headN(n);
  }

  /**
   * @notice Returns the keys of the elements greaterKey than and less than the provided value.
   * @param list A storage pointer to the underlying list.
   * @param value The element value.
   * @param lesserKey The key of the element which could be just left of the new value.
   * @param greaterKey The key of the element which could be just right of the new value.
   * @return The correct lesserKey/greaterKey keys.
   */
  function getLesserAndGreater(
    List storage list,
    uint256 value,
    bytes32 lesserKey,
    bytes32 greaterKey
  ) private view returns (bytes32, bytes32) {
    // Check for one of the following conditions and fail if none are met:
    //   1. The value is less than the current lowest value
    //   2. The value is greater than the current greatest value
    //   3. The value is just greater than the value for `lesserKey`
    //   4. The value is just less than the value for `greaterKey`
    if (lesserKey == bytes32(0) && isValueBetween(list, value, lesserKey, list.list.tail)) {
      return (lesserKey, list.list.tail);
    } else if (
      greaterKey == bytes32(0) && isValueBetween(list, value, list.list.head, greaterKey)
    ) {
      return (list.list.head, greaterKey);
    } else if (
      lesserKey != bytes32(0) &&
      isValueBetween(list, value, lesserKey, list.list.elements[lesserKey].nextKey)
    ) {
      return (lesserKey, list.list.elements[lesserKey].nextKey);
    } else if (
      greaterKey != bytes32(0) &&
      isValueBetween(list, value, list.list.elements[greaterKey].previousKey, greaterKey)
    ) {
      return (list.list.elements[greaterKey].previousKey, greaterKey);
    } else {
      require(false, "get lesser and greater failure");
    }
  }

  /**
   * @notice Returns whether or not a given element is between two other elements.
   * @param list A storage pointer to the underlying list.
   * @param value The element value.
   * @param lesserKey The key of the element whose value should be lesserKey.
   * @param greaterKey The key of the element whose value should be greaterKey.
   * @return True if the given element is between the two other elements.
   */
  function isValueBetween(List storage list, uint256 value, bytes32 lesserKey, bytes32 greaterKey)
    private
    view
    returns (bool)
  {
    bool isLesser = lesserKey == bytes32(0) || list.values[lesserKey] <= value;
    bool isGreater = greaterKey == bytes32(0) || list.values[greaterKey] >= value;
    return isLesser && isGreater;
  }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/common/linkedlists/SortedLinkedListWithMedian.sol

pragma solidity ^0.5.13;



/**
 * @title Maintains a sorted list of unsigned ints keyed by bytes32.
 */
library SortedLinkedListWithMedian {
  using SafeMath for uint256;
  using SortedLinkedList for SortedLinkedList.List;

  enum MedianAction { None, Lesser, Greater }

  enum MedianRelation { Undefined, Lesser, Greater, Equal }

  struct List {
    SortedLinkedList.List list;
    bytes32 median;
    mapping(bytes32 => MedianRelation) relation;
  }

  /**
   * @notice Inserts an element into a doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   * @param value The element value.
   * @param lesserKey The key of the element less than the element to insert.
   * @param greaterKey The key of the element greater than the element to insert.
   */
  function insert(
    List storage list,
    bytes32 key,
    uint256 value,
    bytes32 lesserKey,
    bytes32 greaterKey
  ) internal {
    list.list.insert(key, value, lesserKey, greaterKey);
    LinkedList.Element storage element = list.list.list.elements[key];

    MedianAction action = MedianAction.None;
    if (list.list.list.numElements == 1) {
      list.median = key;
      list.relation[key] = MedianRelation.Equal;
    } else if (list.list.list.numElements % 2 == 1) {
      // When we have an odd number of elements, and the element that we inserted is less than
      // the previous median, we need to slide the median down one element, since we had previously
      // selected the greater of the two middle elements.
      if (
        element.previousKey == bytes32(0) ||
        list.relation[element.previousKey] == MedianRelation.Lesser
      ) {
        action = MedianAction.Lesser;
        list.relation[key] = MedianRelation.Lesser;
      } else {
        list.relation[key] = MedianRelation.Greater;
      }
    } else {
      // When we have an even number of elements, and the element that we inserted is greater than
      // the previous median, we need to slide the median up one element, since we always select
      // the greater of the two middle elements.
      if (
        element.nextKey == bytes32(0) || list.relation[element.nextKey] == MedianRelation.Greater
      ) {
        action = MedianAction.Greater;
        list.relation[key] = MedianRelation.Greater;
      } else {
        list.relation[key] = MedianRelation.Lesser;
      }
    }
    updateMedian(list, action);
  }

  /**
   * @notice Removes an element from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to remove.
   */
  function remove(List storage list, bytes32 key) internal {
    MedianAction action = MedianAction.None;
    if (list.list.list.numElements == 0) {
      list.median = bytes32(0);
    } else if (list.list.list.numElements % 2 == 0) {
      // When we have an even number of elements, we always choose the higher of the two medians.
      // Thus, if the element we're removing is greaterKey than or equal to the median we need to
      // slide the median left by one.
      if (
        list.relation[key] == MedianRelation.Greater || list.relation[key] == MedianRelation.Equal
      ) {
        action = MedianAction.Lesser;
      }
    } else {
      // When we don't have an even number of elements, we just choose the median value.
      // Thus, if the element we're removing is less than or equal to the median, we need to slide
      // median right by one.
      if (
        list.relation[key] == MedianRelation.Lesser || list.relation[key] == MedianRelation.Equal
      ) {
        action = MedianAction.Greater;
      }
    }
    updateMedian(list, action);

    list.list.remove(key);
  }

  /**
   * @notice Updates an element in the list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @param value The element value.
   * @param lesserKey The key of the element will be just left of `key` after the update.
   * @param greaterKey The key of the element will be just right of `key` after the update.
   * @dev Note that only one of "lesserKey" or "greaterKey" needs to be correct to reduce friction.
   */
  function update(
    List storage list,
    bytes32 key,
    uint256 value,
    bytes32 lesserKey,
    bytes32 greaterKey
  ) internal {
    remove(list, key);
    insert(list, key, value, lesserKey, greaterKey);
  }

  /**
   * @notice Inserts an element at the tail of the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @param key The key of the element to insert.
   */
  function push(List storage list, bytes32 key) internal {
    insert(list, key, 0, bytes32(0), list.list.list.tail);
  }

  /**
   * @notice Removes N elements from the head of the list and returns their keys.
   * @param list A storage pointer to the underlying list.
   * @param n The number of elements to pop.
   * @return The keys of the popped elements.
   */
  function popN(List storage list, uint256 n) internal returns (bytes32[] memory) {
    require(n <= list.list.list.numElements, "not enough elements");
    bytes32[] memory keys = new bytes32[](n);
    for (uint256 i = 0; i < n; i = i.add(1)) {
      bytes32 key = list.list.list.head;
      keys[i] = key;
      remove(list, key);
    }
    return keys;
  }

  /**
   * @notice Returns whether or not a particular key is present in the sorted list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @return Whether or not the key is in the sorted list.
   */
  function contains(List storage list, bytes32 key) internal view returns (bool) {
    return list.list.contains(key);
  }

  /**
   * @notice Returns the value for a particular key in the sorted list.
   * @param list A storage pointer to the underlying list.
   * @param key The element key.
   * @return The element value.
   */
  function getValue(List storage list, bytes32 key) internal view returns (uint256) {
    return list.list.values[key];
  }

  /**
   * @notice Returns the median value of the sorted list.
   * @param list A storage pointer to the underlying list.
   * @return The median value.
   */
  function getMedianValue(List storage list) internal view returns (uint256) {
    return getValue(list, list.median);
  }

  /**
   * @notice Returns the key of the first element in the list.
   * @param list A storage pointer to the underlying list.
   * @return The key of the first element in the list.
   */
  function getHead(List storage list) internal view returns (bytes32) {
    return list.list.list.head;
  }

  /**
   * @notice Returns the key of the median element in the list.
   * @param list A storage pointer to the underlying list.
   * @return The key of the median element in the list.
   */
  function getMedian(List storage list) internal view returns (bytes32) {
    return list.median;
  }

  /**
   * @notice Returns the key of the last element in the list.
   * @param list A storage pointer to the underlying list.
   * @return The key of the last element in the list.
   */
  function getTail(List storage list) internal view returns (bytes32) {
    return list.list.list.tail;
  }

  /**
   * @notice Returns the number of elements in the list.
   * @param list A storage pointer to the underlying list.
   * @return The number of elements in the list.
   */
  function getNumElements(List storage list) internal view returns (uint256) {
    return list.list.list.numElements;
  }

  /**
   * @notice Gets all elements from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @return An unpacked list of elements from largest to smallest.
   */
  function getElements(List storage list)
    internal
    view
    returns (bytes32[] memory, uint256[] memory, MedianRelation[] memory)
  {
    bytes32[] memory keys = getKeys(list);
    uint256[] memory values = new uint256[](keys.length);
    MedianRelation[] memory relations = new MedianRelation[](keys.length);
    for (uint256 i = 0; i < keys.length; i = i.add(1)) {
      values[i] = list.list.values[keys[i]];
      relations[i] = list.relation[keys[i]];
    }
    return (keys, values, relations);
  }

  /**
   * @notice Gets all element keys from the doubly linked list.
   * @param list A storage pointer to the underlying list.
   * @return All element keys from head to tail.
   */
  function getKeys(List storage list) internal view returns (bytes32[] memory) {
    return list.list.getKeys();
  }

  /**
   * @notice Moves the median pointer right or left of its current value.
   * @param list A storage pointer to the underlying list.
   * @param action Which direction to move the median pointer.
   */
  function updateMedian(List storage list, MedianAction action) private {
    LinkedList.Element storage previousMedian = list.list.list.elements[list.median];
    if (action == MedianAction.Lesser) {
      list.relation[list.median] = MedianRelation.Greater;
      list.median = previousMedian.previousKey;
    } else if (action == MedianAction.Greater) {
      list.relation[list.median] = MedianRelation.Lesser;
      list.median = previousMedian.nextKey;
    }
    list.relation[list.median] = MedianRelation.Equal;
  }
}
