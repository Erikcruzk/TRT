// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/proxy/utils/Initializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/mocks/RegressionImplementation.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Implementation1 is Initializable {
    uint256 internal _value;

    function initialize() public initializer {}

    function setValue(uint256 _number) public {
        _value = _number;
    }
}

contract Implementation2 is Initializable {
    uint256 internal _value;

    function initialize() public initializer {}

    function setValue(uint256 _number) public {
        _value = _number;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }
}

contract Implementation3 is Initializable {
    uint256 internal _value;

    function initialize() public initializer {}

    function setValue(uint256 _number) public {
        _value = _number;
    }

    function getValue(uint256 _number) public view returns (uint256) {
        return _value + _number;
    }
}

contract Implementation4 is Initializable {
    uint256 internal _value;

    function initialize() public initializer {}

    function setValue(uint256 _number) public {
        _value = _number;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }

    fallback() external {
        _value = 1;
    }
}
