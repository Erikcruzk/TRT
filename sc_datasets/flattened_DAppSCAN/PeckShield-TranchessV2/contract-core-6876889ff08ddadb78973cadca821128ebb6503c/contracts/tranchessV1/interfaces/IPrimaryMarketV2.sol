// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/tranchessV1/interfaces/IPrimaryMarket.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;

interface IPrimaryMarket {
    function claim(address account)
        external
        returns (uint256 createdShares, uint256 redeemedUnderlying);

    function settle(
        uint256 day,
        uint256 fundTotalShares,
        uint256 fundUnderlying,
        uint256 underlyingPrice,
        uint256 previousNav
    )
        external
        returns (
            uint256 sharesToMint,
            uint256 sharesToBurn,
            uint256 creationUnderlying,
            uint256 redemptionUnderlying,
            uint256 fee
        );
}

// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/tranchessV1/interfaces/IPrimaryMarketV2.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;

interface IPrimaryMarketV2 is IPrimaryMarket {
    function claimAndUnwrap(address account)
        external
        returns (uint256 createdShares, uint256 redeemedUnderlying);

    function updateDelayedRedemptionDay() external;
}
