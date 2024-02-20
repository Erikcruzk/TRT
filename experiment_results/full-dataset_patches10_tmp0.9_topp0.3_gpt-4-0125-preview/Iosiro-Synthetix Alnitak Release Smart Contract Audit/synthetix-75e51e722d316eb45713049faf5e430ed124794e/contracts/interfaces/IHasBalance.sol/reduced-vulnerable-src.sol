

pragma solidity >=0.4.24;


interface IHasBalance {
    
    function balanceOf(address account) external view returns (uint);
}