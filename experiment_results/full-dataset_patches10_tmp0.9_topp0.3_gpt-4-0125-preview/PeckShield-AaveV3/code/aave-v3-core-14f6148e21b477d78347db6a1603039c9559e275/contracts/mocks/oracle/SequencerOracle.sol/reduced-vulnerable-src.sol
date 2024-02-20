


pragma solidity 0.8.7;











abstract contract Context {
  function _msgSender() internal view virtual returns (address payable) {
    return payable(msg.sender);
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this; 
    return msg.data;
  }
}





pragma solidity 0.8.7;













contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  


  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  


  function owner() public view returns (address) {
    return _owner;
  }

  


  modifier onlyOwner() {
    require(_owner == _msgSender(), 'Ownable: caller is not the owner');
    _;
  }

  






  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  



  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}




pragma solidity 0.8.7;






interface ISequencerOracle {
  function latestAnswer() external view returns (bool, uint256);
}




pragma solidity 0.8.7;


contract SequencerOracle is ISequencerOracle, Ownable {
  bool internal _isDown;
  uint256 internal _timestampGotUp;

  function setAnswer(bool isDown, uint256 timestamp) external onlyOwner {
    _isDown = isDown;
    _timestampGotUp = timestamp;
  }

  function latestAnswer() external view override returns (bool, uint256) {
    return (_isDown, _timestampGotUp);
  }
}