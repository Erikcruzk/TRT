



pragma solidity 0.8.13;







interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);
    
    
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}





pragma solidity 0.8.13;












interface IERC2612 {
    





















    function permit(address owner, address spender, uint256 amount, 
                    uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    










    function nonces(address owner) external view returns (uint256);
    
    function version() external view returns (string memory);
    function permitTypeHash() external view returns (bytes32);
    function domainSeparator() external view returns (bytes32);
}





pragma solidity 0.8.13;


interface IATIDToken is IERC20, IERC2612 { 
   
    
    
    event CommunityIssuanceAddressSet(address _communityIssuanceAddress);
    event ATIDStakingAddressSet(address _atidStakingAddress);
    event LockupContractFactoryAddressSet(address _lockupContractFactoryAddress);

    
    
    function sendToATIDStaking(address _sender, uint256 _amount) external;

    function getDeploymentStartTime() external view returns (uint256);
}