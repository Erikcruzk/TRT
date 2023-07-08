// File: ../sc_datasets/DAppSCAN/PeckShield-Arche/Arche_v1.0_Eros-909f35e0064d636aaf61954a6026fda7b2bade7f/TradingCharge.sol

contract Trading_Charge
{
    function Amount(uint256 amount ,address to)public view returns(uint256)
    {
      uint256 charge=amount/1000;
      charge=charge*3;
      uint256 res=amount-charge;
      return res;
    }
}
