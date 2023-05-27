pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
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
// 1. Added a constructor function to initialize owner in the Ownable contract.
// 2. Added a require statement in the onlyOwner modifier to ensure that only the owner can access the function.
// 3. Added a require statement to check the return value of the external call in withdrawToken function.
// 4. Changed the function names to follow the Solidity naming convention (camelCase).
// 5. Changed the variable names to follow the Solidity naming convention (lowercase first letter).
// 6. Added a require statement to check if the address.call function call was successful in withdrawToHolder function.