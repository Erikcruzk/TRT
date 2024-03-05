

pragma solidity ^0.4.24;







contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  function allowance(address _ocwner, address _spender) public view returns (uint256);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}



pragma solidity ^0.4.24;





contract ERC20 is ERC20Basic {

}



pragma solidity ^0.4.24;






library SafeMath {

  


  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    
    
    
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  


  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    
    
    
    return _a / _b;
  }

  


  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  


  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}



pragma solidity ^0.4.24;








library SafeERC20 {
  function safeTransfer(
    ERC20Basic _token,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transfer(_to, _value));
  }

  function safeTransferFrom(
    ERC20 _token,
    address _from,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transferFrom(_from, _to, _value));
  }

  function safeApprove(
    ERC20 _token,
    address _spender,
    uint256 _value
  )
    internal
  {
    require(_token.approve(_spender, _value));
  }
}



pragma solidity ^0.4.24;















contract Crowdsale {
  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  
  ERC20 public token;

  
  address public wallet;

  
  
  
  
  uint256 public rate;

  
  uint256 public weiRaised;

  






  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  




  constructor(uint256 _rate, address _wallet, ERC20 _token) public {
    require(_rate > 0);
    require(_wallet != address(0));
    require(_token != address(0));

    rate = _rate;
    wallet = _wallet;
    token = _token;
  }

  
  
  

  


  function () external payable {
    buyTokens(msg.sender);
  }

  



  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    
    uint256 tokens = _getTokenAmount(weiAmount);

    
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
    emit TokenPurchase(
      msg.sender,
      _beneficiary,
      weiAmount,
      tokens
    );

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  
  
  

  







  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
  internal
  {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  




  function _postValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
  internal
  {
    
  }

  




  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
  internal
  {
    token.safeTransfer(_beneficiary, _tokenAmount);
  }

  




  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
  internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  




  function _updatePurchasingState(
    address _beneficiary,
    uint256 _weiAmount
  )
  internal
  {
    
  }

  




  function _getTokenAmount(uint256 _weiAmount)
  internal view returns (uint256)
  {
    return _weiAmount.mul(rate);
  }

  


  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}



pragma solidity ^0.4.24;









contract AllowanceCrowdsale is Crowdsale {
  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  address public tokenWallet;

  



  constructor(address _tokenWallet) public {
    require(_tokenWallet != address(0));
    tokenWallet = _tokenWallet;
  }

  



  function remainingTokens() public view returns (uint256) {
    return token.allowance(tokenWallet, this);
  }

  




  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
  }
}