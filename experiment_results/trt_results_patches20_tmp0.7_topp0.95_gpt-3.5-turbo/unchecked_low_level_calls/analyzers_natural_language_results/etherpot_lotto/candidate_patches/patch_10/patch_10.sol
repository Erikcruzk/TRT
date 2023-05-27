pragma solidity ^0.4.24;

contract Lotto {
    uint public constant blocksPerRound = 6800;
    uint public constant ticketPrice = 100000000000000000;
    uint public constant blockReward = 5000000000000000000;

    function getBlocksPerRound() public pure returns (uint) {
        return blocksPerRound;
    }

    function getTicketPrice() public pure returns (uint) {
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

    function getIsCashed(uint roundIndex, uint subpotIndex) public view returns (bool) {
        return rounds[roundIndex].isCashed[subpotIndex];
    }

    function calculateWinner(uint roundIndex, uint subpotIndex) public view returns (address) {
        uint decisionBlockNumber = getDecisionBlockNumber(roundIndex, subpotIndex);
        if (decisionBlockNumber > block.number) {
            return address(0);
        }
        bytes32 decisionBlockHash = blockhash(decisionBlockNumber);
        uint winningTicketIndex = uint(decisionBlockHash) % rounds[roundIndex].ticketsCount;
        uint ticketIndex = 0;
        for (uint i = 0; i < rounds[roundIndex].buyers.length; i++) {
            address buyer = rounds[roundIndex].buyers[i];
            ticketIndex += rounds[roundIndex].ticketsCountByBuyer[buyer];
            if (ticketIndex > winningTicketIndex) {
                return buyer;
            }
        }
        return address(0);
    }

    function getDecisionBlockNumber(uint roundIndex, uint subpotIndex) public view returns (uint) {
        return ((roundIndex + 1) * blocksPerRound) + subpotIndex;
    }

    function getSubpotsCount(uint roundIndex) public view returns (uint) {
        uint subpotsCount = rounds[roundIndex].pot / blockReward;
        if (rounds[roundIndex].pot % blockReward > 0) {
            subpotsCount++;
        }
        return subpotsCount;
    }

    function getSubpot(uint roundIndex) public view returns (uint) {
        return rounds[roundIndex].pot / getSubpotsCount(roundIndex);
    }

    function cash(uint roundIndex, uint subpotIndex) public {
        require(subpotIndex < getSubpotsCount(roundIndex), "Invalid subpot index");
        require(!rounds[roundIndex].isCashed[subpotIndex], "Subpot already cashed");
        address winner = calculateWinner(roundIndex, subpotIndex);
        require(winner != address(0), "No winner found");
        uint subpot = getSubpot(roundIndex);
        rounds[roundIndex].isCashed[subpotIndex] = true;
        winner.transfer(subpot);
    }

    function getBuyers(uint roundIndex) public view returns (address[]) {
        return rounds[roundIndex].buyers;
    }

    function getTicketsCountByBuyer(uint roundIndex, address buyer) public view returns (uint) {
        return rounds[roundIndex].ticketsCountByBuyer[buyer];
    }

    function getPot(uint roundIndex) public view returns (uint) {
        return rounds[roundIndex].pot;
    }

    function buyTickets() public payable {
        uint roundIndex = getRoundIndex();
        uint value = msg.value - (msg.value % ticketPrice);
        require(value > 0, "Invalid value");
        if (value < msg.value) {
            msg.sender.transfer(msg.value - value);
        }
        uint ticketsCount = value / ticketPrice;
        rounds[roundIndex].ticketsCount += ticketsCount;
        if (rounds[roundIndex].ticketsCountByBuyer[msg.sender] == 0) {
            rounds[roundIndex].buyers.push(msg.sender);
        }
        rounds[roundIndex].ticketsCountByBuyer[msg.sender] += ticketsCount;
        rounds[roundIndex].pot += value;
    }
}