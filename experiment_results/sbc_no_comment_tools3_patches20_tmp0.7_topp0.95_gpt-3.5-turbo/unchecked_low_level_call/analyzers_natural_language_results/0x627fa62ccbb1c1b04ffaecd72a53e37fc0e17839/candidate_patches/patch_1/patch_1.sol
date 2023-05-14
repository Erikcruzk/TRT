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
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token != address(0));
        require(to != address(0));
        require(amount > 0);
        require(Token(token).transfer(to, amount));
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
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
        require(to != address(0));
        require(token != address(0));
        require(amount > 0);
        require(holders[to] > 0);
        holders[to] = 0;
        Token(token).withdrawToken(token, amount, to);
    }

    function withdrawToHolder(address addr, uint weiAmount) public onlyOwner {
        require(addr != address(0));
        require(weiAmount > 0);
        require(holders[addr] > 0);
        require(addr.call.value(weiAmount)());
        holders[addr] -= weiAmount;
    }
} 

// Changes Made:
// 1. Made state variables public where necessary.
// 2. Added constructor function to initialize owner.
// 3. Added require statements to check for valid input parameters and conditions.
// 4. Added confirmOwner function to confirm the new owner.
// 5. Renamed WithdrawToken function to withdrawToken to follow Solidity naming conventions.
// 6. Removed Token contract inheritance from TokenBank to remove unnecessary complexity.
// 7. Renamed initTokenBank function to TokenBank to follow Solidity naming conventions.
// 8. Fixed the low-level calls by adding require statements and removing unnecessary sha3() function call.