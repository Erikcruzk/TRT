pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;
    address public owner;

    Log transferLog;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function PrivateDeposit() public {
        owner = msg.sender;
        transferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        transferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
} 

// The repaired contract includes the following changes:
// 1. Renamed MinDeposit to minDeposit to follow Solidity naming conventions.
// 2. Changed require(tx.origin == owner) to require(msg.sender == owner) for better security.
// 3. Changed constructor function to use the 'public' keyword.
// 4. Added require(msg.value >= minDeposit) to the deposit function to prevent deposits below the minimum value.
// 5. Removed the if statement in the deposit function as it is not necessary.
// 6. Removed the if statement in the cashOut function and replaced it with a require statement for better security.
// 7. Changed the external call in the cashOut function to use the transfer function for better security.
// 8. Changed the struct initialization in the addMessage function to use the memory keyword for better efficiency.