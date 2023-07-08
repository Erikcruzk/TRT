// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/utility/interfaces/IChainlinkPriceOracle.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Chainlink Price Oracle interface
*/
interface IChainlinkPriceOracle {
    function latestAnswer() external view returns (int256);
    function latestTimestamp() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/utility/ChainlinkETHToETHOracle.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Provides the trivial ETH/ETH rate to be used with other TKN/ETH rates
*/
contract ChainlinkETHToETHOracle is IChainlinkPriceOracle {
    int256 private constant ETH_RATE = 1;

    /**
      * @dev returns the trivial ETH/ETH rate.
      *
      * @return always returns the trivial rate of 1
    */
    function latestAnswer() external view override returns (int256) {
        return ETH_RATE;
    }

    /**
      * @dev returns the trivial ETH/ETH update time.
      *
      * @return always returns current block's timestamp
    */
    function latestTimestamp() external view override returns (uint256) {
        return now;
    }
}
