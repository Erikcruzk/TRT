

pragma solidity ^0.8.0;

interface IBEP20 {
    


    function totalSupply() external view returns (uint256);

    


    function decimals() external view returns (uint8);

    


    function symbol() external view returns (string memory);

    


    function name() external view returns (string memory);

    


    function getOwner() external view returns (address);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address _owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract PancakeVoterProxy {
    
    address public constant votes = 0x009cF7bC57584b7998236eff51b98A168DceA9B0;

    function decimals() external pure returns (uint8) {
        return uint8(18);
    }

    function name() external pure returns (string memory) {
        return "SYRUPVOTE";
    }

    function symbol() external pure returns (string memory) {
        return "SYRUP";
    }

    function totalSupply() external view returns (uint256) {
        return IBEP20(votes).totalSupply();
    }

    function balanceOf(address _voter) external view returns (uint256) {
        return IBEP20(votes).balanceOf(_voter);
    }

    constructor() public {}
}