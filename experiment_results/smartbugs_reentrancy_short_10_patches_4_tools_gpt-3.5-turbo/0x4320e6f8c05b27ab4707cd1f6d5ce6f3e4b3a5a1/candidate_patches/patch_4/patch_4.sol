/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 55
 */

pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping (address=>uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool intitalized;
    
    function setMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }
    
    function setLogFile(address _log) public {
        require(!intitalized);
        Log = LogFile(_log);
    }
    
    function initialized() public {
        intitalized = true;
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }
    
    function() public payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data) public {
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
}