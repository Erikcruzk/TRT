// File: ../sc_datasets/DAppSCAN/Iosiro-Nexus Mutual Stacked Risk, On-chain MCR, and Swap Operator Smart Contract Audit/smart-contracts-60efdf64f2198050f7e6fcec57548d40e4f8598f/contracts/mocks/Dummy.sol

contract Dummy {
    constructor () public {

    }
    uint[] xs = [2];
    function doStuff() public view returns (uint) {
        return doMoreStuff(xs);
    }

    function doMoreStuff(uint[] memory xs) public view returns (uint) {
        return xs[0];
    }
}
