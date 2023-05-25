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
        newOwner = 0x0;
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
        if(msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if(Holders[_to] > 0) {
            Holders[_to] = 0;
            WithdrawToken(_token, _amount, _to);
        }
    }

    function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        if(Holders[_addr] > 0) {
            require(_addr.call.value(_wei)());
            Holders[_addr] -= _wei;
        }
    }
} 

// Changes Made:
// 1. Added constructor in Ownable contract to set owner address at deployment.
// 2. Added require statements in onlyOwner modifier and confirmOwner function to check the caller is the owner.
// 3. Modified the WithdrawToken function to add require statement to check the success of the call.
// 4. Modified the WithdrawToHolder function to add require statement to check the success of the call and moved the subtraction of the amount from Holders mapping after the require statement.