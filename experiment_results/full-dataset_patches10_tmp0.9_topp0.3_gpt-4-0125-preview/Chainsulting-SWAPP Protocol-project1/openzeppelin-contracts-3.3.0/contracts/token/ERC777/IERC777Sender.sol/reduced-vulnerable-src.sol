



pragma solidity >=0.6.0 <0.8.0;











interface IERC777Sender {
    









    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}