pragma solidity ^0.8.0;

contract AirDrop {
    function transfer(
        address from,
        address token,
        address[] memory recipients,
        uint256 amount,
        uint256 decimals
    ) public returns (bool) {
        require(recipients.length > 0, "No recipients provided");
        uint256 value = amount * 10 ** decimals;
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = token.call(
                abi.encodeWithSignature("transferFrom(address,address,uint256)", from, recipients[i], value)
            );
            require(success, "Transfer failed");
        }
        return true;
    }
}