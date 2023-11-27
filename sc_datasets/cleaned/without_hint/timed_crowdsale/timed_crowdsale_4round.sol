pragma solidity ^0.4.25;

contract TimedCrowdsale {

uint256 public endTime;

constructor(uint256 _endTime) public {
endTime = _endTime;
}

function isSaleFinished() view public returns (bool) {
return block.timestamp >= endTime;
}
}