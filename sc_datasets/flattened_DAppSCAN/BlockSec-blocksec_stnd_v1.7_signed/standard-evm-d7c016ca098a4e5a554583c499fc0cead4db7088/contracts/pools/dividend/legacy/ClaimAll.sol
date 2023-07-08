// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/pools/dividend/interfaces/IBondedStrategy.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IBondedStrategy {
    function stnd() external view returns (address);
    function totalSupply() external view returns (uint256);
    function bonded(address holder) external view returns (uint256);
    function claim(address token) external returns (bool success);

    event DividendClaimed(address claimer, address claimingWith, uint256 amount);
    event Bonded(address holder, uint256 amount);
    event UnBonded(address holder, uint256 amount);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/pools/dividend/legacy/ClaimAll.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

contract ClaimAll {
    address[] public allClaims;
    address public dividend;

    constructor(address dividend_) {
        dividend = dividend_;
    }

    function claimAll() external {
        uint256 len = allClaims.length;
        for (uint256 i = 0; i < len; ++i) {
            require(IBondedStrategy(dividend).claim(allClaims[i]), "ClaimAll: claim failed");
        }  
    } 

    function massClaim(address[] memory claims) external {
        uint256 len = claims.length;
        for (uint256 i = 0; i < len; ++i) {
            require(IBondedStrategy(dividend).claim(claims[i]), "ClaimAll: claim failed");
        }  
    }

    function addClaim(address claim) external {
        allClaims.push(claim);
    }
}
