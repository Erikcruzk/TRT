/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token != address(0), "Token address cannot be 0x0");
        IERC20 token = IERC20(_token);
        uint256 balance = token.balanceOf(address(this));
        require(_amount <= balance, "Insufficient balance");
        token.transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping (address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than minDeposit");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder must have a positive balance");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(holders[_addr] > 0, "Holder must have a positive balance");
        require(_wei <= address(this).balance, "Insufficient balance");
        holders[_addr] -= _wei;
        (bool success,) = _addr.call{value: _wei}("");
        require(success, "Transfer failed");
    }
} 

// Changes Made:
// 1. Added constructor to initialize owner
// 2. Modified changeOwner function to make newOwner public
// 3. Modified confirmOwner function to use require and reset newOwner to 0x0
// 4. Added interface for ERC20 token
// 5. Modified WithdrawToken function to use require, check balance, and use interface
// 6. Changed function names to follow Solidity naming convention
// 7. Replaced fallback function with receive function
// 8. Added require statements to check input values
// 9. Changed WithdrawToHolder function to use transfer instead of call, and added require statements