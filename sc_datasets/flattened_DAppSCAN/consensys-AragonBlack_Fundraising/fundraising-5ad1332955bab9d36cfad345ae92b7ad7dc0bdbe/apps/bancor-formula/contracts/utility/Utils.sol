// File: ../sc_datasets/DAppSCAN/consensys-AragonBlack_Fundraising/fundraising-5ad1332955bab9d36cfad345ae92b7ad7dc0bdbe/apps/bancor-formula/contracts/utility/Utils.sol

pragma solidity 0.4.24;

/*
    Utilities & Common Modifiers
*/
contract Utils {
    /**
        constructor
    */
    constructor() public {
    }

    // verifies that an amount is greater than zero
    modifier greaterThanZero(uint256 _amount) {
        require(_amount > 0);
        _;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        require(_address != address(this));
        _;
    }

}
