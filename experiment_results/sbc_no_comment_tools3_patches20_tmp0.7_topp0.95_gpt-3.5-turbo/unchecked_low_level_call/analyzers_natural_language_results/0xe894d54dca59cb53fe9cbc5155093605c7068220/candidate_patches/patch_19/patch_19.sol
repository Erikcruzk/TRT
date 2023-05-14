pragma solidity ^0.8.0;

contract airDrop {
    function transfer(
        address from,
        address caddress,
        address[] memory _tos,
        uint256 v,
        uint256 _decimals
    ) public returns (bool) {
        require(_tos.length > 0, "Recipient addresses array is empty");
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        uint256 _value = v * 10 ** _decimals;
        for (uint256 i = 0; i < _tos.length; i++) {
            (bool success, bytes memory data) = caddress.call(abi.encodeWithSelector(id, from, _tos[i], _value));
            require(success, "Transfer failed");
        }
        return true;
    }
}