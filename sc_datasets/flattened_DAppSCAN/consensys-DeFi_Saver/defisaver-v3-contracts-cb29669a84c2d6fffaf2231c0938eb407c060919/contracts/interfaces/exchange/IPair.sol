// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

interface IERC20 {
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function decimals() external view returns (uint256 digits);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/exchange/IPair.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IPair is IERC20 {
    function token0() external virtual view returns (address);
    function token1() external virtual view returns (address);
    function getReserves() external virtual view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external virtual view returns (uint);
    function price1CumulativeLast() external virtual view returns (uint);
    function kLast() external virtual view returns (uint);
}
