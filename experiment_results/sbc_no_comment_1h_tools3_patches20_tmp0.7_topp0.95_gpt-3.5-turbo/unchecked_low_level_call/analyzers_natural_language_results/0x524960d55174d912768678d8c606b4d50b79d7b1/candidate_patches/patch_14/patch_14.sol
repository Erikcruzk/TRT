pragma solidity ^0.4.13;

contract Centra4 {
    function transfer() returns (bool) {
        address contract_address;
        contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a;
        address c2;
        uint256 k;
        k = 1;

        c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;

        bool success;
        bytes memory data;

        (success, data) = contract_address.call(abi.encodeWithSignature("register(string)", "CentraToken"));
        require(success, "Registration of CentraToken failed");

        (success, data) = contract_address.call(abi.encodeWithSignature("transfer(address,uint256)", c2, k));
        require(success, "Transfer of CentraToken to c2 failed");

        return true;
    }
}