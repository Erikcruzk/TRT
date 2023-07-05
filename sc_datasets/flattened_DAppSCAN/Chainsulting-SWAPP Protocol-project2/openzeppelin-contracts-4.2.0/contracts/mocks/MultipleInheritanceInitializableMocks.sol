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

// File: ../sc_datasets/DAppSCAN/Chainsulting-SWAPP Protocol-project2/openzeppelin-contracts-4.2.0/contracts/mocks/MultipleInheritanceInitializableMocks.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Sample contracts showing upgradeability with multiple inheritance.
// Child contract inherits from Father and Mother contracts, and Father extends from Gramps.
//
//         Human
//       /       \
//      |       Gramps
//      |         |
//    Mother    Father
//      |         |
//      -- Child --

/**
 * Sample base intializable contract that is a human
 */
contract SampleHuman is Initializable {
    bool public isHuman;

    function initialize() public initializer {
        isHuman = true;
    }
}

/**
 * Sample base intializable contract that defines a field mother
 */
contract SampleMother is Initializable, SampleHuman {
    uint256 public mother;

    function initialize(uint256 value) public virtual initializer {
        SampleHuman.initialize();
        mother = value;
    }
}

/**
 * Sample base intializable contract that defines a field gramps
 */
contract SampleGramps is Initializable, SampleHuman {
    string public gramps;

    function initialize(string memory value) public virtual initializer {
        SampleHuman.initialize();
        gramps = value;
    }
}

/**
 * Sample base intializable contract that defines a field father and extends from gramps
 */
contract SampleFather is Initializable, SampleGramps {
    uint256 public father;

    function initialize(string memory _gramps, uint256 _father) public initializer {
        SampleGramps.initialize(_gramps);
        father = _father;
    }
}

/**
 * Child extends from mother, father (gramps)
 */
contract SampleChild is Initializable, SampleMother, SampleFather {
    uint256 public child;

    function initialize(
        uint256 _mother,
        string memory _gramps,
        uint256 _father,
        uint256 _child
    ) public initializer {
        SampleMother.initialize(_mother);
        SampleFather.initialize(_gramps, _father);
        child = _child;
    }
}
