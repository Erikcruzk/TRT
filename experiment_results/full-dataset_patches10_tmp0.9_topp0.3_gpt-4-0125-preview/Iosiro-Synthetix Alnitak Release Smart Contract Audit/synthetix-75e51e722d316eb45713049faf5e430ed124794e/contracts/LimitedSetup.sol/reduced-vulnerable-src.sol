

pragma solidity ^0.5.16;


contract LimitedSetup {
    uint public setupExpiryTime;

    



    constructor(uint setupDuration) internal {
        setupExpiryTime = now + setupDuration;
    }

    modifier onlyDuringSetup {
        require(now < setupExpiryTime, "Can only perform this action during setup");
        _;
    }
}