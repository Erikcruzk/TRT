pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes made:
// 1. Added the visibility specifier 'public' to the constructor function of PrivateBank.
// 2. Changed the instantiation of TransferLog to 'new Log()' to create a new instance of the Log contract.
// 3. Added the 'require' statement to check if the deposited amount is greater than or equal to the minimum deposit amount.
// 4. Removed the if statement from the CashOut function to simplify the code.
// 5. Replaced the call function with transfer function in the CashOut function to transfer the amount to the caller.
// 6. Added a getBalance function to check the balance of the contract.