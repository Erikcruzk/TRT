pragma solidity 0.6.11;

contract ForceSend {
    function go(address payable victim) external payable {
        selfdestruct(victim);
    }
}
