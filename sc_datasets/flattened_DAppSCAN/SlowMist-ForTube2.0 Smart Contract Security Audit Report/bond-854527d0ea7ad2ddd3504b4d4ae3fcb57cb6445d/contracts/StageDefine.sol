// File: ../sc_datasets/DAppSCAN/SlowMist-ForTube2.0 Smart Contract Security Audit Report/bond-854527d0ea7ad2ddd3504b4d4ae3fcb57cb6445d/contracts/StageDefine.sol

pragma solidity ^0.6.0;

    enum BondStage {
        //无意义状态
        DefaultStage,
        //评级
        RiskRating,
        RiskRatingFail,
        //募资
        CrowdFunding,
        CrowdFundingSuccess,
        CrowdFundingFail,
        UnRepay,//待还款
        RepaySuccess,
        Overdue,
        //由清算导致的债务结清
        DebtClosed
    }

    //状态标签
    enum IssuerStage {
        DefaultStage,
		UnWithdrawCrowd,
        WithdrawCrowdSuccess,
		UnWithdrawPawn,
        WithdrawPawnSuccess       
    }
