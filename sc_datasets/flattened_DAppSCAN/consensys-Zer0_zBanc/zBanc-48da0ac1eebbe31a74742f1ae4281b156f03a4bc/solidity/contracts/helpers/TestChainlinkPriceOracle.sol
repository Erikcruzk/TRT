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

// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/helpers/TestChainlinkPriceOracle.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Chainlink price oracle mock
*/
contract TestChainlinkPriceOracle is IChainlinkPriceOracle {
    int256 private answer;
    uint256 private timestamp;

    function setAnswer(int256 _answer) public {
        answer = _answer;
    }

    function setTimestamp(uint256 _timestamp) public {
        timestamp = _timestamp;
    }

    function latestAnswer() external view override returns (int256) {
        return answer;
    }

    function latestTimestamp() external view override returns (uint256) {
        return timestamp;
    }
}
