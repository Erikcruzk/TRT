

pragma solidity ^0.5.16;



contract EmptyEtherWrapper {
    constructor() public {}

    

    function totalIssuedSynths() public view returns (uint) {
        return 0;
    }

    function distributeFees() external {}
}