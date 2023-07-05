// File: ../sc_datasets/DAppSCAN/PeckShield-PlutosNetworkv3/plutos-virtual-trade-e7acfbe/contracts/utils/SafeMath.sol

pragma solidity >=0.4.21 <0.6.0;

library SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a, "add");
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a, "sub");
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "mul");
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0, "div");
        c = a / b;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-PlutosNetworkv3/plutos-virtual-trade-e7acfbe/contracts/oracletype/ChainlinkOracle.sol

pragma solidity >=0.4.21 <0.6.0;

contract ChainlinkInterface{
  function decimals() external view returns (uint8);
  function latestAnswer() external view returns (int256);
}

contract ChainLinkOracleType{
  using SafeMath for uint256;
  string public name;
 
  constructor() public{
    name = "Chainlink Oracle Type";
  }
  function get_asset_price(address addr) public view returns(uint256){
      return uint256(ChainlinkInterface(addr).latestAnswer()).safeMul(1e18).safeDiv(uint256(10)**ChainlinkInterface(addr).decimals());
  }

  function getPriceDecimal() public pure returns(uint256){
    return 1e18;
  }
}
