pragma solidity ^0.4.23;

contract KeepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        msg.sender.transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
    }
} 

// Changes made:
// - Capitalized contract name to follow best practices
// - Added require statement to check that balance is greater than 0 before withdrawing
// - Changed call to transfer in withdraw function to ensure return value is checked and avoid potential reentrancy attacks
// - Removed unnecessary comment about smart contract analyzers