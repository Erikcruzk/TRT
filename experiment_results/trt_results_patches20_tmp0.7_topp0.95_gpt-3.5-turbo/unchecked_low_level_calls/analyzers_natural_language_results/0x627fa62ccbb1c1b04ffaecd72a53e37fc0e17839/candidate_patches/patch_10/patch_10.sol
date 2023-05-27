pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        if (holders[_addr] > 0) {
            require(_addr.call.value(_wei)());
            holders[_addr] -= _wei;
        }
    }
} 

// Changes Made:
// - Added visibility modifiers for functions and variables
// - Added constructor function to initialize owner
// - Replaced sha3 with keccak256
// - Added require statement to check return value of external call in withdrawToken function
// - Renamed some variables and functions to follow Solidity naming conventions
// - Fixed the onlyOwner modifier in Ownable contract to use require statement instead of if statement
// - Changed WithdrawToken function in Token contract to withdrawToken and added visibility modifier
// - Changed initTokenBank function to constructor function in TokenBank contract
// - Fixed spelling errors in comments and variable names