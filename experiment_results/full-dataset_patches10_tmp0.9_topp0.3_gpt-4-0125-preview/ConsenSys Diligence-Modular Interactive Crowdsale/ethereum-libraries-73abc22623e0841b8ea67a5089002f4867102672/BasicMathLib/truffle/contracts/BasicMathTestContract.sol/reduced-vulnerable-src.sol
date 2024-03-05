

pragma solidity ^0.4.18;





























library BasicMathLib {
  
  
  
  
  
  
  function times(uint256 a, uint256 b) public pure returns (bool err,uint256 res) {
    assembly{
      res := mul(a,b)
      switch or(iszero(b), eq(div(res,b), a))
      case 0 {
        err := 1
        res := 0
      }
    }
  }

  
  
  
  
  
  
  function dividedBy(uint256 a, uint256 b) public pure returns (bool err,uint256 i) {
    uint256 res;
    assembly{
      switch iszero(b)
      case 0 {
        res := div(a,b)
        let loc := mload(0x40)
        mstore(add(loc,0x20),res)
        i := mload(add(loc,0x20))
      }
      default {
        err := 1
        i := 0
      }
    }
  }

  
  
  
  
  
  
  function plus(uint256 a, uint256 b) public pure returns (bool err, uint256 res) {
    assembly{
      res := add(a,b)
      switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
      case 0 {
        err := 1
        res := 0
      }
    }
  }

  
  
  
  
  
  
  function minus(uint256 a, uint256 b) public pure returns (bool err,uint256 res) {
    assembly{
      res := sub(a,b)
      switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
      case 0 {
        err := 1
        res := 0
      }
    }
  }
}



pragma solidity ^0.4.11;

contract BasicMathTestContract {
  using BasicMathLib for uint256;

  function getTimes(uint256 a, uint256 b) returns (bool,uint256){
    return a.times(b);
  }

  function getDividedBy(uint256 a, uint256 b) returns (bool,uint256) {
    return a.dividedBy(b);
  }

  function getPlus(uint256 a, uint256 b) returns (bool,uint256) {
    return a.plus(b);
  }

  function getMinus(uint256 a, uint256 b) returns (bool,uint256) {
    return a.minus(b);
  }

}