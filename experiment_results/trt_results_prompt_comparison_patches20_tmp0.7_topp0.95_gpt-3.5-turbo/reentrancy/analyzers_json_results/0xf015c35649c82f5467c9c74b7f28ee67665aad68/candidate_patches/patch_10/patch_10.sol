pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value must be greater than 0");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime,
            "Insufficient funds or account locked"
        );
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
    }
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

/**
 * This Solidity Smart Contract has been analyzed by smart contract analyzers.
 * Here are the results from these analyzers.
 *
 * securify:
 *   successfull_analysis: true
 *   errors: []
 *   vulnerability_findings:
 *     - name: "reentrancy"
 *       vulnerability_from_line: null
 *       vulnerability_to_line: null
 *       vulnerability_code: null
 *       message: null
 *
 * slither:
 *   successfull_analysis: true
 *   errors:
 *     - "EXIT_CODE_21"
 *   vulnerability_findings:
 *     - name: "reentrancy"
 *       vulnerability_from_line: 24
 *       vulnerability_to_line: 24
 *       vulnerability_code: "        acc.balance -= _am;\n        msg.sender.transfer(_am);"
 *       message: "No reentrancy vulnerabilities were found."
 *
 * oyente:
 *   successfull_analysis: true
 *   errors: []
 *   vulnerability_findings:
 *     - name: "reentrancy"
 *       vulnerability_from_line: 24
 *       vulnerability_to_line: null
 *       vulnerability_code: "        acc.balance -= _am;\n        msg.sender.transfer(_am);"
 *       message: null
 */