// File: ../sc_datasets/DAppSCAN/QuillAudits-Alium Finance Smart Contract/alium-farm-e37d6af39af68049c2684085f025385407b4bd55/contracts/interfaces/IFarmingTicketWindow.sol

pragma solidity =0.6.12;

interface IFarmingTicketWindow {
    function hasTicket(address account) external view returns (bool);
}
