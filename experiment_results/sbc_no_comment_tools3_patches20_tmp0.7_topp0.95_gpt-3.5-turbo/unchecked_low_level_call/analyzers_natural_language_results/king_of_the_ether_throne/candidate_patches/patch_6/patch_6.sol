pragma solidity ^0.4.24;

contract KingOfTheEtherThrone {
    struct Monarch {
        address etherAddress;
        string name;
        uint claimPrice;
        uint coronationTimestamp;
    }

    address wizardAddress;

    modifier onlywizard() {
        require(msg.sender == wizardAddress);
        _;
    }

    uint public constant startingClaimPrice = 100 finney;

    uint public constant claimPriceAdjustNum = 3;
    uint public constant claimPriceAdjustDen = 2;

    uint public constant wizardCommissionFractionNum = 1;
    uint public constant wizardCommissionFractionDen = 100;

    uint public currentClaimPrice;

    Monarch public currentMonarch;

    Monarch[] public pastMonarchs;

    event ThroneClaimed(
        address usurperEtherAddress,
        string usurperName,
        uint newClaimPrice
    );

    constructor() public {
        wizardAddress = msg.sender;
        currentClaimPrice = startingClaimPrice;
        currentMonarch = Monarch({
            etherAddress: wizardAddress,
            name: "[Vacant]",
            claimPrice: 0,
            coronationTimestamp: block.timestamp
        });
    }

    function numberOfMonarchs() public view returns (uint) {
        return pastMonarchs.length;
    }

    function() public payable {
        claimThrone(string(msg.data));
    }

    function claimThrone(string name) public payable {
        uint valuePaid = msg.value;

        require(valuePaid >= currentClaimPrice);

        if (valuePaid > currentClaimPrice) {
            uint excessPaid = valuePaid - currentClaimPrice;
            msg.sender.transfer(excessPaid);
            valuePaid = currentClaimPrice;
        }

        uint wizardCommission = (valuePaid * wizardCommissionFractionNum) /
            wizardCommissionFractionDen;

        uint compensation = valuePaid - wizardCommission;

        if (currentMonarch.etherAddress != wizardAddress) {
            currentMonarch.etherAddress.transfer(compensation);
        } else {}

        pastMonarchs.push(currentMonarch);
        currentMonarch = Monarch({
            etherAddress: msg.sender,
            name: name,
            claimPrice: valuePaid,
            coronationTimestamp: block.timestamp
        });

        uint rawNewClaimPrice = (currentClaimPrice * claimPriceAdjustNum) /
            claimPriceAdjustDen;
        if (rawNewClaimPrice < 10 finney) {
            currentClaimPrice = rawNewClaimPrice;
        } else if (rawNewClaimPrice < 100 finney) {
            currentClaimPrice = 100 szabo * (rawNewClaimPrice / 100 szabo);
        } else if (rawNewClaimPrice < 1 ether) {
            currentClaimPrice = 1 finney * (rawNewClaimPrice / 1 finney);
        } else if (rawNewClaimPrice < 10 ether) {
            currentClaimPrice = 10 finney * (rawNewClaimPrice / 10 finney);
        } else if (rawNewClaimPrice < 100 ether) {
            currentClaimPrice = 100 finney * (rawNewClaimPrice / 100 finney);
        } else if (rawNewClaimPrice < 1000 ether) {
            currentClaimPrice = 1 ether * (rawNewClaimPrice / 1 ether);
        } else if (rawNewClaimPrice < 10000 ether) {
            currentClaimPrice = 10 ether * (rawNewClaimPrice / 10 ether);
        } else {
            currentClaimPrice = rawNewClaimPrice;
        }

        emit ThroneClaimed(
            currentMonarch.etherAddress,
            currentMonarch.name,
            currentClaimPrice
        );
    }

    function sweepCommission(uint amount) public onlywizard {
        wizardAddress.transfer(amount);
    }

    function transferOwnership(address newOwner) public onlywizard {
        wizardAddress = newOwner;
    }
}