pragma solidity ^0.4.13;

contract Centra4 {
    function transfer() public returns (bool) {
        address contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a;
        address c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;
        uint256 k = 1;

        CentraToken token = CentraToken(contract_address);
        token.register("CentraToken");

        if (!token.transfer(c2, k)) {
            revert();
        }

        return true;
    }
}

interface CentraToken {
    function register(string _name) external;
    function transfer(address _to, uint256 _value) external returns (bool);
}