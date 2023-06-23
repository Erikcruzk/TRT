pragma solidity >=0.5.0 <0.6.0;

import "./JoinSplitABIEncoder.sol";
import "../../../libs/LibEIP712.sol";

contract JoinSplitABIEncoderTest is LibEIP712 {
    function validateJoinSplit(
        bytes calldata, 
        address, 
        uint[6] calldata
    ) 
        external view
        returns (bytes memory) 
    {
        JoinSplitABIEncoder.encodeAndExit(EIP712_DOMAIN_HASH);
    }
}
