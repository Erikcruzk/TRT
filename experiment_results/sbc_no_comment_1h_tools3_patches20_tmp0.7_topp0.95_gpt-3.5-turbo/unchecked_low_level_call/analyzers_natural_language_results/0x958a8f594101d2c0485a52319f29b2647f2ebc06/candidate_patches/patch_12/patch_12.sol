pragma solidity ^0.4.16;

contract Owned {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    address public owner;

    constructor() public {
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
        require(keccak256(abi.encodePacked(marriageStatus)) == keccak256(abi.encodePacked("Married")));
        _;
    }

    constructor(address _owner) public {
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
        string url
    ) public onlyOwner {
        require(majorEvents.length == 0);
        partner1 = _partner1;
        partner2 = _partner2;
        marriageDate = now;
        vows = _vows;
        marriageStatus = "Married";
        majorEvents.push(Event(now, "Marriage", vows, url));
        emit MajorEvent("Marriage", vows, url);
    }

    function setStatus(string status, string url) public onlyOwner {
        marriageStatus = status;
        setMajorEvent("Changed Status", status, url);
    }

    function setMajorEvent(
        string name,
        string description,
        string url
    ) public onlyOwner areMarried {
        majorEvents.push(Event(now, name, description, url));
        emit MajorEvent(name, description, url);
    }

    function sendMessage(
        string nameFrom,
        string text,
        string url
    ) public payable areMarried {
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
        messages.push(Message(now, nameFrom, text, url, msg.value));
        emit MessageSent(nameFrom, text, url, msg.value);
    }

    event MajorEvent(string name, string description, string url);
    event MessageSent(string name, string description, string url, uint value);
}