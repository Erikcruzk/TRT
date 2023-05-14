pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Caller is not the new owner");
        owner = newOwner;
        newOwner = address(0);
    }
}

interface Token {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenBank is Ownable {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder has no balance");
        holders[_to] = 0;
        require(Token(_token).transfer(_to, _amount), "Token transfer failed");
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(holders[_addr] > 0, "Holder has no balance");
        holders[_addr] -= _wei;
        require(_addr.send(_wei), "ETH transfer failed");
    }
} 

// Changes Made:
// 1. Added constructor to initialize the contract state variables.
// 2. Added visibility specifiers to the state variables.
// 3. Added the receive() function to handle incoming ether.
// 4. Changed function names to follow Solidity naming convention.
// 5. Added error messages to the require statements.
// 6. Removed the unsafe low-level calls and used the interface to call the token transfer and address transfer functions.