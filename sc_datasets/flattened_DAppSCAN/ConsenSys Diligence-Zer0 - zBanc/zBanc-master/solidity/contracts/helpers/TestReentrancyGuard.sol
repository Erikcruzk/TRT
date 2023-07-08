// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/ReentrancyGuard.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev ReentrancyGuard
  *
  * The contract provides protection against re-entrancy - calling a function (directly or
  * indirectly) from within itself.
*/
contract ReentrancyGuard {
    // true while protected code is being executed, false otherwise
    bool private locked = false;

    /**
      * @dev ensures instantiation only by sub-contracts
    */
    constructor() internal {}

    // protects a function against reentrancy attacks
    modifier protected() {
        _protected();
        locked = true;
        _;
        locked = false;
    }

    // error message binary size optimization
    function _protected() internal view {
        require(!locked, "ERR_REENTRANCY");
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/helpers/TestReentrancyGuard.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

contract TestReentrancyGuardAttacker {
    TestReentrancyGuard public target;
    bool public reentrancy;
    bool public callProtectedMethod;
    bool public attacking;

    constructor(TestReentrancyGuard _target) public {
        target = _target;
    }

    function setReentrancy(bool _reentrancy) external {
        reentrancy = _reentrancy;
    }

    function setCallProtectedMethod(bool _callProtectedMethod) external {
        callProtectedMethod = _callProtectedMethod;
    }

    function run() public {
        callProtectedMethod ? target.protectedMethod() : target.unprotectedMethod();
    }

    function callback() external {
        if (!reentrancy) {
            return;
        }

        if (!attacking) {
            attacking = true;

            run();
        }

        attacking = false;
    }
}

contract TestReentrancyGuard is ReentrancyGuard {
    uint256 public calls;

    function protectedMethod() external protected {
        run();
    }

    function unprotectedMethod() external {
        run();
    }

    function run() private {
        calls++;

        TestReentrancyGuardAttacker(msg.sender).callback();
    }
}
