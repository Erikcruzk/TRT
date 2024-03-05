



pragma solidity ^0.7.0;




abstract contract IPriceOracleGetterAave {
  function getAssetPrice(address _asset) external view virtual returns (uint256);

  function getAssetsPrices(address[] calldata _assets)
    external
    view
    virtual
    returns (uint256[] memory);

  function getSourceOfAsset(address _asset) external view virtual returns (address);

  function getFallbackOracle() external view virtual returns (address);
}