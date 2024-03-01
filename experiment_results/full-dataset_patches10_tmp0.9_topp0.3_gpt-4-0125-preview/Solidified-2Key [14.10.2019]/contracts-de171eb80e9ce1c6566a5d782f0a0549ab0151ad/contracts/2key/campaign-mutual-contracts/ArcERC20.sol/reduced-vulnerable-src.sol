

pragma solidity ^0.4.24;




contract ArcERC20 {

    uint256 internal totalSupply_ = 1000000;

    mapping(address => uint256) internal balances;

    


    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    




    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

}