


pragma solidity 0.6.11;



contract BlockMiner {
    uint256 public blocksMined;

    constructor () public {
        blocksMined = 0;
    }

    function mine() public {
       blocksMined += 1;
    }

    function blockTime() external view returns (uint256) {
       return block.timestamp;
    }
}