



pragma solidity ^0.7.0;

interface IERC20 {
  function totalSupply() external view returns (uint256 supply);

  function balanceOf(address _owner) external view returns (uint256 balance);

  function transfer(address _to, uint256 _value) external returns (bool success);

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) external returns (bool success);

  function approve(address _spender, uint256 _value) external returns (bool success);

  function allowance(address _owner, address _spender) external view returns (uint256 remaining);

  function decimals() external view returns (uint256 digits);

  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}





pragma solidity ^0.7.0;

abstract contract IWETH {
  function allowance(address, address) public virtual returns (uint256);

  function balanceOf(address) public virtual returns (uint256);

  function approve(address, uint256) public virtual;

  function transfer(address, uint256) public virtual returns (bool);

  function transferFrom(
    address,
    address,
    uint256
  ) public virtual returns (bool);

  function deposit() public payable virtual;

  function withdraw(uint256) public virtual;
}