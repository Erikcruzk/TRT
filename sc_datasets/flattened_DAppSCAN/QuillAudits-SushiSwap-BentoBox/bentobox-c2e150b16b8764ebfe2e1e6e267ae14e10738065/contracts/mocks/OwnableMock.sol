// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/Ownable.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
// Edited by BoringCrypto

contract OwnableData {
    address public owner;
    address public pendingOwner;
}

contract Ownable is OwnableData {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    function transferOwnershipDirect(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function claimOwnership() public {
        require(msg.sender == pendingOwner, "Ownable: caller != pending owner");
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/mocks/OwnableMock.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;

contract OwnableMock is Ownable {}