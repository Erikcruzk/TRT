




pragma solidity ^0.8.0;




interface IERC20Upgradeable {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}















pragma solidity 0.8.11;

interface IRewarder {
  function name() external view returns (string memory);

  function onDeposit(
    uint256 pid,
    address user,
    uint256 alpacaAmount,
    uint256 newStakeTokenAmount
  ) external;

  function onWithdraw(
    uint256 pid,
    address user,
    uint256 alpacaAmount,
    uint256 newStakeTokenAmount
  ) external;

  function onHarvest(
    uint256 pid,
    address user,
    uint256 alpacaAmount
  ) external;

  function pendingTokens(
    uint256 pid,
    address user,
    uint256 alpacaAmount
  ) external view returns (IERC20Upgradeable[] memory, uint256[] memory);
}