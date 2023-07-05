// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/modules/Checkpoint/Voting/APLCR/AdvancedPLCRVotingCheckpointStorage.sol

pragma solidity ^0.5.8;

contract AdvancedPLCRVotingCheckpointStorage {

    enum Stage { PREP, COMMIT, REVEAL, RESOLVED }

    uint256 internal constant DEFAULTCHOICE = uint256(3);
    uint256 internal constant MAXLIMIT = uint256(500);

    struct Ballot {
        uint256 checkpointId; // Checkpoint At which ballot created
        uint64 commitDuration; // no. of seconds the commit stage will live
        uint64 revealDuration; // no. of seconds the reveal stage will live
        uint64 startTime;       // Timestamp at which ballot will come into effect
        uint24 totalProposals;  // Count of proposals allowed for a given ballot
        uint32 totalVoters;     // Count of voters who vote for the given ballot
        bool isCancelled;       // flag used to cancel the ballot
        bytes32 name;           // Name of the ballot
        mapping(uint256 => Proposal) proposals;
        mapping(address => Vote) voteDetails; // mapping for storing vote details of a voter
        mapping(address => bool) exemptedVoters; // Mapping for blacklist voters
    }

    struct Proposal {
        bytes32 details;
        uint256 noOfChoices;
    }

    struct Vote {
        bytes32 secretVote;
        mapping (uint256 => uint256[]) voteOptions;
    }

    Ballot[] ballots;
    
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/libraries/AdvancedPLCRVotingLib.sol

pragma solidity ^0.5.8;


library AdvancedPLCRVotingLib {

    using SafeMath for uint256;

    uint256 internal constant DEFAULTCHOICE = uint256(3);

    /**
     * @notice Queries the result of a given ballot
     * @dev should be called off-chain
     * @param allowedVoters list of voters those are allowed to vote
     * @param ballot Details of the given ballot id
     * @return uint256 choicesWeighting
     * @return uint256 noOfChoicesInProposal
     * @return address voters
     */
    function getBallotResults(address[] memory allowedVoters, AdvancedPLCRVotingCheckpointStorage.Ballot storage ballot) public view returns(
        uint256[] memory choicesWeighting,
        uint256[] memory noOfChoicesInProposal,
        address[] memory voters
    )
    {
        voters = new address[](ballot.totalVoters);
        (uint256 i, uint256 j, uint256 k, uint256 count) = (0, 0, 0, 0);
        // Filtering the actual voters address from the allowed voters address list
        for (i = 0; i < allowedVoters.length; i++) {
            if (ballot.voteDetails[allowedVoters[i]].voteOptions[0].length > 0) {
                voters[count] = allowedVoters[i];
                count++;
            } 
        }
        count = 0;
        // calculating the length of the choicesWeighting array it should be equal
        // to the aggregation of ∑(proposalᵢ * noOfChoicesᵢ) where i = 0 ...totalProposal-1 
        for (i = 0; i < ballot.totalProposals; i++) {
            uint256 _noOfChoice = _getNoOfChoice(ballot.proposals[i].noOfChoices);
            count = count.add(_noOfChoice);
        }
        choicesWeighting = new uint256[](count);
        noOfChoicesInProposal = new uint256[](ballot.totalProposals);
        count = 0;
        for (i = 0; i < ballot.totalProposals; i++) {
            uint256 _noOfChoices = _getNoOfChoice(ballot.proposals[i].noOfChoices);
            noOfChoicesInProposal[i] = _noOfChoices;
            uint256 nextProposalChoiceLen = count + _noOfChoices;
            for (j = 0; j < ballot.totalVoters; j++) {
                uint256[] storage choiceWeight = ballot.voteDetails[voters[j]].voteOptions[i];
                uint256 m = 0;
                for (k = count; k < nextProposalChoiceLen; k++) {
                    choicesWeighting[k] = choicesWeighting[k].add(choiceWeight[m]);
                    m++;
                }
            }
            count = nextProposalChoiceLen;
        }
    }

    /**
     * @notice Return the list of the exempted voters list for a given ballotId
     * @param investorAtCheckpoint Non zero investor at a given checkpoint.
     * @param defaultExemptedVoters List of addresses which are globally exempted.
     * @param ballot Details of the ballot
     * @return exemptedVoters List of the exempted voters.
     */
    function getExemptedVotersByBallot(
        address[] memory investorAtCheckpoint,
        address[] memory defaultExemptedVoters,
        AdvancedPLCRVotingCheckpointStorage.Ballot storage ballot
    ) 
        public
        view
        returns(address[] memory exemptedVoters)
    {
        uint256 count = 0;
        uint256 i;
        uint256 length = investorAtCheckpoint.length;
        for (i = 0; i < length; i++) {
            if (ballot.exemptedVoters[investorAtCheckpoint[i]])
                count++;
        }
        exemptedVoters = new address[](count.add(defaultExemptedVoters.length));
        count = 0;
        for (i = 0; i < length; i++) {
            if (ballot.exemptedVoters[investorAtCheckpoint[i]]) {
                exemptedVoters[count] = investorAtCheckpoint[i];
                count++;
            }
        }
        for (i = 0; i < defaultExemptedVoters.length; i++) {
            exemptedVoters[count] = defaultExemptedVoters[i];
            count++;
        }
    }


    /**
     * @notice Retrives the list of investors who are remain to vote
     * @param allowedVoters list of voters those are allowed to vote
     * @param ballot Details of the given ballot id
     * @return address[] list of invesotrs who are remain to vote
     */
    function getPendingInvestorToVote(
        address[] memory allowedVoters,
        AdvancedPLCRVotingCheckpointStorage.Ballot storage ballot
    ) 
        public
        view
        returns(address[] memory pendingInvestors)
    {
        uint256 count = 0;
        uint256 i;
        for (i = 0; i < allowedVoters.length ; i++) {
            if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.COMMIT) {
                if (ballot.voteDetails[allowedVoters[i]].secretVote == bytes3(0)) {
                    count++;
                }
            }
            else if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.REVEAL) {
                if (ballot.voteDetails[allowedVoters[i]].voteOptions[0].length == 0) {
                    count++;
                }
            }
        }
        pendingInvestors = new address[](count);
        count = 0;
        for (i = 0; i < allowedVoters.length ; i++) {
            if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.COMMIT) {
                if (ballot.voteDetails[allowedVoters[i]].secretVote == bytes3(0)) {
                    pendingInvestors[count] = allowedVoters[i];
                    count++;
                }
            }
            else if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.REVEAL) {
                if (ballot.voteDetails[allowedVoters[i]].voteOptions[0].length == 0) {
                    pendingInvestors[count] = allowedVoters[i];
                    count++;
                }
            }
        }
    }

    /**
     * @notice It will return the no. of the voters who take part in the commit phase of the voting
     * @param allowedVoters list of voters those are allowed to vote
     * @param ballot Details of the given ballot id
     * @return committedVoteCount no. of the voters who take part in the commit phase of the voting    
     */
    function getCommittedVoteCount(
        address[] memory allowedVoters,
        AdvancedPLCRVotingCheckpointStorage.Ballot storage ballot
    ) 
        public
        view
        returns (uint256 committedVoteCount)
    {
        uint256 i;
        if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.COMMIT) {
            for (i = 0; i < allowedVoters.length; i++) {
                if (ballot.voteDetails[allowedVoters[i]].secretVote != bytes32(0))
                    committedVoteCount++;
            }
        } else if (getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.REVEAL
                || getCurrentBallotStage(ballot) == AdvancedPLCRVotingCheckpointStorage.Stage.RESOLVED) {
            for (i = 0; i < allowedVoters.length; i++) {
                if (ballot.voteDetails[allowedVoters[i]].secretVote != bytes32(0)
                    || ballot.voteDetails[allowedVoters[i]].voteOptions[0].length != uint256(0))
                    committedVoteCount++;
            }
        }
    }

    /**
     * @notice Used to get the current stage of the ballot
     * @param ballot Details of the given ballot id
     */
    function getCurrentBallotStage(AdvancedPLCRVotingCheckpointStorage.Ballot storage ballot) public view returns (AdvancedPLCRVotingCheckpointStorage.Stage) {
        uint256 commitTimeEnd = uint256(ballot.startTime).add(uint256(ballot.commitDuration));
        uint256 revealTimeEnd = commitTimeEnd.add(uint256(ballot.revealDuration));

        if (now < ballot.startTime)
            return AdvancedPLCRVotingCheckpointStorage.Stage.PREP;
        else if (now >= ballot.startTime && now <= commitTimeEnd) 
            return AdvancedPLCRVotingCheckpointStorage.Stage.COMMIT;
        else if ( now > commitTimeEnd && now <= revealTimeEnd)
            return AdvancedPLCRVotingCheckpointStorage.Stage.REVEAL;
        else if (now > revealTimeEnd)
            return AdvancedPLCRVotingCheckpointStorage.Stage.RESOLVED;
    }


    function _getNoOfChoice(uint256 _noOfChoice) internal pure returns(uint256 noOfChoice) {
        noOfChoice = _noOfChoice == 0 ? DEFAULTCHOICE : _noOfChoice;
    }
    
}
