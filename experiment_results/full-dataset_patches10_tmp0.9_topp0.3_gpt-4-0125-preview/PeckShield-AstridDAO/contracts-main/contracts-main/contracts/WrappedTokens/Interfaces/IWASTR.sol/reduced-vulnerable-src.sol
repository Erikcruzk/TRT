



pragma solidity 0.8.13;




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






pragma solidity 0.8.13;










interface IERC2612 {
    





















    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    






    function nonces(address owner) external view returns (uint256);
    
    


    function DOMAIN_SEPARATOR() external view returns (bytes32);
}




pragma solidity 0.8.13;


interface IERC3156FlashBorrower {

    








    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}




pragma solidity 0.8.13;

interface IERC3156FlashLender {

    




    function maxFlashLoan(
        address token
    ) external view returns (uint256);

    





    function flashFee(
        address token,
        uint256 amount
    ) external view returns (uint256);

    






    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}






pragma solidity 0.8.13;








interface IWASTR is IERC20, IERC2612, IERC3156FlashLender {

    
    function flashMinted() external view returns(uint256);

    
    
    function deposit() external payable;

    
    
    function depositTo(address to) external payable;

    
    
    
    
    function withdraw(uint256 value) external;

    
    
    
    
    function withdrawTo(address payable to, uint256 value) external;

    
    
    
    
    
    
    
    function withdrawFrom(address from, address payable to, uint256 value) external;

    
    
    
    
    
    function depositToAndCall(address to, bytes calldata data) external payable returns (bool);

    
    
    
    
    
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);

    
    
    
    
    
    
    
    
    function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
}