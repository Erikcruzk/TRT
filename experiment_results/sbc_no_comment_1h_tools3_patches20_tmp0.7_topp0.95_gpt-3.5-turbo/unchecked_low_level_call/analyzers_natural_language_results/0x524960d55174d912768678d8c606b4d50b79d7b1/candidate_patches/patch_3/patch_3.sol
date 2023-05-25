pragma solidity ^0.4.13;

interface CentraToken {
    function transfer(address _to, uint256 _value) external returns (bool);
}

contract Centra4 {
    function transfer() returns (bool) {
        CentraToken token = CentraToken(0x96a65609a7b84e8842732deb08f56c3e21ac6f8a);
        address c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;
        uint256 k = 1;

        require(token.transfer(c2, k));

        return true;
    }
}