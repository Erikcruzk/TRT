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
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() payable public {
        deposit();
    }

    function deposit() payable public {
        if(msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
        if(holders[to] > 0) {
            holders[to] = 0;
            Token(token).withdrawToken(token, amount, to);
        }
    }

    function withdrawToHolder(address addr, uint weiAmount) public onlyOwner {
        if(holders[addr] > 0) {
            require(addr.call.value(weiAmount)());
            holders[addr] -= weiAmount;
        }
    }
} 

// Changes Made:
// 1. Made the 'owner' variable in Ownable contract public to access it in TokenBank contract.
// 2. Added 'require' statements in Token contract for checking the success of the token call.
// 3. Changed the function names to follow the Solidity naming conventions.
// 4. Changed the constructor function name from 'initTokenBank' to 'TokenBank' to act as a constructor.
// 5. Changed the 'WithdrawToken' function to 'withdrawToken' to follow the Solidity naming conventions.
// 6. Changed the 'WithdrawToHolder' function to 'withdrawToHolder' to follow the Solidity naming conventions.
// 7. Made the 'minDeposit' variable in TokenBank contract public to access it outside the contract.