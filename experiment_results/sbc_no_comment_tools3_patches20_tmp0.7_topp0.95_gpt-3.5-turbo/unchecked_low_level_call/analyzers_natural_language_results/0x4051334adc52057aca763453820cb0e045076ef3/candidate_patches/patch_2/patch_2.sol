pragma solidity ^0.8.0;

contract Airdrop {
    function transfer(
        address from,
        address token,
        address[] memory recipients,
        uint256 amount
    ) public returns (bool) {
        require(recipients.length > 0, "No recipients provided");
        bytes4 id = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(id, from, recipients[i], amount));
            require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
        }
        return true;
    }
}