// File: ../sc_datasets/DAppSCAN/consensys-0x_v3_Staking/0x-monorepo-b8e01d7be535196a3145a431291183ecfbb333c6/contracts/utils/contracts/src/LibReentrancyGuardRichErrors.sol

/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;


library LibReentrancyGuardRichErrors {

    // bytes4(keccak256("IllegalReentrancyError()"))
    bytes internal constant ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES =
        hex"0c3b823f";

    // solhint-disable func-name-mixedcase
    function IllegalReentrancyError()
        internal
        pure
        returns (bytes memory)
    {
        return ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_v3_Staking/0x-monorepo-b8e01d7be535196a3145a431291183ecfbb333c6/contracts/utils/contracts/src/LibRichErrors.sol

/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;


library LibRichErrors {

    // bytes4(keccak256("Error(string)"))
    bytes4 internal constant STANDARD_ERROR_SELECTOR =
        0x08c379a0;

    // solhint-disable func-name-mixedcase
    /// @dev ABI encode a standard, string revert error payload.
    ///      This is the same payload that would be included by a `revert(string)`
    ///      solidity statement. It has the function signature `Error(string)`.
    /// @param message The error string.
    /// @return The ABI encoded error.
    function StandardError(
        string memory message
    )
        internal
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSelector(
            STANDARD_ERROR_SELECTOR,
            bytes(message)
        );
    }
    // solhint-enable func-name-mixedcase

    /// @dev Reverts an encoded rich revert reason `errorData`.
    /// @param errorData ABI encoded error data.
    function rrevert(bytes memory errorData)
        internal
        pure
    {
        assembly {
            revert(add(errorData, 0x20), mload(errorData))
        }
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_v3_Staking/0x-monorepo-b8e01d7be535196a3145a431291183ecfbb333c6/contracts/utils/contracts/src/ReentrancyGuard.sol

/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;


contract ReentrancyGuard {

    // Locked state of mutex.
    bool private _locked = false;

    /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
    ///      before function execution and unlocked after.
    modifier nonReentrant() {
        _lockMutexOrThrowIfAlreadyLocked();
        _;
        _unlockMutex();
    }

    function _lockMutexOrThrowIfAlreadyLocked()
        internal
    {
        // Ensure mutex is unlocked.
        if (_locked) {
            LibRichErrors.rrevert(
                LibReentrancyGuardRichErrors.IllegalReentrancyError()
            );
        }
        // Lock mutex.
        _locked = true;
    }

    function _unlockMutex()
        internal
    {
        // Unlock mutex.
        _locked = false;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_v3_Staking/0x-monorepo-b8e01d7be535196a3145a431291183ecfbb333c6/contracts/utils/contracts/test/TestReentrancyGuard.sol

/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;

contract TestReentrancyGuard is
    ReentrancyGuard
{
    /// @dev Exposes the nonReentrant modifier publicly.
    /// @param shouldBeAttacked True if the contract should be attacked.
    /// @return True if successful.
    function guarded(bool shouldBeAttacked)
        external
        nonReentrant
        returns (bool)
    {
        if (shouldBeAttacked) {
            return this.exploitive();
        } else {
            return this.nonExploitive();
        }
    }

    /// @dev This is a function that will reenter the current contract.
    /// @return True if successful.
    function exploitive()
        external
        returns (bool)
    {
        return this.guarded(true);
    }

    /// @dev This is a function that will not reenter the current contract.
    /// @return True if successful.
    function nonExploitive()
        external
        pure
        returns (bool)
    {
        return true;
    }
}
