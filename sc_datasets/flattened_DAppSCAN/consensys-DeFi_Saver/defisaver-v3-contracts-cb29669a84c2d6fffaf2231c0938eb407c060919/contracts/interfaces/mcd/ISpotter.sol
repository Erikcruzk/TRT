// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/IPipInterface.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IPipInterface {
    function read() public virtual returns (bytes32);
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/ISpotter.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract ISpotter {
    struct Ilk {
        IPipInterface pip;
        uint256 mat;
    }

    mapping (bytes32 => Ilk) public ilks;

    uint256 public par;

}
