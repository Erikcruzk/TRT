



pragma solidity >=0.6.0 <0.8.0;




library Math {
    


    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    


    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    



    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}





pragma solidity >=0.6.0 <0.8.0;




library Arrays {
   








    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        if (array.length == 0) {
            return 0;
        }

        uint256 low = 0;
        uint256 high = array.length;

        while (low < high) {
            uint256 mid = Math.average(low, high);

            
            
            if (array[mid] > element) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        
        if (low > 0 && array[low - 1] == element) {
            return low - 1;
        } else {
            return low;
        }
    }
}





pragma solidity >=0.6.0 <0.8.0;

contract ArraysImpl {
    using Arrays for uint256[];

    uint256[] private _array;

    constructor (uint256[] memory array) public {
        _array = array;
    }

    function findUpperBound(uint256 element) external view returns (uint256) {
        return _array.findUpperBound(element);
    }
}