// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/mocks/ContextMock.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ContextMock is Context {
    event Sender(address sender);

    function msgSender() public {
        emit Sender(_msgSender());
    }

    event Data(bytes data, uint256 integerValue, string stringValue);

    function msgData(uint256 integerValue, string memory stringValue) public {
        emit Data(_msgData(), integerValue, stringValue);
    }
}

contract ContextMockCaller {
    function callSender(ContextMock context) public {
        context.msgSender();
    }

    function callData(
        ContextMock context,
        uint256 integerValue,
        string memory stringValue
    ) public {
        context.msgData(integerValue, stringValue);
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/metatx/ERC2771Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
 * @dev Context variant with ERC2771 support.
 */
abstract contract ERC2771Context is Context {
    address immutable _trustedForwarder;

    constructor(address trustedForwarder) {
        _trustedForwarder = trustedForwarder;
    }

    function isTrustedForwarder(address forwarder) public view virtual returns (bool) {
        return forwarder == _trustedForwarder;
    }

    function _msgSender() internal view virtual override returns (address sender) {
        if (isTrustedForwarder(msg.sender)) {
            // The assembly code is more direct than the Solidity version using `abi.decode`.
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            return super._msgSender();
        }
    }

    function _msgData() internal view virtual override returns (bytes calldata) {
        if (isTrustedForwarder(msg.sender)) {
            return msg.data[:msg.data.length - 20];
        } else {
            return super._msgData();
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/mocks/ERC2771ContextMock.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// By inheriting from ERC2771Context, Context's internal functions are overridden automatically
contract ERC2771ContextMock is ContextMock, ERC2771Context {
    constructor(address trustedForwarder) ERC2771Context(trustedForwarder) {}

    function _msgSender() internal view virtual override(Context, ERC2771Context) returns (address) {
        return ERC2771Context._msgSender();
    }

    function _msgData() internal view virtual override(Context, ERC2771Context) returns (bytes calldata) {
        return ERC2771Context._msgData();
    }
}
