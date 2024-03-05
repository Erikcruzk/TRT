

pragma solidity 0.8.6;




















library HegicMath {
    



    function sqrt(uint256 x) internal pure returns (uint256 result) {
        result = x;
        
        uint256 k = (x + 1) >> 1;
        while (k < result) (result, k) = (k, (x / k + k) >> 1);
    }
}