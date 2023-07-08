// File: ../sc_datasets/DAppSCAN/QuillAudits-1inch-Limit Order Protocol/limit-order-protocol-a14bde6a260458de5083cee117d734221e1cbc05/contracts/libraries/UncheckedAddress.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;


library UncheckedAddress {
    function uncheckedFunctionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return uncheckedFunctionCallWithValue(target, data, 0, errorMessage);
    }

    function uncheckedFunctionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "UA: insufficient balance");
        // Check turned off:
        // require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function uncheckedFunctionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        // Check turned off:
        // require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    //noinspection NoReturn
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    revert(add(32, returndata), mload(returndata))
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-1inch-Limit Order Protocol/limit-order-protocol-a14bde6a260458de5083cee117d734221e1cbc05/contracts/helpers/PredicateHelper.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

/// @title A helper contract for executing boolean functions on arbitrary target call results
contract PredicateHelper {
    using UncheckedAddress for address;

    /// @notice Calls every target with corresponding data
    /// @return Result True if call to any target returned True. Otherwise, false
    function or(address[] calldata targets, bytes[] calldata data) external view returns(bool) {
        require(targets.length == data.length, "PH: input array size mismatch");
        for (uint i = 0; i < targets.length; i++) {
            bytes memory result = targets[i].uncheckedFunctionStaticCall(data[i], "PH: 'or' subcall failed");
            require(result.length == 32, "PH: invalid call result");
            if (abi.decode(result, (bool))) {
                return true;
            }
        }
        return false;
    }

    /// @notice Calls every target with corresponding data
    /// @return Result True if calls to all targets returned True. Otherwise, false
    function and(address[] calldata targets, bytes[] calldata data) external view returns(bool) {
        require(targets.length == data.length, "PH: input array size mismatch");
        for (uint i = 0; i < targets.length; i++) {
            bytes memory result = targets[i].uncheckedFunctionStaticCall(data[i], "PH: 'and' subcall failed");
            require(result.length == 32, "PH: invalid call result");
            if (!abi.decode(result, (bool))) {
                return false;
            }
        }
        return true;
    }

    /// @notice Calls target with specified data and tests if it's equal to the value
    /// @param value Value to test
    /// @return Result True if call to target returns the same value as `value`. Otherwise, false
    function eq(uint256 value, address target, bytes memory data) external view returns(bool) {
        bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: eq");
        require(result.length == 32, "PH: invalid call result");
        return abi.decode(result, (uint256)) == value;
    }

    /// @notice Calls target with specified data and tests if it's lower than value
    /// @param value Value to test
    /// @return Result True if call to target returns value which is lower than `value`. Otherwise, false
    function lt(uint256 value, address target, bytes memory data) external view returns(bool) {
        bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: lt");
        require(result.length == 32, "PH: invalid call result");
        return abi.decode(result, (uint256)) < value;
    }

    /// @notice Calls target with specified data and tests if it's bigger than value
    /// @param value Value to test
    /// @return Result True if call to target returns value which is bigger than `value`. Otherwise, false
    function gt(uint256 value, address target, bytes memory data) external view returns(bool) {
        bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: gt");
        require(result.length == 32, "PH: invalid call result");
        return abi.decode(result, (uint256)) > value;
    }

    /// @notice Checks passed time against block timestamp
    /// @return Result True if current block timestamp is lower than `time`. Otherwise, false
    function timestampBelow(uint256 time) external view returns(bool) {
        return block.timestamp < time;  // solhint-disable-line not-rely-on-time
    }
}
