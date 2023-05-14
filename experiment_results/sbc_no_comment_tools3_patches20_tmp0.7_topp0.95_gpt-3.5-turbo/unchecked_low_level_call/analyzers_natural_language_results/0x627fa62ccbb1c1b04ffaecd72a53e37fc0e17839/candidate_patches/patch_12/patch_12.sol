pragma solidity ^0.8.0;

contract Ownable {
    address private newOwner;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
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

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Token is Ownable {
    function WithdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(IERC20(token).transfer(to, amount), "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    receive() external payable {
        Deposit();
    }

    function Deposit() public payable {
        if(msg.value>MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0, "Recipient has no funds to withdraw");
        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] > 0, "Recipient has no funds to withdraw");
        require(_addr.send(_wei), "Withdrawal failed");
        Holders[_addr] -= _wei;
    }
} 

// Changes Made:
// - Added constructor to Ownable contract
// - Changed changeOwner() function to require the caller to be onlyOwner
// - Added confirmOwner() function to confirm the new owner after changeOwner() has been called
// - Replaced low-level call with IERC20 transfer() function in WithdrawToken() function
// - Added receive() function to TokenBank contract to receive Ether transfers
// - Changed WithdrawTokenToHolder() function to require that recipient has funds to withdraw
// - Changed WithdrawToHolder() function to use require() instead of if() and added require() to check that recipient has funds to withdraw. Also changed _addr to payable type and simplified the function.