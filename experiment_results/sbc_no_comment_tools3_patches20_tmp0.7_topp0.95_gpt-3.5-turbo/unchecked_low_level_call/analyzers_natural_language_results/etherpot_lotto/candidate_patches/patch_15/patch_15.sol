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
        uint256 pot;
        uint256 ticketsCount;
        mapping(uint256 => bool) isCashed;
        mapping(address => uint256) ticketsCountByBuyer;
    }
    mapping(uint256 => Round) rounds;

    function getRoundIndex() public view returns (uint256) {
        return block.number / blocksPerRound;
    }

    function getIsCashed(
        uint256 roundIndex,
        uint256 subpotIndex
    ) public view returns (bool) {
        return rounds[roundIndex].isCashed[subpotIndex];
    }

    function calculateWinner(
        uint256 roundIndex,
        uint256 subpotIndex
    ) public view returns (address) {
        uint256 decisionBlockNumber = getDecisionBlockNumber(
            roundIndex,
            subpotIndex
        );

        if (decisionBlockNumber > block.number) revert();

        bytes32 decisionBlockHash = blockhash(decisionBlockNumber);
        uint256 winningTicketIndex = uint256(decisionBlockHash) %
            rounds[roundIndex].ticketsCount;

        uint256 ticketIndex = 0;

        for (
            uint256 buyerIndex = 0;
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
        uint256 roundIndex,
        uint256 subpotIndex
    ) public view returns (uint256) {
        return ((roundIndex + 1) * blocksPerRound) + subpotIndex;
    }

    function getSubpotsCount(uint256 roundIndex) public view returns (uint256) {
        uint256 subpotsCount = rounds[roundIndex].pot / blockReward;

        if (rounds[roundIndex].pot % blockReward > 0) subpotsCount++;

        return subpotsCount;
    }

    function getSubpot(uint256 roundIndex) public view returns (uint256) {
        return rounds[roundIndex].pot / getSubpotsCount(roundIndex);
    }

    function cash(uint256 roundIndex, uint256 subpotIndex) public {
        uint256 subpotsCount = getSubpotsCount(roundIndex);

        if (subpotIndex >= subpotsCount) revert();

        uint256 decisionBlockNumber = getDecisionBlockNumber(
            roundIndex,
            subpotIndex
        );

        if (decisionBlockNumber > block.number) revert();

        if (rounds[roundIndex].isCashed[subpotIndex]) revert();

        address winner = calculateWinner(roundIndex, subpotIndex);
        uint256 subpot = getSubpot(roundIndex);

        winner.transfer(subpot);

        rounds[roundIndex].isCashed[subpotIndex] = true;
    }

    function getBuyers(
        uint256 roundIndex,
        address buyer
    ) public view returns (address[]) {
        return rounds[roundIndex].buyers;
    }

    function getTicketsCountByBuyer(
        uint256 roundIndex,
        address buyer
    ) public view returns (uint256) {
        return rounds[roundIndex].ticketsCountByBuyer[buyer];
    }

    function getPot(uint256 roundIndex) public view returns (uint256) {
        return rounds[roundIndex].pot;
    }

    function() public payable {
        uint256 roundIndex = getRoundIndex();
        uint256 value = msg.value - (msg.value % ticketPrice);

        if (value == 0) revert();

        if (value < msg.value) {
            msg.sender.transfer(msg.value - value);
        }

        uint256 ticketsCount = value / ticketPrice;
        rounds[roundIndex].ticketsCount += ticketsCount;

        if (rounds[roundIndex].ticketsCountByBuyer[msg.sender] == 0) {
            rounds[roundIndex].buyers.push(msg.sender);
        }

        rounds[roundIndex].ticketsCountByBuyer[msg.sender] += ticketsCount;
        rounds[roundIndex].ticketsCount += ticketsCount;

        rounds[roundIndex].pot += value;
    }
}