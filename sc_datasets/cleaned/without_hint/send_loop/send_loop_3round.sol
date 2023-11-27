pragma solidity 0.4.24;

contract Refunder {

address[] private refundAddresses;
mapping (address => uint) public refunds;

constructor() public {
refundAddresses.push(0x79B483371E87d664cd39491b5F06250165e4b184);
refundAddresses.push(0x79B483371E87d664cd39491b5F06250165e4b185);
}

function refundAll() public {
for(uint x = 0; x < refundAddresses.length; x++) {
address recipient = refundAddresses[x];
uint amount = refunds[recipient];
refunds[recipient] = 0;
require(recipient.send(amount));
}
}
}