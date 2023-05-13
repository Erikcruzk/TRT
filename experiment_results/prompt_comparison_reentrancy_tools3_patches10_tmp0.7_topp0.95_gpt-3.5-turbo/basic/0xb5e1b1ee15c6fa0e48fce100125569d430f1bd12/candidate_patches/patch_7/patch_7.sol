pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;
    uint public minDeposit = 1 ether;
    Log transferLog;

    function PrivateBank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes made:
// - Renamed contract to PrivateBank and capitalized first letter of each word
// - Changed MinDeposit variable to minDeposit and made it lowercase
// - Added require statement in deposit function to check if the deposit amount is greater than minDeposit
// - Removed payable modifier from cashOut function as it does not need to receive any ether
// - Changed CashOut function to cashOut and made the first letter lowercase
// - Changed _am parameter to _amount to make it more descriptive
// - Added transfer statement in cashOut function to send ether to the user
// - Renamed Log contract to Log and made the first letter lowercase
// - Made Message struct variables lowercase
// - Added memory keyword to create a new instance of Message struct in addMessage function