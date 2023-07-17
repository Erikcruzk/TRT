// File: ../sc_datasets/DAppSCAN/Chainsecurity-POA Network  OmniBridge/omnibridge-9e602a3719e32feabc18fc387b9474acfa28cfe2/contracts/interfaces/IOmnibridge.sol

pragma solidity 0.7.5;

interface IOmnibridge {
    function relayTokens(
        address _token,
        address _receiver,
        uint256 _value
    ) external;
}
