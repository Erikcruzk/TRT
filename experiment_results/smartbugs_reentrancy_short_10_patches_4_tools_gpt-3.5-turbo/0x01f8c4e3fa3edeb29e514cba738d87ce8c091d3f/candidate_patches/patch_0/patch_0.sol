/**
 *Submitted for verification at Etherscan.io on 2021-11-01
*/

pragma solidity ^0.8.9;

contract PersonalBank {
    mapping (address => uint256) public balances;
    uint256 public minSum = 1 ether;
    LogFile public log;
    bool public initialized;

    constructor(address _log) {
        log = LogFile(_log);
    }

    function setMinSum(uint256 _val) public {
        require(!initialized, "Already initialized");
        minSum = _val;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am, "Insufficient funds");

        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");

        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }

    receive() external payable {
        deposit();
    }

    function initialize() public {
        require(!initialized, "Already initialized");
        initialized = true;
    }
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

/**
 * Changes Made:
 * 1. Updated the Solidity version to 0.8.9.
 * 2. Added constructor to initialize the LogFile contract.
 * 3. Changed the function names to follow Solidity naming conventions.
 * 4. Replaced the external function with receive function.
 * 5. Added require statements to check for conditions before executing the code.
 * 6. Moved the balance update before the transfer to prevent reentrancy attack.
 * 7. Updated the LogFile struct to match the function parameter names.
 * 8. Updated the LogFile function to create a new Message struct instance.
 */