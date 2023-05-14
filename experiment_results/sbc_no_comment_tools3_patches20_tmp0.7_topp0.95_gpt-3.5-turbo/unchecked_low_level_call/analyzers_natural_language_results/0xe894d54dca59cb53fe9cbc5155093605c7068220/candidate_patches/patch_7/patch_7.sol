pragma solidity ^0.8.0;

contract AirDrop {
    function transfer(
        address from,
        address tokenAddress,
        address[] memory receivers,
        uint256 value
    ) public returns (bool) {
        require(receivers.length > 0, "At least one receiver is required.");
        
        for (uint256 i = 0; i < receivers.length; i++) {
            (bool success, ) = tokenAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", from, receivers[i], value));
            require(success, "Token transfer failed.");
        }
        
        return true;
    }
}