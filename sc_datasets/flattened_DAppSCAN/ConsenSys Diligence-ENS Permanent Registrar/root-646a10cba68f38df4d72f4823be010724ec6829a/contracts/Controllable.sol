// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-ENS Permanent Registrar/root-646a10cba68f38df4d72f4823be010724ec6829a/contracts/Ownable.sol

pragma solidity ^0.5.0;

contract Ownable {

    address public owner;

    modifier onlyOwner {
        require(isOwner(msg.sender));
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function isOwner(address addr) public view returns (bool) {
        return owner == addr;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-ENS Permanent Registrar/root-646a10cba68f38df4d72f4823be010724ec6829a/contracts/Controllable.sol

pragma solidity ^0.5.0;

contract Controllable is Ownable {
    mapping(address=>bool) public controllers;

    modifier onlyController {
        require(controllers[msg.sender]);
        _;
    }

    function setController(address controller, bool enabled) public onlyOwner {
        controllers[controller] = enabled;
    }
}