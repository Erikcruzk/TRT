pragma solidity ^0.4.25;

contract TimedCrowdsale {
    function isSaleFinished() public view returns (bool) {
        return block.timestamp >= 1546300800;
    }
}
