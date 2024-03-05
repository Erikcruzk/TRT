

pragma solidity ^0.4.21;





interface ITokenEventListener {
    





    function onTokenTransfer(address _from, address _to, uint256 _value) public;
}