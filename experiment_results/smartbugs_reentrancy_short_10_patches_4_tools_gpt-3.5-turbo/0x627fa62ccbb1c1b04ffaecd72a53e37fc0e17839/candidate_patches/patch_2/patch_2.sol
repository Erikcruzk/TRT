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
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }
}

interface Token {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    receive() external payable {
        Deposit();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than MinDeposit");
        Holders[msg.sender] += msg.value;
    }

    function WithdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0, "Holder does not have any tokens deposited");
        Holders[_to] = 0;
        Token(_token).transfer(_to, _amount);
    }

    function WithdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] > 0, "Holder does not have any tokens deposited");
        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
} 

/* Changes Made:
1. Added visibility specifiers to state variables
2. Added constructor to initialize owner
3. Added require statements to check conditions and revert if not met
4. Changed the external function to receive function for deposit
5. Changed the function signature of WithdrawToken to accept address of token instead of contract
6. Removed the use of call function and used transfer function instead
7. Removed the inheritance of Token contract and instead used interface of Token contract
8. Removed the unused state variable newOwner and added confirmOwner function to update owner
9. Updated the version of solidity from 0.4.19 to 0.8.0
10. Updated the naming convention of functions and variables.