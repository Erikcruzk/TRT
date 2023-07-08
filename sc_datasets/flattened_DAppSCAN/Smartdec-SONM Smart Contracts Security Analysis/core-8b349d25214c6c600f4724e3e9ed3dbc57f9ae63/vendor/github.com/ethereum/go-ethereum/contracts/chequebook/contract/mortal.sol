// File: ../sc_datasets/DAppSCAN/Smartdec-SONM Smart Contracts Security Analysis/core-8b349d25214c6c600f4724e3e9ed3dbc57f9ae63/vendor/github.com/ethereum/go-ethereum/contracts/chequebook/contract/owned.sol

pragma solidity ^0.4.0;

contract owned {
    address owner;

    modifier onlyowner() {
        if (msg.sender == owner) {
            _;
        }
    }

    function owned() public {
        owner = msg.sender;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-SONM Smart Contracts Security Analysis/core-8b349d25214c6c600f4724e3e9ed3dbc57f9ae63/vendor/github.com/ethereum/go-ethereum/contracts/chequebook/contract/mortal.sol

pragma solidity ^0.4.0;

contract mortal is owned {
    function kill() public {
        if (msg.sender == owner)
            selfdestruct(owner);
    }
}
