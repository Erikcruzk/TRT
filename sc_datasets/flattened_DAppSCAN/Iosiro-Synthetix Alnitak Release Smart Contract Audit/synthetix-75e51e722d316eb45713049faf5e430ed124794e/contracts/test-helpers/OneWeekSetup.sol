// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Alnitak Release Smart Contract Audit/synthetix-75e51e722d316eb45713049faf5e430ed124794e/contracts/LimitedSetup.sol

pragma solidity ^0.5.16;

// https://docs.synthetix.io/contracts/source/contracts/limitedsetup
contract LimitedSetup {
    uint public setupExpiryTime;

    /**
     * @dev LimitedSetup Constructor.
     * @param setupDuration The time the setup period will last for.
     */
    constructor(uint setupDuration) internal {
        setupExpiryTime = now + setupDuration;
    }

    modifier onlyDuringSetup {
        require(now < setupExpiryTime, "Can only perform this action during setup");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Alnitak Release Smart Contract Audit/synthetix-75e51e722d316eb45713049faf5e430ed124794e/contracts/test-helpers/OneWeekSetup.sol

pragma solidity ^0.5.16;

contract OneWeekSetup is LimitedSetup(1 weeks) {
    function testFunc() public view onlyDuringSetup returns (bool) {
        return true;
    }

    function publicSetupExpiryTime() public view returns (uint) {
        return setupExpiryTime;
    }
}
