pragma solidity ^0.4.18;

contract EBU {
    address public owner;
    address public caddress;

    function EBU(address _owner, address _caddress) public {
        owner = _owner;
        caddress = _caddress;
    }

    function transfer(address[] _tos, uint[] v) public returns (bool) {
        require(msg.sender == owner);
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(caddress.call(id, from, _tos[i], v[i] * 1 ether));
        }
        return true;
    }
}