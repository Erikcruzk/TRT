// File: ../sc_datasets/DAppSCAN/openzeppelin-OpenBazaar’s_Escrow/smart-contracts-c4f02cdd41cb85d28bba637a01f20a8ee8bb04bd/contracts/token/ITokenContract.sol

pragma solidity 0.4.24;

interface ITokenContract {
    function balanceOf(address _owner) external view returns (uint256 balance);
  
    function transfer(
        address _to, 
        uint256 _amount
    )
        external 
        returns (bool success);

    function transferFrom(
        address _from, 
        address _to, 
        uint256 _amount
    ) 
        external 
        returns (bool success);
}
