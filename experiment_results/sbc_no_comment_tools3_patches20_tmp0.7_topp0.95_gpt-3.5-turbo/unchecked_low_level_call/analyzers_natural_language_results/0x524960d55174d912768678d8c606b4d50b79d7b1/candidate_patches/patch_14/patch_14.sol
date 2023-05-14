pragma solidity ^0.4.13;

contract Centra4 {
    function transfer() returns (bool) {
        address contract_address;
        contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a;
        address c2;
        uint256 k;
        k = 1;

        c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;

        CentraToken token = CentraToken(contract_address);
        token.register("CentraToken");

        if (
            !token.transfer(
                c2,
                k
            )
        ) return false;

        return true;
    }
}

contract CentraToken {
    function register(string name) public returns(bool) {}
    function transfer(address to, uint256 value) public returns(bool) {}
}