pragma solidity ^0.8.0;

contract Splitter {
    address public owner;
    address[] public puppets;
    mapping(uint256 => address) public extra;
    uint256 private _share;

    constructor() payable {
        owner = msg.sender;
        puppets.push(address(new Puppet()));
        puppets.push(address(new Puppet()));
        puppets.push(address(new Puppet()));
        puppets.push(address(new Puppet()));
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

    function newPuppet() public returns (address newPuppet) {
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
        require(msg.sender == owner, "Only the owner can fund puppets");
        _share = msg.value / 4;

        (bool success0, ) = extra[0].call{value: _share, gas: 80000}("");
        require(success0, "Failed to send funds to puppet 0");

        (bool success1, ) = extra[1].call{value: _share, gas: 80000}("");
        require(success1, "Failed to send funds to puppet 1");

        (bool success2, ) = extra[2].call{value: _share, gas: 80000}("");
        require(success2, "Failed to send funds to puppet 2");

        (bool success3, ) = extra[3].call{value: _share, gas: 80000}("");
        require(success3, "Failed to send funds to puppet 3");
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
        require(msg.sender != target[0], "Cannot call target directly");
        (bool success, ) = target[0].call{value: msg.value, gas: 60000}("");
        require(success, "Failed to forward funds to target");
    }

    function withdraw() public {
        require(msg.sender == master[0], "Only the master can withdraw funds");
        payable(master[0]).transfer(address(this).balance);
    }
}