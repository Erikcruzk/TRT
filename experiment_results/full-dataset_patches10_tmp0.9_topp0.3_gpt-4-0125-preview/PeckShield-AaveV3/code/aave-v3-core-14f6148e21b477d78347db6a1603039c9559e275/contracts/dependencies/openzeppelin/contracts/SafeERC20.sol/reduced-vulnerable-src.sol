


pragma solidity 0.8.7;




interface IERC20 {
  


  function totalSupply() external view returns (uint256);

  


  function balanceOf(address account) external view returns (uint256);

  






  function transfer(address recipient, uint256 amount) external returns (bool);

  






  function allowance(address owner, address spender) external view returns (uint256);

  













  function approve(address spender, uint256 amount) external returns (bool);

  








  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  





  event Transfer(address indexed from, address indexed to, uint256 value);

  



  event Approval(address indexed owner, address indexed spender, uint256 value);
}




pragma solidity 0.8.7;




library Address {
  
















  function isContract(address account) internal view returns (bool) {
    
    
    
    bytes32 codehash;
    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    
    assembly {
      codehash := extcodehash(account)
    }
    return (codehash != accountHash && codehash != 0x0);
  }

  















  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, 'Address: insufficient balance');

    
    (bool success, ) = recipient.call{value: amount}('');
    require(success, 'Address: unable to send value, recipient may have reverted');
  }
}





pragma solidity 0.8.7;











library SafeERC20 {
  using Address for address;

  function safeTransfer(
    IERC20 token,
    address to,
    uint256 value
  ) internal {
    callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  ) internal {
    callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
  }

  function safeApprove(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    require(
      (value == 0) || (token.allowance(address(this), spender) == 0),
      'SafeERC20: approve from non-zero to non-zero allowance'
    );
    callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
  }

  function callOptionalReturn(IERC20 token, bytes memory data) private {
    require(address(token).isContract(), 'SafeERC20: call to non-contract');

    
    (bool success, bytes memory returndata) = address(token).call(data);
    require(success, 'SafeERC20: low-level call failed');

    if (returndata.length > 0) {
      
      
      require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
    }
  }
}