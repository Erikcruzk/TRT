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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/exchange/IKyberNetworkProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract KyberNetworkProxyInterface {
    function maxGasPrice() external virtual view returns (uint256);

    function getUserCapInWei(address user) external virtual view returns (uint256);

    function getUserCapInTokenWei(address user, IERC20 token) external virtual view returns (uint256);

    function enabled() external virtual view returns (bool);

    function info(bytes32 id) external virtual view returns (uint256);

    function getExpectedRate(IERC20 src, IERC20 dest, uint256 srcQty)
        public virtual
        view
        returns (uint256 expectedRate, uint256 slippageRate);

    function tradeWithHint(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address walletId,
        bytes memory hint
    ) public virtual payable returns (uint256);

    function trade(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address walletId
    ) public virtual payable returns (uint256);

    function swapEtherToToken(IERC20 token, uint256 minConversionRate)
        external virtual
        payable
        returns (uint256);

    function swapTokenToEther(IERC20 token, uint256 tokenQty, uint256 minRate)
        external virtual
        payable
        returns (uint256);

    function swapTokenToToken(IERC20 src, uint256 srcAmount, IERC20 dest, uint256 minConversionRate)
        public virtual
        returns (uint256);
}
