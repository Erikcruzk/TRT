// File: ../sc_datasets/DAppSCAN/Coinfabrik-DreamTeam Token Audit/smart-contracts-master/contracts/storage/StorageInterface.sol

pragma solidity ^0.4.23;

interface StorageInterface {

    function transferOwnership (address newOwner) external; // Owners only: revoke access from the calling account and grant access to newOwner
    function grantAccess (address newOwner) external; // Owners only: just grant access to newOwner without revoking the access from the current owner
    function revokeAccess (address previousOwner) external; // Just revoke access from the current owner
    function isOwner (address addr) external view returns(bool);
    function getUint (bytes32 record) external view returns (uint);
    function getString (bytes32 record) external view returns (string);
    function getAddress (bytes32 record) external view returns (address);
    function getBytes (bytes32 record) external view returns (bytes);
    function getBoolean (bytes32 record) external view returns (bool);
    function getInt (bytes32 record) external view returns (int);
    function setString (bytes32 record, string value) external;
    function setUint (bytes32 record, uint value) external;
    function setAddress (bytes32 record, address value) external;
    function setBytes (bytes32 record, bytes value) external;
    function setBoolean (bytes32 record, bool value) external;
    function setInt (bytes32 record, int value) external;

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-DreamTeam Token Audit/smart-contracts-master/contracts/storage/TeamsStorageController.sol

pragma solidity ^0.4.18;

/**
 * There's no need to deploy this contract. It abstracts the storage logic and is meant for inheritance only.
 * This contract does not handle any logic nor constraints and works with bare storage only.
 */
contract TeamsStorageController {

    address public db;

    /**
     * Storage enumeration for keys readability. Never change an order of the items here when applying to a deployed storage!
     */
    enum Storage {
        teams,
        teamOwner,
        balance
    }

    enum Member {
        agreementMinutes,
        agreementValue,
        payoutDate
    }

    /**
     * A storage is represented as a key-value mapping. This comment describes the value retrieval from this mapping.
     *
     * getUint(Storage.teams) = 42 (number of teams)
     * getAddress(Storage.teamOwner, TEAM_ID) = 0x1520... (team owner address)
     * getUint(Storage.teams, TEAM_ID) = 5 (number of members in a team)
     * getUint(Storage.balance, TEAM_ID) = 100 (number of tokens on a balance of a team)
     * getAddress(Storage.teams, TEAM_ID, MEMBER_INDEX) = 0xF6A2... (team member address)
     * getUint(Storage.teams, TEAM_ID, MEMBER_INDEX, Member.agreementMinutes) = 20160 (number of minutes of agreement)
     * getUint(Storage.teams, TEAM_ID, MEMBER_INDEX, Member.agreementValue) = 50 (number of tokens stashed)
     * getUint(Storage.teams, TEAM_ID, MEMBER_INDEX, Member.payoutDate) = 1519987450 (date when user can receive payout, unix timestamp IN SECONDS)
     * getUint(Storage.teams, TEAM_ID, MEMBER_INDEX) = 10500 (member contract ID)
     * getBool(Storage.teams, TEAM_ID, MEMBER_INDEX) = false (whether to remove player on payout)
     */

    function getNumberOfTeams () public view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams));
    }

    function storageGetTeamMemberIndexByContractId (uint teamId, uint contractId) internal view returns(int) {
        int i = 0;
        uint cid;
        do {
            cid = StorageInterface(db).getUint(keccak256(Storage.teams, teamId, i));
            if (cid == contractId)
                return i;
            if (cid == 0)
                return -1;
            ++i;
        } while (true);
    }

    function storageGetTeamMemberAgreementValue (uint teamId, uint memberIndex) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams, teamId, memberIndex, Member.agreementValue));
    }

    function storageGetTeamMemberAgreementMinutes (uint teamId, uint memberIndex) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams, teamId, memberIndex, Member.agreementMinutes));
    }

    function storageGetTeamMemberPayoutDate (uint teamId, uint memberIndex) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams, teamId, memberIndex, Member.payoutDate));
    }

    function storageGetTeamMemberAddress (uint teamId, uint memberIndex) internal view returns(address) {
        return StorageInterface(db).getAddress(keccak256(Storage.teams, teamId, memberIndex));
    }

    function storageGetMemberContractId (uint teamId, uint memberIndex) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams, teamId, memberIndex));
    }

    function storageGetNumberOfMembers (uint teamId) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.teams, teamId));
    }

    function storageGetTeamMemberSingleTermAgreement (uint teamId, uint memberIndex) internal view returns(bool) {
        return StorageInterface(db).getBoolean(keccak256(Storage.teams, teamId, memberIndex));
    }

    function storageGetTeamBalance (uint teamId) internal view returns(uint) {
        return StorageInterface(db).getUint(keccak256(Storage.balance, teamId));
    }

    function storageSetTeamMemberPayoutDate (uint teamId, uint memberIndex, uint date) internal {
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId, memberIndex, Member.payoutDate), date);
    }

    // Gas refund applies here for clearing storage
    function storageDeleteTeamMember (uint teamId, uint memberIndex) internal {
        uint numOfMembers = StorageInterface(db).getUint(keccak256(Storage.teams, teamId)) - 1;
        require(memberIndex <= numOfMembers);
        StorageInterface(db).setAddress(
            keccak256(Storage.teams, teamId, memberIndex),
            StorageInterface(db).getAddress(keccak256(Storage.teams, teamId, numOfMembers))
        );
        StorageInterface(db).setAddress(keccak256(Storage.teams, teamId, numOfMembers), 0x0);
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, memberIndex, Member.agreementMinutes),
            StorageInterface(db).getUint(keccak256(Storage.teams, teamId, numOfMembers, Member.agreementMinutes))
        );
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId, numOfMembers, Member.agreementMinutes), 0);
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, memberIndex, Member.agreementValue),
            StorageInterface(db).getUint(keccak256(Storage.teams, teamId, numOfMembers, Member.agreementValue))
        );
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId, numOfMembers, Member.agreementValue), 0);
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, memberIndex, Member.payoutDate),
            StorageInterface(db).getUint(keccak256(Storage.teams, teamId, numOfMembers, Member.payoutDate))
        );
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId, numOfMembers, Member.payoutDate), 0);
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, memberIndex),
            StorageInterface(db).getUint(keccak256(Storage.teams, teamId, numOfMembers))
        );
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId, numOfMembers), 0);
        StorageInterface(db).setBoolean(
            keccak256(Storage.teams, teamId, memberIndex),
            StorageInterface(db).getBoolean(keccak256(Storage.teams, teamId, numOfMembers))
        );
        StorageInterface(db).setBoolean(keccak256(Storage.teams, teamId, numOfMembers), false);
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId), numOfMembers);
    }

    function storageAddTeam (address teamOwnerAccount) internal returns(uint) {
        uint teamId = StorageInterface(db).getUint(keccak256(Storage.teams));
        StorageInterface(db).setUint(keccak256(Storage.teams), teamId + 1);
        StorageInterface(db).setAddress(keccak256(Storage.teamOwner, teamId), teamOwnerAccount);
        return teamId;
    }

    function storageIncTeamBalance (uint teamId, uint toAdd) internal {
        StorageInterface(db).setUint(
            keccak256(Storage.balance, teamId),
            StorageInterface(db).getUint(keccak256(Storage.balance, teamId)) + toAdd
        );
    }

    function storageDecTeamBalance (uint teamId, uint toSub) internal {
        require(StorageInterface(db).getUint(keccak256(Storage.balance, teamId)) >= toSub);
        StorageInterface(db).setUint(
            keccak256(Storage.balance, teamId),
            StorageInterface(db).getUint(keccak256(Storage.balance, teamId)) - toSub
        );
    }

    function storageAddTeamMember (
        uint teamId,
        address memberAccount,
        uint agreementMinutes,
        uint agreementValue,
        bool singleTermAgreement,
        uint contractId // id of the contract with team member
    ) internal returns(uint)
    {
        // require(teamId < StorageInterface(db).getUint(keccak256(Storage.teams)));
        uint numOfMembers = StorageInterface(db).getUint(keccak256(Storage.teams, teamId));
        StorageInterface(db).setAddress(keccak256(Storage.teams, teamId, numOfMembers), memberAccount);
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, numOfMembers, Member.agreementMinutes), 
            agreementMinutes
        );
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, numOfMembers, Member.agreementValue), 
            agreementValue
        );
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, numOfMembers, Member.payoutDate), 
            now + (agreementMinutes * 60) // now + agreementSeconds
        );
        StorageInterface(db).setUint(
            keccak256(Storage.teams, teamId, numOfMembers),
            contractId
        );
        if (singleTermAgreement)
            StorageInterface(db).setBoolean(keccak256(Storage.teams, teamId, numOfMembers), true);
        StorageInterface(db).setUint(keccak256(Storage.teams, teamId), numOfMembers + 1);
    }

    function getTeam (uint teamId) public view returns(
        address[] memberAccounts,
        uint[] payoutDate,
        uint[] agreementMinutes,
        uint[] agreementValue,
        bool[] singleTermAgreement,
        uint teamBalance,
        address teamOwner,
        uint[] contractIds
    ) {
        uint numOfMembers = StorageInterface(db).getUint(keccak256(Storage.teams, teamId));
        memberAccounts = new address[](numOfMembers);
        payoutDate = new uint[](numOfMembers);
        agreementMinutes = new uint[](numOfMembers);
        agreementValue = new uint[](numOfMembers);
        singleTermAgreement = new bool[](numOfMembers);
        teamBalance = StorageInterface(db).getUint(keccak256(Storage.balance, teamId));
        teamOwner = StorageInterface(db).getAddress(keccak256(Storage.teamOwner, teamId));
        contractIds = new uint[](numOfMembers);
        for (
            uint memberIndex = 0; 
            memberIndex < numOfMembers; 
            ++memberIndex
        ) {
            memberAccounts[memberIndex] = StorageInterface(db).getAddress(
                keccak256(Storage.teams, teamId, memberIndex)
            );
            payoutDate[memberIndex] = StorageInterface(db).getUint(
                keccak256(Storage.teams, teamId, memberIndex, Member.payoutDate)
            );
            agreementMinutes[memberIndex] = StorageInterface(db).getUint(
                keccak256(Storage.teams, teamId, memberIndex, Member.agreementMinutes)
            );
            agreementValue[memberIndex] = StorageInterface(db).getUint(
                keccak256(Storage.teams, teamId, memberIndex, Member.agreementValue)
            );
            singleTermAgreement[memberIndex] = StorageInterface(db).getBoolean(
                keccak256(Storage.teams, teamId, memberIndex)
            );
            contractIds[memberIndex] = StorageInterface(db).getUint(
                keccak256(Storage.teams, teamId, memberIndex)
            );
        }
    }

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-DreamTeam Token Audit/smart-contracts-master/contracts/token/ERC20TokenInterface.sol

pragma solidity ^0.4.23;

contract ERC20TokenInterface {

    function totalSupply () external constant returns (uint);
    function balanceOf (address tokenOwner) external constant returns (uint balance);
    function transfer (address to, uint tokens) external returns (bool success);
    function transferFrom (address from, address to, uint tokens) external returns (bool success);

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-DreamTeam Token Audit/smart-contracts-master/contracts/teams/TeamContracts.sol

pragma solidity ^0.4.23;



contract TeamContracts is TeamsStorageController {

    event TeamCreated(uint indexed teamId);
    event TeamMemberAdded(uint indexed contractId);
    event TeamBalanceRefilled(uint indexed teamId, address payer, uint amount);
    event TeamMemberRemoved(uint indexed contractId, uint amountPaidToMember, uint amountReturnedToTeam);
    event Payout(uint indexed contractId, uint amount, address triggeredBy);
    event ContractCompleted(uint indexed contractId, bool extended); // Boolean extended: whether the contract was extended to a new period
    event ContractProlongationFailed(uint indexed contractId);
    event Upgraded(address newContract);

    address public erc20TokenAddress; // Address of authorized token
    address public dreamTeamAddress; // Authorized account for managing teams

    modifier dreamTeamOnly {require(msg.sender == dreamTeamAddress); _;} // allows only dreamTeamAddress to trigger fun

    /**
     * Constructor. This is yet the only way to set owner address, token address and storage address.
     */
    constructor (address dt, address token, address dbAddress) public {
        dreamTeamAddress = dt;
        erc20TokenAddress = token;
        db = dbAddress;
    }

    function createTeam (address teamOwnerAccount) dreamTeamOnly public returns(uint) {
        uint teamId = storageAddTeam(teamOwnerAccount);
        emit TeamCreated(teamId);
        return teamId;
    }

    /**
     * Adds a new member to a team. Member adding is only possible when team balance covers their first payout period.
     * @param teamId - Team ID to add member to.
     * @param memberAccount - Member address (where token balance live in token contract)
     * @param agreementMinutes - Number of minutes to 
     */
    function addMember (uint teamId, address memberAccount, uint agreementMinutes, uint agreementValue, bool singleTermAgreement, uint contractId) dreamTeamOnly public {
        storageDecTeamBalance(teamId, agreementValue); // throws if balance goes negative
        storageAddTeamMember(teamId, memberAccount, agreementMinutes, agreementValue, singleTermAgreement, contractId);
        emit TeamMemberAdded(contractId);
    }

    function removeMember (uint teamId, uint contractId) dreamTeamOnly public {

        int memberIndex = storageGetTeamMemberIndexByContractId(teamId, contractId);
        require(memberIndex != -1);

        uint payoutDate = storageGetTeamMemberPayoutDate(teamId, uint(memberIndex));

        if (payoutDate <= now) { // return full amount to the player
            ERC20TokenInterface(erc20TokenAddress).transfer(storageGetTeamMemberAddress(teamId, uint(memberIndex)), agreementValue);
            emit TeamMemberRemoved(contractId, agreementValue, 0);
        } else { // if (payoutDate > now): return a part of the amount based on the number of days spent in the team, in proportion
            uint agreementMinutes = storageGetTeamMemberAgreementMinutes(teamId, uint(memberIndex));
            uint agreementValue = storageGetTeamMemberAgreementValue(teamId, uint(memberIndex));
            // amountToPayout = numberOfFullDaysSpentInTheTeam * dailyRate; dailyRate = totalValue / numberOfDaysInAgreement
            uint amountToPayout = ((agreementMinutes * 60 - (payoutDate - now)) / 1 days) * (60 * 24 * agreementValue / agreementMinutes);
            if (amountToPayout > 0)
                ERC20TokenInterface(erc20TokenAddress).transfer(storageGetTeamMemberAddress(teamId, uint(memberIndex)), amountToPayout);
            if (amountToPayout < agreementValue)
                storageIncTeamBalance(teamId, agreementValue - amountToPayout); // unlock the rest of the funds
            emit TeamMemberRemoved(contractId, amountToPayout, agreementValue - amountToPayout);
        }

        // Actually delete team member from a storage
        storageDeleteTeamMember(teamId, uint(memberIndex));

    }

    function payout (uint teamId) public {

        uint value;
        uint contractId;

        // Iterate over all team members and payout to those who need to be paid.
        // This is intended to restrict DreamTeam or anyone else from triggering payout (and thus the contract extension) for 
        // a particular team member only, avoiding paying out other team members. Also since sorting payouts by dates are
        // expensive, we managed that giving a priority of contract extension to the leftmost team members (i = 0, 1, 2, ...)
        // over other members (including those whose contract extension must have happened before the leftmost members) is okay,
        // as we are going to trigger the payout daily and such case is more an exceptional one rather than the dangerous.
        // Even if team owner/member knows how to cheat over payout, the only thing they can do is to fail contract extension
        // for a particular team member (N rightmost team members) due to the lack of funds on the team balance.
        for (uint index = 0; index < storageGetNumberOfMembers(teamId); ++index) {
            if (storageGetTeamMemberPayoutDate(teamId, index) > now)
                continue;
            value = storageGetTeamMemberAgreementValue(teamId, index);
            contractId = storageGetMemberContractId(teamId, index);
            ERC20TokenInterface(erc20TokenAddress).transfer(storageGetTeamMemberAddress(teamId, index), value);
            emit Payout(contractId, value, msg.sender);
            if (storageGetTeamMemberSingleTermAgreement(teamId, index)) { // Terminate the contract due to a single-term agreement
                storageDeleteTeamMember(teamId, index);
                emit ContractCompleted(contractId, false);
            } else { // Extend the contract
                if (storageGetTeamBalance(teamId) < value) { // No funds in the team: auto extend is not possible, remove the team member
                    storageDeleteTeamMember(teamId, index);
                    emit ContractCompleted(contractId, false);
                    emit ContractProlongationFailed(contractId);
                } else {
                    storageDecTeamBalance(teamId, value);
                    storageSetTeamMemberPayoutDate(
                        teamId,
                        index,
                        storageGetTeamMemberPayoutDate(teamId, index) + storageGetTeamMemberAgreementMinutes(teamId, index) * 60
                    );
                    emit ContractCompleted(contractId, true);
                }
            }
        }

    }

    function batchPayout (uint[] teamIds) public {
        for (uint i = 0; i < teamIds.length; ++i) {
            payout(teamIds[i]);
        }
    }

    /**
     * Refill team balance for a given amount.
     */
    function transferToTeam (uint teamId, uint amount) public {
        // require(teamId < getNumberOfTeams()); // Does not open vulnerabilities but charities :)
        // require(amount > 0); // already tested in ERC20 token + has no sense
        require( // before calling transferToTeam, set allowance msg.sender->contractAddress in ERC20 token. 
            ERC20TokenInterface(erc20TokenAddress).transferFrom(msg.sender, address(this), amount)
        );
        storageIncTeamBalance(teamId, amount);
        emit TeamBalanceRefilled(teamId, msg.sender, amount);
    }

    /**
     * Destroys the current contract and moves permissions and funds to a new contract.
     * @param newDeployedTeamContracts - Deployed teams contract.
     */
    function upgrade (address newDeployedTeamContracts) dreamTeamOnly public {
        require(TeamContracts(newDeployedTeamContracts).db() == db); // Switch between contracts linked to the same storage
        // Do not enforce the same token contract for new TeamContracts; this took place when a token is upgraded (changed)
        // In case of the new token contract, a special care should be taken into account to preserve the same balance in
        // tokens in the newly deployed token contract.
        // - require(TeamContracts(newDeployedTeamContracts).erc20TokenAddress() == erc20TokenAddress);
        StorageInterface(db).transferOwnership(newDeployedTeamContracts); // Revoke access from the current contract and grant access to a new one
        ERC20TokenInterface(erc20TokenAddress).transfer( // Move all funds to a new contract
            newDeployedTeamContracts, ERC20TokenInterface(erc20TokenAddress).balanceOf(this)
        );
        emit Upgraded(newDeployedTeamContracts);
        selfdestruct(newDeployedTeamContracts);
    }

}