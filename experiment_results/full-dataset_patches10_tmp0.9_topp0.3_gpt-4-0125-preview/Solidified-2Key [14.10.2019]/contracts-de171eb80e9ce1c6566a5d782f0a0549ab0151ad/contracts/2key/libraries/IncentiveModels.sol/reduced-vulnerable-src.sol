

pragma solidity ^0.4.24;





library IncentiveModels {

    




    function averageModelRewards(
        uint totalRewardEthWEI,
        uint numberOfInfluencers
    ) internal pure returns (uint) {
        if(numberOfInfluencers > 0) {
            uint equalPart = totalRewardEthWEI / numberOfInfluencers;
            return equalPart;
        }
        return 0;
    }

    





    function averageLast3xRewards(
        uint totalRewardEthWEI,
        uint numberOfInfluencers
    ) internal pure returns (uint,uint) {
        if(numberOfInfluencers> 0) {
            uint rewardPerReferrer = totalRewardEthWEI / (numberOfInfluencers + 2);
            uint rewardForLast = rewardPerReferrer*3;
            return (rewardPerReferrer, rewardForLast);
        }
        return (0,0);
    }

    





    function powerLawRewards(
        uint totalRewardEthWEI,
        uint numberOfInfluencers,
        uint factor
    ) internal pure returns (uint[]) {
        uint[] memory rewards = new uint[](numberOfInfluencers);
        if(numberOfInfluencers > 0) {
            uint x = calculateX(totalRewardEthWEI,numberOfInfluencers,factor);
            for(uint i=0; i<numberOfInfluencers;i++) {
                rewards[numberOfInfluencers-i-1] = x / (2**i);
            }
        }
        return rewards;
    }


    





    function calculateX(
        uint sumWei,
        uint numberOfElements,
        uint factor
    ) private pure returns (uint) {
        uint a = 1;
        uint sumOfFactors = 1;
        for(uint i=1; i<numberOfElements; i++) {
            a = a*factor;
            sumOfFactors += a;
        }
        return (sumWei*a) / sumOfFactors;
    }
}