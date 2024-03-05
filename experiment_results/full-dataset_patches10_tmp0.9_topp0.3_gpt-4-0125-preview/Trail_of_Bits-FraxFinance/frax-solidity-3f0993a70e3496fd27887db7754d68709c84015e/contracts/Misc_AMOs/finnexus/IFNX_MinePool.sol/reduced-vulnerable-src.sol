


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




interface IFNX_MinePool {
    


    function getFPTAAddress() external view returns (address);
    


    function getFPTBAddress() external view returns (address);
    


    function getStartTime() external view returns (uint256);
    


    function getCurrentPeriodID() external view returns (uint256);
    



    function getUserFPTABalance(address ) external view returns (uint256);
    



    function getUserFPTBBalance(address ) external view returns (uint256);
    



    function getUserMaxPeriodId(address ) external view returns (uint256);
    



    function getUserExpired(address ) external view returns (uint256);
    function getCurrentTotalAPY(address ) external view returns (uint256);
    




    function getUserCurrentAPY(address ,address ) external view returns (uint256);
    function getAverageLockedTime() external view returns (uint256);
    




    function redeemOut(address ,uint256 ) external;
    



    function getTotalMined(address ) external view returns(uint256);
    




    function getMineInfo(address ) external view returns(uint256,uint256);
    




    function getMinerBalance(address ,address ) external view returns(uint256);
    





    function setMineCoinInfo(address ,uint256 ,uint256 ) external ;

    




    function redeemMinerCoin(address ,uint256 ) external;
    



    function getMineWeightRatio() external view returns (uint256);
    


    function getTotalDistribution() external view returns (uint256);
    


 
    function getPeriodIndex(uint256 ) external view returns (uint256);
    



    function getPeriodFinishTime(uint256 ) external view returns (uint256);
    



    function stakeFPTA(uint256 ) external ;
    




    function lockAirDrop(address ,uint256 ) external;
    




    function stakeFPTB(uint256 ,uint256 ) external;
    



    function unstakeFPTA(uint256 ) external ;
    



    function unstakeFPTB(uint256 ) external;
    



    function changeFPTBLockedPeriod(uint256 ) external;

       


    function getTotalPremium() external view returns(uint256);
    


    function redeemPremium() external;
    



    function redeemPremiumCoin(address ,uint256 ) external;
    


 
    function getUserLatestPremium(address ,address ) external view returns(uint256);
 
    



 
    function distributePremium(address ,uint256 ,uint256 ) external ;
}

























































































































































































































































































































































































































































 














































