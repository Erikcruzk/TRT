pragma solidity ^0.4.16;

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
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

    function Marriage() public {
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
    ) public onlyOwner {
        majorEvents.push(Event(now, _name, _description, _url));
        MajorEvent(_name, _description, _url);
    }

    function sendMessage(
        string _nameFrom,
        string _text,
        string _url
    ) public payable {
        require(sha3(marriageStatus) == sha3("Married"));
        if (msg.value > 0) {
            owner.transfer(this.balance);
        }
        messages.push(Message(now, _nameFrom, _text, _url, msg.value));
        MessageSent(_nameFrom, _text, _url, msg.value);
    }

    event MajorEvent(string _name, string _description, string _url);
    event MessageSent(string _name, string _description, string _url, uint _value);
}