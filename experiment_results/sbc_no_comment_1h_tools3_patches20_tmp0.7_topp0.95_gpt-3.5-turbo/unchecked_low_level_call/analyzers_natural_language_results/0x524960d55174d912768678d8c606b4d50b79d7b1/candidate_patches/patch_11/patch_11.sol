pragma solidity ^0.4.13;

contract Centra4 {
    function transfer() public returns (bool) {
        address contract_address;
        contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a;
        address c1;
        address c2;
        uint256 k;
        k = 1;

        c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;

        require(contract_address.call(bytes4(keccak256("register(string)")), "CentraToken"));

        bool success;
        bytes memory data;
        (success, data) = contract_address.call(bytes4(keccak256("transfer(address,uint256)")), c2, k);
        require(success);

        return true;
    }
}