



pragma solidity ^0.6.0;






interface IRelayRecipient {
    


    function getHubAddr() external view returns (address);

    
















    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    










    function preRelayedCall(bytes calldata context) external returns (bytes32);

    













    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}