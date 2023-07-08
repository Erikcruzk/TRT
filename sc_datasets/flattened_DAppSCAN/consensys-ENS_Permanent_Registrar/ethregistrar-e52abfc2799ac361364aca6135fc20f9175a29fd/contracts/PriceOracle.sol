// File: ../sc_datasets/DAppSCAN/consensys-ENS_Permanent_Registrar/ethregistrar-e52abfc2799ac361364aca6135fc20f9175a29fd/contracts/PriceOracle.sol

pragma solidity >=0.4.24;

interface PriceOracle {
    /**
     * @dev Returns the price to register or renew a name.
     * @param name The name being registered or renewed.
     * @param expires When the name presently expires (0 if this is a new registration).
     * @param duration How long the name is being registered or extended for, in seconds.
     * @return The price of this renewal or registration, in wei.
     */
    function price(string calldata name, uint expires, uint duration) external view returns(uint);
}
