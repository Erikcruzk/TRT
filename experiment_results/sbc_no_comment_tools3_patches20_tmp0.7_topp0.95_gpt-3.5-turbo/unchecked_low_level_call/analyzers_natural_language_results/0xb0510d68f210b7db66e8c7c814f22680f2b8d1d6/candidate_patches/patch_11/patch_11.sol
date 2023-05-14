pragma solidity ^0.4.23;

contract Splitter {
    address public owner;
    address[] public puppets;
    mapping(uint256 => address) public extra;
    uint256 private _share;

    constructor() public payable {
        owner = msg.sender;
        puppets.push(new Puppet());
        puppets.push(new Puppet());
        puppets.push(new Puppet());
        puppets.push(new Puppet());
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

    function newPuppet() public {
        require(msg.sender == owner);
        puppets.push(new Puppet());
    }

    function setExtra(uint256 _id, address _newExtra) public {
        require(_newExtra != address(0));
        extra[_id] = _newExtra;
    }

    function fundPuppets() public payable {
        require(msg.sender == owner);
        _share = msg.value / 4;

        extra[0].transfer(_share);
        extra[1].transfer(_share);
        extra[2].transfer(_share);
        extra[3].transfer(_share);
    }

    function() public payable {}
}

contract Puppet {
    address public target = 0x509Cb8cB2F8ba04aE81eEC394175707Edd37e109;
    address public master = 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956;

    function() public payable {
        require(msg.sender != target);
        target.transfer(msg.value);
    }

    function withdraw() public {
        require(msg.sender == master);
        master.transfer(address(this).balance);
    }
}