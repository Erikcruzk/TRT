pragma solidity ^0.5.0;

contract Splitter {
    address payable public owner;
    address payable[] public puppets;
    mapping(uint256 => address payable) public extra;
    uint256 private _share;
    uint256 private _count;

    constructor() public payable {
        owner = msg.sender;
        puppets.push(address(uint160(address(new Puppet()))));
        puppets.push(address(uint160(address(new Puppet()))));
        puppets.push(address(uint160(address(new Puppet()))));
        puppets.push(address(uint160(address(new Puppet()))));
        extra[0] = puppets[0];
        extra[1] = puppets[1];
        extra[2] = puppets[2];
        extra[3] = puppets[3];
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }

    function getPuppetCount() public view returns (uint256 puppetCount) {
        return puppets.length;
    }

    function newPuppet() public returns (address payable newPuppet) {
        require(msg.sender == owner);
        Puppet p = new Puppet();
        puppets.push(address(uint160(address(p))));
        return address(uint160(address(p)));
    }

    function setExtra(uint256 _id, address payable _newExtra) public {
        require(_newExtra != address(0));
        extra[_id] = _newExtra;
    }

    function fundPuppets() public payable {
        require(msg.sender == owner);
        _share = msg.value / 4;

        (bool success1, ) = extra[0].call.value(_share).gas(800000)("");
        require(success1, "Call to first puppet failed");

        (bool success2, ) = extra[1].call.value(_share).gas(800000)("");
        require(success2, "Call to second puppet failed");

        (bool success3, ) = extra[2].call.value(_share).gas(800000)("");
        require(success3, "Call to third puppet failed");

        (bool success4, ) = extra[3].call.value(_share).gas(800000)("");
        require(success4, "Call to fourth puppet failed");
    }

    function() external payable {}
}

contract Puppet {
    mapping(uint256 => address payable) public target;
    mapping(uint256 => address payable) public master;

    constructor() public payable {
        target[0] = 0x509Cb8cB2F8ba04aE81eEC394175707Edd37e109;
        master[0] = 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956;
    }

    function() external payable {
        require(msg.sender == target[0], "Unauthorized caller");
        (bool success, ) = target[0].call.value(msg.value).gas(600000)("");
        require(success, "Call to target failed");
    }

    function withdraw() public {
        require(msg.sender == master[0], "Unauthorized caller");
        (bool success, ) = master[0].call.value(address(this).balance)("");
        require(success, "Withdrawal failed");
    }
} 

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "Multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction underflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }
} 

// Changes Made
// 1. Converted owner, puppets, extra mapping values to address payable
// 2. Updated the getPuppetCount() function to view instead of constant
// 3. Changed function signature for fallback function to external payable
// 4. Added require statements to check for success of external calls and prevent unauthorized access
// 5. Updated SafeMath library to include require statements to prevent overflow and underflow errors