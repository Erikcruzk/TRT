// File: ../sc_datasets/DAppSCAN/Solidified-2Key [14.10.2019]/contracts-de171eb80e9ce1c6566a5d782f0a0549ab0151ad/contracts/2key/interfaces/ITwoKeyPlasmaEvents.sol

pragma solidity ^0.4.24;

contract ITwoKeyPlasmaEvents {
    function emitPlasma2EthereumEvent(
        address _plasma,
        address _ethereum
    )
    public;

    function emitPlasma2HandleEvent(
        address _plasma,
        string _handle
    )
    public;
}