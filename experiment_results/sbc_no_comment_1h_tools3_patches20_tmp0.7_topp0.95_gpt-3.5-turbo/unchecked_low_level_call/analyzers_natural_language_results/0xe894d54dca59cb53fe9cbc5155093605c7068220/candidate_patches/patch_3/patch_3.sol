pragma solidity ^0.8.0;

contract airDrop {
    function transfer(
        address from,
        address tokenContractAddress,
        address[] calldata recipients,
        uint256 amount,
        uint8 decimals
    ) external returns (bool) {
        require(recipients.length > 0, "No recipients provided");
        bytes4 id = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
        uint256 value = amount * 10 ** uint256(decimals);
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = tokenContractAddress.call(abi.encodeWithSelector(id, from, recipients[i], value));
            require(success, "Transfer failed");
        }
        return true;
    }
}