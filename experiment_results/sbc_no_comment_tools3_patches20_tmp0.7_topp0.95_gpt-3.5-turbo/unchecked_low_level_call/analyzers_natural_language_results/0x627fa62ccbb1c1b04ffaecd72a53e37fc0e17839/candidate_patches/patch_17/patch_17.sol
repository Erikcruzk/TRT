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
    function WithdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        Deposit();
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            WithdrawToken(_token, _amount, _to);
        }
    }

    function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        if (Holders[_addr] > 0) {
            require(_addr.call.value(_wei)());
            Holders[_addr] -= _wei;
        }
    }
} 

// Changes Made:
// 1. Added constructor to Ownable to set the owner.
// 2. Added require statement to confirmOwner function in Ownable to check if the caller is the new owner.
// 3. Added address(0) to newOwner in confirmOwner function to reset the newOwner variable.
// 4. Added require statement to WithdrawToken function in Token to check if the low-level call was successful.
// 5. Added require statement to WithdrawToHolder function in TokenBank to check if the low-level call was successful.