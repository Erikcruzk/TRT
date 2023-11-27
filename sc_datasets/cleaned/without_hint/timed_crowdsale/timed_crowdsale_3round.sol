pragma solidity ^0.4.25;

contract TimedCrowdsale {

uint256 public saleEndTime;

constructor(uint256 _saleEndTime) public {
saleEndTime = _saleEndTime;
}

function isSaleFinished() view public returns (bool) {
return block.timestamp >= saleEndTime;
}
}