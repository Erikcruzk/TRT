pragma solidity ^0.4.16;

contract Owned {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    address public newOwner;

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }

    function execute(address _dst, uint _value, bytes _data) public onlyOwner {
        require(_dst.call.value(_value)(_data));
    }
}

contract Marriage is Owned {
    string public partner1;
    string public partner2;
    uint public marriageDate;
    string public marriageStatus;
    string public vows;

    Event[] public majorEvents;
    Message[] public messages;

    struct Event {
        uint date;
        string name;
        string description;
        string url;
    }

    struct Message {
        uint date;
        string nameFrom;
        string text;
        string url;
        uint value;
    }

    modifier areMarried() {
        require(keccak256(marriageStatus) == keccak256("Married"));
        _;
    }

    function Marriage(address _owner) public {
        owner = _owner;
    }

    function numberOfMajorEvents() public constant returns (uint) {
        return majorEvents.length;
    }

    function numberOfMessages() public constant returns (uint) {
        return messages.length;
    }

    function createMarriage(
        string _partner1,
        string _partner2,
        string _vows,
        string _url
    ) public onlyOwner {
        require(majorEvents.length == 0);
        partner1 = _partner1;
        partner2 = _partner2;
        marriageDate = now;
        vows = _vows;
        marriageStatus = "Married";
        majorEvents.push(Event(now, "Marriage", vows, _url));
        MajorEvent("Marriage", vows, _url);
    }

    function setStatus(string _status, string _url) public onlyOwner {
        marriageStatus = _status;
        setMajorEvent("Changed Status", _status, _url);
    }

    function setMajorEvent(
        string _name,
        string _description,
        string _url
    ) public onlyOwner areMarried {
        majorEvents.push(Event(now, _name, _description, _url));
        MajorEvent(_name, _description, _url);
    }

    function sendMessage(
        string _nameFrom,
        string _text,
        string _url
    ) public payable areMarried {
        if (msg.value > 0) {
            owner.transfer(this.balance);
        }
        messages.push(Message(now, _nameFrom, _text, _url, msg.value));
        MessageSent(_nameFrom, _text, _url, msg.value);
    }

    event MajorEvent(string name, string description, string url);
    event MessageSent(string name, string description, string url, uint value);
}