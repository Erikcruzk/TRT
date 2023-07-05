// File: ../sc_datasets/DAppSCAN/QuillAudits-1inch-Limit Order Protocol/limit-order-protocol-a14bde6a260458de5083cee117d734221e1cbc05/contracts/interfaces/AggregatorV3Interface.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

interface AggregatorV3Interface {
    function latestAnswer() external view returns (int256);
    function latestTimestamp() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-1inch-Limit Order Protocol/limit-order-protocol-a14bde6a260458de5083cee117d734221e1cbc05/contracts/mocks/AggregatorV3Mock.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

contract AggregatorV3Mock is AggregatorV3Interface {
    int256 private immutable _answer;

    constructor(int256 answer) {
        _answer = answer;
    }

    function latestAnswer() external view override returns (int256) {
        return _answer;
    }

    function latestTimestamp() external view override returns (uint256) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp - 100;
    }
}
