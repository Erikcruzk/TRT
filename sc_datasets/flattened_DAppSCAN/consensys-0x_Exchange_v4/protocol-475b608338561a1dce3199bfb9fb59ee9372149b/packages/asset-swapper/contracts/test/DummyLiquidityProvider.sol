// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/packages/asset-swapper/contracts/test/DummyLiquidityProvider.sol

pragma solidity ^0.6;
pragma experimental ABIEncoderV2;


contract DummyLiquidityProvider
{
    /// @dev Quotes the amount of `makerToken` that would be obtained by
    ///      selling `sellAmount` of `takerToken`.
    /// @param sellAmount Amount of `takerToken` to sell.
    /// @return makerTokenAmount Amount of `makerToken` that would be obtained.
    function getSellQuote(
        address, /* takerToken */
        address, /* makerToken */
        uint256 sellAmount
    )
        external
        view
        returns (uint256 makerTokenAmount)
    {
        makerTokenAmount = sellAmount - 1;
    }

    /// @dev Quotes the amount of `takerToken` that would need to be sold in
    ///      order to obtain `buyAmount` of `makerToken`.
    /// @param buyAmount Amount of `makerToken` to buy.
    /// @return takerTokenAmount Amount of `takerToken` that would need to be sold.
    function getBuyQuote(
        address, /* takerToken */
        address, /* makerToken */
        uint256 buyAmount
    )
        external
        view
        returns (uint256 takerTokenAmount)
    {
        takerTokenAmount = buyAmount + 1;
    }
}