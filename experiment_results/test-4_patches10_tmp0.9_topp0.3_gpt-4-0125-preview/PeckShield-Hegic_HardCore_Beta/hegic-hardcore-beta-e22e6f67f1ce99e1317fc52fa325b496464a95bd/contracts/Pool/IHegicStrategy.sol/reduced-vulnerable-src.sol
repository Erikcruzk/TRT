

pragma solidity 0.8.6;




















interface IHegicStrategy {

    event Acquired(
      uint256 indexed id,
      uint256 amount,
      uint256 premium,
      uint256 strike,
      uint32 expiration
    );

    function getLockedByStrategy() external view returns (uint256 amount);

    function lockedLimit() external view returns (uint lockedLimit);

}