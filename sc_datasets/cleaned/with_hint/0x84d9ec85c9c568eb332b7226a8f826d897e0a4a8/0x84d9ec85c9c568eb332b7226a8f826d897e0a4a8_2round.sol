pragma solidity ^0.4.16;

contract Owned {
address public owner;
address public newOwner;

modifier onlyOwner() {
require(msg.sender == owner);
_;
}

function Owned() {
owner = msg.sender;
}

function changeOwner(address _newOwner) onlyOwner {
newOwner = _newOwner;
}

function acceptOwnership() {
if (msg.sender == newOwner) {
owner = newOwner;
}
}

function execute(address _dst, uint _value, bytes _data) onlyOwner returns (bool success) {
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

function numberOfIndex() constant public returns (uint) {
return indexarray.length;
}

function writeIndex(string _wedaddress, string _partnernames, uint _weddingdate, uint _displaymultisig) {
indexarray.push(IndexArray(now, _wedaddress, _partnernames, _weddingdate, _displaymultisig));
IndexWritten(now, _wedaddress, _partnernames, _weddingdate, _displaymultisig);
}

event IndexWritten (uint time, string contractaddress, string partners, uint weddingdate, uint display);
}