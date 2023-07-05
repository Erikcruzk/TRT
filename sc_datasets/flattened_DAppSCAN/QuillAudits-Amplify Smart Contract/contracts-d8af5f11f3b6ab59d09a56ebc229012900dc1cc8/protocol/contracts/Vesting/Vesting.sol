// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Base {
    function balanceOf(address owner) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
}

interface IERC20 is IERC20Base {
    function totalSupply() external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);

    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IERC20Burnable is IERC20 {
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/Counters.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/NonZeroAddressGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract NonZeroAddressGuard {

    modifier nonZeroAddress(address _address) {
        require(_address != address(0), "Address must be non-zero");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/security/Ownable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Ownable {

    /// @notice owner address set on construction
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Transfers ownership role
     * @notice Changes the owner of this contract to a new address
     * @dev Only owner
     * @param _newOwner beneficiary to vest remaining tokens to
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Address must be non-zero");
        
        address currentOwner = owner;
        require(_newOwner != currentOwner, "New owner cannot be the current owner");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Vesting/Vesting.sol

// SPDX-License-Identifier: MIT
/// @dev size: 6.986 Kbytes
pragma solidity 0.8.4;





/// @title An instance to run vesting schedule for an organization
/// @notice Use this contract to create vesting schedule entires for team members
contract Vesting is ReentrancyGuard, Ownable, NonZeroAddressGuard {
    using Counters for Counters.Counter;

    /// @dev Counter for the number of entries in the vesting schedule.
    Counters.Counter private _entryIds;

    /// @notice ERC20 token we are vesting
    IERC20 public token;

    struct Entry {
        uint256 amount;
        uint256 start;
        uint256 end;
        uint256 cliff;
        uint256 lastUpdated;
        uint256 claimed;
        address recipient;
        bool isFireable;
        bool isFired;
    }

    /// @notice Mapping of vesting entries
    mapping(uint256 => Entry) public entries;

    /// @notice Mapping of addresses to lists of their entries IDs
    mapping(address => uint256[]) public entryIdsByRecipient;

    /// @dev Flag to prevent reinitialization
    bool private _initialized;

    event EntryCreated(uint256 indexed entryId, address recipient, uint256 amount, uint256 start, uint256 end, uint256 cliff);
    event EntryFired(uint256 indexed entryId);
    event Claimed(address indexed recipient, uint256 amount);

    /**
     * @notice Init a new vesting contract
     * @param owner_ owner of the contract
     * @param token_ address of the ERC20 token
     */
    function initialize(address owner_, IERC20 token_) external nonZeroAddress(owner_) nonZeroAddress(address(token_)) {
        require(!_initialized, "Already initialized");
        owner = owner_;
        token = token_;

        _initialized = true;
    }

    struct EntryVars {
        address recipient;
        uint256 amount;
        uint256 start;
        uint256 end;
        uint256 cliff;
        uint256 unlocked;
        bool isFireable;
    }

    /**
     * @notice Create new vesting entry
     * @notice A transfer made by AMPT Token holder is prior to bring tokens into the Vesting contract
     * @param entry beneficiary of the vested tokens
     * @return boolean indicating success
    */
    function createEntry(EntryVars calldata entry) external onlyOwner nonReentrant returns (bool){
        return _createEntry(entry);
    }

    /**
     * @notice Fire vesting entry
     * @param entryId ID of the fired entry
     * @return boolean indicating success
    */
    function fireEntry(uint256 entryId) external onlyOwner returns (bool){
        return _fireEntry(entryId);
    }

    /**
     * @notice Create new vesting entries in a batch
     * @notice A transfer made by AMPT Token holder is prior to bring tokens into the Vesting contract
     * @param _entries array of beneficiaries of the vested tokens
    */
    function createEntries(EntryVars[] calldata _entries) external onlyOwner nonReentrant returns (bool){
        require(_entries.length  > 0, "empty data");
        require(_entries.length  <= 80, "exceed max length");

        for(uint8 i=0; i < _entries.length; i++) {
            _createEntry(_entries[i]);
        }
        return true;
    }

    /**
     * @notice Claim any vested tokens due
     * @dev Must be called directly by the beneficiary assigned the tokens in the entry
    */
    function claim() external nonReentrant  {
        uint256 totalAmount;
        for(uint8 i=0; i < entryIdsByRecipient[msg.sender].length; i++) {
            totalAmount += _claim(entryIdsByRecipient[msg.sender][i]);
        }
        if (totalAmount > 0) {
            emit Claimed(msg.sender, totalAmount);
            assert(token.transfer(msg.sender, totalAmount));
        }
    }

    /**
     * @notice Withdraw unused tokens
     * @dev Must be called directly by the beneficiary assigned the tokens in the entry
    */
    function withdraw(address destination) external onlyOwner nonZeroAddress(destination) returns (bool) {
        require(token.transfer(destination, this.balanceOf()), "transfer failed");
        return true;
    }

    /**
     * @notice Vested token balance for a beneficiary
     * @dev Must be called directly by the beneficiary assigned the tokens in the entry
     * @return _tokenBalance total balance proxied via the ERC20 token
    */
    function balanceOf() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    /**
     * @notice Currently available amount (based on the block timestamp)
     * @param entryId ID of the entry
     * @return amount tokens due from vesting entry
     */
    function balanceOf(uint256 entryId) external view returns (uint256 amount) {
        return _balanceOf(entryId);
    }

    /**
     * @notice Currently available amount (based on the block timestamp)
     * @param account beneficiary of the vested tokens
     * @return amount tokens due from vesting entry
     */
    function balanceOf(address account) external view returns (uint256 amount) {
        for(uint8 i=0; i < entryIdsByRecipient[account].length; i++) {
            amount += _balanceOf(entryIdsByRecipient[account][i]);
        }
        return amount;
    }



    struct Snapshot {
        uint256 entryId;
        uint256 amount;
        uint256 start;
        uint256 end;
        uint256 cliff;
        uint256 claimed;
        uint256 available;
        bool isFired;
    }

    /**
     * @notice Snapshot of the current state
     * @param account beneficiary of the vested tokens
     * @return snapshot of the current state
    */
    function getSnapshot(address account) external nonZeroAddress(account) view returns(Snapshot[] memory) {
        Snapshot[] memory snapshot = new Snapshot[](entryIdsByRecipient[account].length);

// SWC-DoS With Block Gas Limit: L181 - L193
        for(uint8 i=0; i < entryIdsByRecipient[account].length; i++) {
            Entry memory entry = entries[entryIdsByRecipient[account][i]];
            snapshot[i] = Snapshot({
                entryId: entryIdsByRecipient[account][i],
                amount: entry.amount,
                start: entry.start,
                end: entry.end,
                cliff: entry.cliff,
                claimed: entry.claimed,
                available: _balanceOf(entryIdsByRecipient[account][i]),
                isFired: entry.isFired
            });
        }
        return snapshot;
    }

    /**
     * @notice Balance remaining in vesting entry
     * @param entryId ID of the entry
     * @return amount tokens still due (and currently locked) from vesting entry
    */
    function lockedOf(uint256 entryId) external view returns (uint256 amount) {
        return _lockedOf(entryId);
    }

    /**
     * @notice Balance remaining in vesting entry
     * @param account beneficiary of the vested tokens
     * @return amount tokens still due (and currently locked) from vesting entry
    */
    function lockedOf(address account) external view returns (uint256 amount) {
        for(uint8 i=0; i < entryIdsByRecipient[account].length; i++) {
            amount += _lockedOf(entryIdsByRecipient[account][i]);
        }
        return amount;
    }

    function getBlockTimestamp() public virtual view returns (uint256) {
        return block.timestamp;
    }

    function _balanceOf(uint256 _entryId) internal view returns (uint256) {
        Entry storage entry = entries[_entryId];

        if (entry.amount == 0) { // entry not found
            return 0;
        }

        uint256 currentTimestamp = getBlockTimestamp();
        if (currentTimestamp <= entry.start + entry.cliff) {
            return 0;
        }

        if (currentTimestamp > entry.end || entry.isFired) {
            return entry.amount - entry.claimed;
        }

        uint256 vested = entry.amount * (currentTimestamp - entry.lastUpdated) / (entry.end - entry.start);
        return vested;
    }

    function _lockedOf(uint256 _entryId) internal view returns (uint256) {
        Entry storage entry = entries[_entryId];
        if (entry.amount == 0) { // entry not found
            return 0;
        }
        return entry.amount - entry.claimed;
    }

    function _createEntry(EntryVars memory entry) internal returns (bool success) {
        address recipient = entry.recipient;
        require(recipient != address(0), "recipient cannot be the zero address");


        require(entry.amount > 0, "amount must be greater than zero");
        require(entry.unlocked <= entry.amount, "unlocked cannot be greater than amount");
        require(entry.end >= entry.start, "End time must be after start time");
        require(entry.end > entry.start + entry.cliff, "cliff must be less than end");
        
        uint256 currentTimestamp = getBlockTimestamp();
        require(entry.start >= currentTimestamp, "Start time must be in the future");

        if (entry.unlocked > 0) {
            assert(token.transfer(recipient, entry.unlocked));
        }

        uint256 currentEntryId = _entryIds.current();
        if (entry.unlocked < entry.amount) {
            entries[currentEntryId] = Entry({
                recipient: recipient,
                amount: entry.amount - entry.unlocked,
                start: entry.start,
                lastUpdated: entry.start,
                end: entry.end,
                cliff: entry.cliff,
                claimed: 0,
                isFireable: entry.isFireable,
                isFired: false
            });
            entryIdsByRecipient[recipient].push(currentEntryId);

            emit EntryCreated(currentEntryId, recipient, entry.amount - entry.unlocked, entry.start, entry.end, entry.cliff);
            _entryIds.increment();
        }

        return true;
    }

    function _fireEntry(uint256 _entryId) internal returns (bool success) {
        Entry storage entry = entries[_entryId];
        require(entry.amount > 0, "entry not exists");
        require(entry.isFireable, "entry not fireable");

        entry.amount = _balanceOf(_entryId);
        entry.isFired = true;

        emit EntryFired(_entryId);
        return true;
    }

    function _claim(uint256 _entryId) internal returns (uint256 amount) {
        Entry storage entry = entries[_entryId];

        uint256 amountToClaim = _balanceOf(_entryId);
        if (amountToClaim > 0) {
            uint256 currentTimestamp = getBlockTimestamp();

            entry.lastUpdated = currentTimestamp;
            entry.claimed += amountToClaim;

            // Safety measure - this should never trigger
            require(entry.amount >= entry.claimed, "claim exceed vested amount");
        }

        return amountToClaim;
    }
}
