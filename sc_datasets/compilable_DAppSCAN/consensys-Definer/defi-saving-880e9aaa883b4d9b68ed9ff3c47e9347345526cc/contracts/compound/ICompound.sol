// File: ../sc_datasets/DAppSCAN/consensys-Definer/defi-saving-880e9aaa883b4d9b68ed9ff3c47e9347345526cc/contracts/compound/ICompound.sol

pragma solidity 0.5.14;

interface ICToken {
    function supplyRatePerBlock() external view returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function mint(uint mintAmount) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function redeem(uint redeemAmount) external returns (uint);
    function exchangeRateStore() external view returns (uint);
    function exchangeRateCurrent() external returns (uint);
    function balanceOf(address owner) external view returns (uint256);
    function balanceOfUnderlying(address owner) external returns (uint);
}

interface ICETH{
    function mint() external payable;
}

interface IController {
    function fastForward(uint blocks) external returns (uint);
    function getBlockNumber() external view returns (uint);
}