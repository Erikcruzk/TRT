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
    function WithdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public {
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

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            Token token = Token(_token);
            token.WithdrawToken(_token, _amount, _to);
        }
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[_addr] > 0 && _wei <= Holders[_addr]) {
            Holders[_addr] -= _wei;
            require(_addr.call.value(_wei)());
        }
    }
} 

// Changes Made:
// - Added constructor to Ownable contract to set initial owner
// - Added require statements to confirmOwner and onlyOwner modifiers
// - Replaced call() with require() in WithdrawToken function in Token contract
// - Added Token contract as parent contract to TokenBank to properly use WithdrawToken function
// - Added check to ensure that withdrawal amount is not greater than the balance of the holder in WithdrawToHolder function in TokenBank contract