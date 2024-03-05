

















pragma solidity 0.5.12;

interface IIndexer {

  event CreateIndex(
    address signerToken,
    address senderToken
  );

  event Stake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    uint256 stakeAmount
  );

  event Unstake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    uint256 stakeAmount
  );

  event AddTokenToBlacklist(
    address token
  );

  event RemoveTokenFromBlacklist(
    address token
  );

  function stakingToken() external returns (address);
  function indexes(address, address) external returns (address);
  function tokenBlacklist(address) external returns (bool);

  function setLocatorWhitelist(
    address newLocatorWhitelist
  ) external;

  function createIndex(
    address signerToken,
    address senderToken
  ) external returns (address);

  function addTokenToBlacklist(
    address token
  ) external;

  function removeTokenFromBlacklist(
    address token
  ) external;

  function setIntent(
    address signerToken,
    address senderToken,
    uint256 stakingAmount,
    bytes32 locator
  ) external;

  function unsetIntent(
    address signerToken,
    address senderToken
  ) external;

  function unsetIntentForUser(
    address user,
    address signerToken,
    address senderToken
  ) external;

  function getStakedAmount(
    address user,
    address signerToken,
    address senderToken
  ) external view returns (uint256);

  function getLocators(
    address signerToken,
    address senderToken,
    address cursor,
    uint256 limit
  ) external view returns (
    bytes32[] memory,
    uint256[] memory,
    address
  );

}