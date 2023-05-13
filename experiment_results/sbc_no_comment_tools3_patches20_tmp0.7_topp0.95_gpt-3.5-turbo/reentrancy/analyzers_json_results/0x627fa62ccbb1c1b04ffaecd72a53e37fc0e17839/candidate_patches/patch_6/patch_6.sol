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
            newOwner = address(0);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

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

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (holders[_addr] > 0 && _wei <= holders[_addr]) {
            holders[_addr] -= _wei;
            require(_addr.call.value(_wei)());
        }
    }
} 

// Changes made:
// 1. Made owner and newOwner public to access them outside the contract
// 2. Added constructor to initialize owner
// 3. Made changes in onlyOwner modifier to use require for better security
// 4. Changed function names to follow camelCase convention
// 5. Added require statements to check if conditions are met before executing a transaction
// 6. Added newOwner = address(0) in confirmOwner function to prevent re-entry attacks
// 7. Added condition to check if _wei is less than or equal to holders[_addr] in withdrawToHolder function to prevent underflow attacks.