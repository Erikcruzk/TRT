pragma solidity ^0.4.24;

contract Lotto {
    uint public constant blocksPerRound = 6800;

    uint public constant ticketPrice = 100000000000000000;

    uint public constant blockReward = 5000000000000000000;

    function getBlocksPerRound() public view returns (uint) {
        return blocksPerRound;
    }

    function getTicketPrice() public view returns (uint) {
        return ticketPrice;
    }

    struct Round {
        address[] buyers;
        uint pot;
        uint ticketsCount;
        mapping(uint => bool) isCashed;
        mapping(address => uint) ticketsCountByBuyer;
    }
    mapping(uint => Round) rounds;

    function getRoundIndex() public view returns (uint) {
        return block.number / blocksPerRound;
    }

    function getIsCashed(
        uint roundIndex,
        uint subpotIndex
    ) public view returns (bool) {
        return rounds[roundIndex].isCashed[subpotIndex];
    }

    function calculateWinner(
        uint roundIndex,
        uint subpotIndex
    ) public view returns (address) {
        uint decisionBlockNumber = getDecisionBlockNumber(
            roundIndex,
            subpotIndex
        );

        if (decisionBlockNumber > block.number) revert();

        bytes32 decisionBlockHash = getHashOfBlock(decisionBlockNumber);
        uint winningTicketIndex = uint(decisionBlockHash) %
            rounds[roundIndex].ticketsCount;

        uint ticketIndex = 0;

        for (
            uint buyerIndex = 0;
            buyerIndex < rounds[roundIndex].buyers.length;
            buyerIndex++
        ) {
            address buyer = rounds[roundIndex].buyers[buyerIndex];
            ticketIndex += rounds[roundIndex].ticketsCountByBuyer[buyer];

            if (ticketIndex > winningTicketIndex) {
                return buyer;
            }
        }
    }

    function getDecisionBlockNumber(
        uint roundIndex,
        uint subpotIndex
    ) public view returns (uint) {
        return ((roundIndex + 1) * blocksPerRound) + subpotIndex;
    }

    function getSubpotsCount(uint roundIndex) public view returns (uint) {
        uint subpotsCount = rounds[roundIndex].pot / blockReward;

        if (rounds[roundIndex].pot % blockReward > 0) subpotsCount++;

        return subpotsCount;
    }

    function getSubpot(uint roundIndex) public view returns (uint) {
        return rounds[roundIndex].pot / getSubpotsCount(roundIndex);
    }

    function cash(uint roundIndex, uint subpotIndex) public {
        uint subpotsCount = getSubpotsCount(roundIndex);

        if (subpotIndex >= subpotsCount) revert();

        uint decisionBlockNumber = getDecisionBlockNumber(
            roundIndex,
            subpotIndex
        );

        if (decisionBlockNumber > block.number) revert();

        if (rounds[roundIndex].isCashed[subpotIndex]) revert();

        address winner = calculateWinner(roundIndex, subpotIndex);
        uint subpot = getSubpot(roundIndex);

        winner.transfer(subpot);

        rounds[roundIndex].isCashed[subpotIndex] = true;
    }

    function getHashOfBlock(uint blockIndex) public view returns (bytes32) {
        return blockhash(blockIndex);
    }

    function getBuyers(
        uint roundIndex,
        address buyer
    ) public view returns (address[]) {
        return rounds[roundIndex].buyers;
    }

    function getTicketsCountByBuyer(
        uint roundIndex,
        address buyer
    ) public view returns (uint) {
        return rounds[roundIndex].ticketsCountByBuyer[buyer];
    }

    function getPot(uint roundIndex) public view returns (uint) {
        return rounds[roundIndex].pot;
    }

    function() public payable {
        uint roundIndex = getRoundIndex();
        uint value = msg.value - (msg.value % ticketPrice);

        if (value == 0) revert();

        if (value < msg.value) {
            msg.sender.transfer(msg.value - value);
        }

        uint ticketsCount = value / ticketPrice;
        rounds[roundIndex].ticketsCount += ticketsCount;

        if (rounds[roundIndex].ticketsCountByBuyer[msg.sender] == 0) {
            rounds[roundIndex].buyers.push(msg.sender);
        }

        rounds[roundIndex].ticketsCountByBuyer[msg.sender] += ticketsCount;
        rounds[roundIndex].ticketsCount += ticketsCount;

        rounds[roundIndex].pot += value;
    }
}