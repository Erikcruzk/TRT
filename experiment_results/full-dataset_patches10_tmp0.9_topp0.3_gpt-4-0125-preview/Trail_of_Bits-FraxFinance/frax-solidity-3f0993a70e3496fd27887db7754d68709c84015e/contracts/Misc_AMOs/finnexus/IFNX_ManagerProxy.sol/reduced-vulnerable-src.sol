


pragma solidity 0.6.11;











contract Context {
    
    
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}




pragma solidity 0.6.11;














library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    










    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    








    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    










    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    












    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    












    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}




pragma solidity 0.6.11;






interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}




pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;







interface IFNX_ManagerProxy {
    


    function getCollateralRate(address )external view returns (uint256) ;

    



    function getUserPayingUsd(address )external view returns (uint256);

    




    function userInputCollateral(address ,address )external view returns (uint256);

    



    function getUserTotalWorth(address )external view returns (uint256);

    


    function getTokenNetworth() external view returns (uint256);

    




    function addCollateral(address ,uint256 ) external payable;

    





    function redeemCollateral(uint256 ,address ) external;
    
    





    function calCollateralWorth(address )external view returns(uint256[] memory);

    


    function getOccupiedCollateral() external view returns(uint256);

    


    function getAvailableCollateral() external view returns(uint256);

    


    function getLeftCollateral() external view returns(uint256);

    


    function getUnlockedCollateral() external view returns(uint256);


    


    function getTotalCollateral() external view returns(uint256);

    


    function getRealBalance(address )external view returns(int256);
    function getNetWorthBalance(address )external view returns(uint256);

    



    function calculateCollateralRate() external view returns (uint256);

    

 
    function getPriceRateRange() external view returns(uint256,uint256) ;
    
    function getALLCollateralinfo(address )external view 
        returns(uint256[] memory,int256[] memory,uint32[] memory,uint32[] memory);
}