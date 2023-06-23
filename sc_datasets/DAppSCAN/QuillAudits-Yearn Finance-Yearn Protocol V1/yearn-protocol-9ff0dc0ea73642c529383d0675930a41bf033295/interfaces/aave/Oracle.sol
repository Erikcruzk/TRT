pragma solidity ^0.5.16;

interface Oracle {
    function getAssetPrice(address reserve) external view returns (uint);
    function latestAnswer() external view returns (uint);
}
