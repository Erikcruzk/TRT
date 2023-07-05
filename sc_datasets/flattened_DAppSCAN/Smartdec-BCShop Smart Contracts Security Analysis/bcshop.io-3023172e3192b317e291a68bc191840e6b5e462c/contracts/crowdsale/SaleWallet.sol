// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/IOwned.sol

pragma solidity ^0.4.10;

/**@dev Simple interface to Owned base class */
contract IOwned {
    function owner() public constant returns (address) {}
    function transferOwnership(address _newOwner) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Owned.sol

pragma solidity ^0.4.10;

contract Owned is IOwned {
    address public owner;        

    function Owned() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    /**@dev allows transferring the contract ownership. */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/crowdsale/SaleWallet.sol

pragma solidity ^0.4.10;

/**@dev Wallet for getting funds for main sale. Transfers portion of Ether to early investor */
contract SaleWallet is Owned {
        
    struct Investor {
        /**@dev Wallet where ether should be returned */
        address wallet;
        /**@dev Amount to be returned */
        uint256 amountToReturn;
        /**@dev true if ether paid to investor, otherwise false */
        bool paid;
    }

    /**@dev List of early investors */
    Investor[] public investors;

    mapping (address => Investor) public investorData;

    /**@dev True if main beneficiary withdrew its share */
    bool mainWithdraw;

    function SaleWallet() {
        mainWithdraw = false;        
    }

    function() payable {

    }

    function totalSumToInvestors() public constant returns(uint256) {
        uint256 total = 0;
        for(uint i = 0; i < investors.length; ++i) {
            total += investors[i].amountToReturn;
        }
        return total;
    }

    /**@dev Adds investor's data to contract */
    function addInvestor(address wallet, uint256 amountInvested, uint256 marginPct) 
        public 
        ownerOnly 
    {
        Investor storage investor = investors[investors.length++];
        investor.wallet = wallet;
        investor.amountToReturn = amountInvested * (100 + marginPct) / 100;
        investor.paid = false;    

        investorData[wallet] = investor;
    }

    /**@dev Pays ether to early investors */
    function payToInvestors() internal {
        uint256 length = investors.length;
        for(uint i = 0; i < length; ++i) {
            if(!investors[i].paid) {
                investors[i].paid = true;

                if(!investors[i].wallet.send(investors[i].amountToReturn)) {
                    investors[i].paid = false;
                }                
            }
        }
    }

    

}
