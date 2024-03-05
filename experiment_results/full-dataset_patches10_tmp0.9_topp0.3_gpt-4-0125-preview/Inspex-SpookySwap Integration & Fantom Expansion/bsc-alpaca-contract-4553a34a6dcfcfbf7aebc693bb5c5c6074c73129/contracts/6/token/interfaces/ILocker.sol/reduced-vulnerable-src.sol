




pragma solidity ^0.8.0;




interface IERC20 {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
















pragma solidity 0.6.6;

interface ILocker {
    function calLockAmount(uint256 alpacaAmount) external returns (uint256);
    function lockOf(address user) external returns (uint256);
    function lock(address user, uint256 alpacaAmount) external;
    function pendingTokens(address user) external returns (IERC20[] memory, uint256[] memory);
    function claim() external;

    event Lock(address indexed to, uint256 value);
}