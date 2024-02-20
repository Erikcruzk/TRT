


pragma solidity 0.8.7;






interface ISequencerOracle {
  function latestAnswer() external view returns (bool, uint256);
}