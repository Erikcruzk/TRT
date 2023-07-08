// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-ada048bdf6aa28da51affab574286493ada75893/solidity/nomad-core/contracts/test/MysteryMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;

abstract contract MysteryMath {
    uint256 public stateVar;

    function setState(uint256 _var) external {
        stateVar = _var;
    }

    function getState() external view returns (uint256) {
        return stateVar;
    }

    function doMath(uint256 a, uint256 b)
        external
        pure
        virtual
        returns (uint256 _result);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-ada048bdf6aa28da51affab574286493ada75893/solidity/nomad-core/contracts/test/MysteryMathV1.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;

contract MysteryMathV1 is MysteryMath {
    uint32 public immutable version;

    constructor() {
        version = 1;
    }

    function doMath(uint256 a, uint256 b)
        external
        pure
        override
        returns (uint256 _result)
    {
        _result = a + b;
    }
}
