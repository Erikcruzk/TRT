pragma solidity ^0.4.0;

contract SimpleSuicide {

function suicideAnyone() public {
require(msg.sender == owner);
selfdestruct(owner);
}

address owner;

function SimpleSuicide() public {
owner = msg.sender;
}

}