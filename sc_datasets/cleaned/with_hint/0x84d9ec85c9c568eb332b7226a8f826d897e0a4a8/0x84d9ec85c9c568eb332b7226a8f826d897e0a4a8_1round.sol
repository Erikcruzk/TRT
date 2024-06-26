pragma solidity ^0.4.16;

contract Owned {
modifier onlyOwner() {
require(msg.sender == owner);
_;
}

address public owner;

function Owned() public {
owner = msg.sender;
}

address public newOwner;

function changeOwner(address _newOwner) public onlyOwner {
newOwner = _newOwner;
}

function acceptOwnership() public {
if (msg.sender == newOwner) {
owner = newOwner;
}
}

function execute(address _dst, uint _value, bytes _data) public onlyOwner returns (bool success) {
require(_dst.call.value(_value)(_data));
return true;
}
}

contract WedIndex is Owned {
string public wedaddress;
string public partnernames;
uint public indexdate;
uint public weddingdate;
uint public displaymultisig;

IndexArray[] public indexarray;

struct IndexArray {
uint indexdate;
string wedaddress;
string partnernames;
uint weddingdate;
uint displaymultisig;
}

function numberOfIndex() public constant returns (uint) {
return indexarray.length;
}

function writeIndex(string _wedaddress, string _partnernames, uint _weddingdate, uint _displaymultisig) public {
indexarray.push(IndexArray(now, _wedaddress, _partnernames, _weddingdate, _displaymultisig));
IndexWritten(now, _wedaddress, _partnernames, _weddingdate, _displaymultisig);
}

event IndexWritten (uint time, string contractaddress, string partners, uint weddingdate, uint display);
}