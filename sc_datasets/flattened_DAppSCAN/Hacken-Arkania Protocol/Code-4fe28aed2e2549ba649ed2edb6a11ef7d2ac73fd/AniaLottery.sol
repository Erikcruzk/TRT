// File: ../sc_datasets/DAppSCAN/Hacken-Arkania Protocol/Code-4fe28aed2e2549ba649ed2edb6a11ef7d2ac73fd/Ania.sol

// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts@4.4.1/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

// SWC-Outdated Compiler Version: L8
// SWC-Floating Pragma: L8
pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts@4.4.1/token/ERC20/IERC20.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts@4.4.1/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts@4.4.1/token/ERC20/ERC20.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
    unchecked {
        _approve(sender, _msgSender(), currentAllowance - amount);
    }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    unchecked {
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
    }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
    unchecked {
        _balances[sender] = senderBalance - amount;
    }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
        _balances[account] = accountBalance - amount;
    }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: contracts/erc20.sol

pragma solidity ^0.8.2;

/// @custom:security-contact team@arkania.io
contract ArkaniaProtocol is ERC20 {
    constructor() ERC20("Arkania Protocol", "ANIA") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Arkania Protocol/Code-4fe28aed2e2549ba649ed2edb6a11ef7d2ac73fd/AniaStake.sol

// SPDX-License-Identifier: MIT
// SWC-Outdated Compiler Version: L3
// SWC-Floating Pragma: L8
pragma solidity ^0.8.2;

contract AniaStake {
    string public name = "Arkania Protocol Launchpad";
    ArkaniaProtocol public aniaToken;

    //declaring owner state variable
    address public owner;

    //declaring default APY (default 0.1% daily or 36.5% APY yearly)
    uint256 public apy = 100;

    //declarring total value staked in the contract
    uint256 public totalStaked = 0;

    /**
     * @notice
     * A stake struct is used to represent the way we store stakes,
     * A Stake will contain the users address, the amount staked and a timestamp,
     * Since which is when the stake was made
     */
    struct Stake{
        address user;
        uint256 amount;
        uint256 since;
    }

    /**
     * @notice Staker is a user who has active stakes
     */
    struct Staker{
        address user;
        Stake address_stake;
    }

    //array of all stakers
    Staker[] internal stakers;

    /**
    * @notice
    * stakes is used to keep track of the INDEX for the stakers in the stakes array
     */
    mapping(address => uint256) internal stakes;

    constructor(ArkaniaProtocol _aniaToken) payable {
        aniaToken = _aniaToken;

        //assigning owner on deployment
        owner = msg.sender;

        // This push is needed so we avoid index 0 causing bug of index-1
        stakers.push();
    }

    /**
      * @notice
      * calculateStakeReward is used to calculate how much a user should be rewarded for their stakes
      * and the duration the stake has been active
     */
    function calculateStakeReward(Stake memory _current_stake) internal view returns(uint256) {
        return (_current_stake.amount * apy / 100) * (block.timestamp - _current_stake.since) / (365 days);
    }

    /**
    * @notice _addStaker takes care of adding a staker to the stakers array
     */
    function _addStaker(address staker) internal returns (uint256){
        // Push a empty item to the Array to make space for our new stakeholder
        stakers.push();
        // Calculate the index of the last item in the array by Len-1
        uint256 userIndex = stakers.length - 1;
        // Assign the address to the new index
        stakers[userIndex].user = staker;
        // Add index to the stakeHolders
        stakes[staker] = userIndex;
        return userIndex;
    }

    // Get total stakes of the contract
    function getTotalStaked() external view returns (uint256) {
        return totalStaked;
    }

    /**
    * @notice
    * stakeTokens is used to make a stake for an sender. It will remove the amount staked from the stakers account and place those tokens inside a stake container
    * StakeID
    */
    function stakeTokens(uint256 _amount) public {
        //must be more than 0
        require(_amount > 0, "amount cannot be 0");

        // Mappings in solidity creates all values, but empty, so we can just check the address
        uint256 index = stakes[msg.sender];
        // block.timestamp = timestamp of the current block in seconds since the epoch
        uint256 timestamp = block.timestamp;

        uint256 reward = 0;
        // See if the staker already has a staked index or if its the first time
        if (index == 0){
            // This stakeholder stakes for the first time
            // We need to add him to the stakeHolders and also map it into the Index of the stakes
            // The index returned will be the index of the stakeholder in the stakeholders array
            index = _addStaker(msg.sender);
        } else {
            reward = calculateStakeReward(stakers[index].address_stake);
        }

        uint256 newStake = stakers[index].address_stake.amount + _amount + reward;

        // Use the index to push a new Stake
        // push a newly created Stake with the current block timestamp.
        stakers[index].address_stake = Stake(msg.sender, newStake, timestamp);
        totalStaked += newStake;

        //User adding test tokens
        aniaToken.transferFrom(msg.sender, address(this), _amount);
    }

    //unstake tokens function
    function unstakeTokens(uint256 _amount) public {

        uint256 index = stakes[msg.sender];

        // Get current stakes
        uint256 userStakes = stakers[index].address_stake.amount;

        // amount should be more than 0
        require(userStakes > 0, "amount has to be more than 0");

        // Get reward from current stakes
        uint256 reward = calculateStakeReward(stakers[index].address_stake);

        //transfer staked tokens back to user
        uint256 stakedWithRewards = userStakes + reward;
        require(_amount <= stakedWithRewards, "amount has to be less or equal than current stakes with rewards");
        aniaToken.transfer(msg.sender, _amount);

        // Update Stake with the current block timestamp.
        stakers[index].address_stake = Stake(msg.sender, userStakes + reward - _amount, block.timestamp);

        // Update contract total staked tokens
        if (userStakes < _amount) {
            totalStaked -= userStakes;  // exceedes are rewards
        } else {
            totalStaked -= _amount;
        }
    }

    //get staking rewards
    function hasRewards() public view returns(uint256) {
        // Mappings in solidity creates all values, but empty, so we can just check the address
        uint256 index = stakes[msg.sender];
        return calculateStakeReward(stakers[index].address_stake);
    }

    //get staking amount with rewards
    function hasStakeWithRewards(address _address) public view returns(uint256) {
        // Mappings in solidity creates all values, but empty, so we can just check the address
        uint256 index = stakes[_address];

        if (stakers[index].user != _address) {
            return 0;
        }

        //get staking balance for user
        uint256 balance = stakers[index].address_stake.amount;

        if (index != 0) {
            balance += calculateStakeReward(stakers[index].address_stake);
        }
        return balance;
    }

    //airdrop tokens
    function redistributeRewards(address[] calldata users) public {
        //only owner can issue airdrop
        require(msg.sender == owner, "Only contract creator can redistribute");
        // SWC-DoS With Block Gas Limit: L183 - L192    
        for (uint256 i = 0; i < users.length; i++) {
            uint256 index = stakes[users[i]];
            uint256 reward = calculateStakeReward(stakers[index].address_stake);

            // update stakes before changaing the APY
            stakers[index].address_stake = Stake(stakers[index].user, stakers[index].address_stake.amount + reward, block.timestamp);

            // update total staked amount
            totalStaked += reward;
        }
    }

    //change APY value for staking, be aware of possible high gas fees
    function changeAPY(uint256 _value, address[] calldata users) public {
        //only owner can issue airdrop
        require(msg.sender == owner, "Only contract creator can change APY");
        require(
            _value > 0,
            "APY value has to be more than 0, try 100 for (0.100% daily) instead"
        );
        redistributeRewards(users);
        apy = _value;
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Arkania Protocol/Code-4fe28aed2e2549ba649ed2edb6a11ef7d2ac73fd/AniaLottery.sol

// SPDX-License-Identifier: MIT
// SWC-Outdated Compiler Version: L3
// SWC-Floating Pragma: L8
pragma solidity ^0.8.2;

contract AniaLottery {

    AniaStake public tokenStaking;

    address public owner;
    uint public tierOne = 50000;
    uint public tierOneTicketValue = 1000;
    uint public tierTwo = 20000;
    uint public tierTwoTicketValue = 500;
    uint public tierThree = 10000;
    uint public tierThreeTicketValue = 250;
    uint internal decimals = 1000000000000000000;

    event eventAddUserToWhitelist(uint indexed id, address user, uint signupDate);
    event eventAddUserToLotteryWinners(uint indexed id, address user, uint reward, uint claimed);

    struct Project {
        uint id;
        string name;
        uint raiseGoal;
        uint endDate;
        address contractAddress;
        address billingAddress;
        uint firstPayoutInPercent;
        uint256 tokenPrice;
        bool draw;
    }
    mapping (uint => Project) projects;

    struct Whitelist {
        uint projectId;
        uint signupDate;
        address userAddress;
    }

    struct LotteryWinner {
        uint projectId;
        address userAddress;
        uint reward;
        bool claimed;
    }

    constructor(AniaStake _tokenStaking) {
        tokenStaking = _tokenStaking;
        owner = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == owner || admins[msg.sender]);
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    mapping(uint => uint) projectUserCount;
    mapping(uint => Whitelist[]) projectsWhitelist;
    mapping(uint => mapping(address => uint256)) projectUserIndex;
    mapping(uint => uint) projectStakeCap;
    mapping(uint => uint) lotteryWinnerCount;
    mapping(uint => LotteryWinner[]) lotteryWinners;
    mapping(uint => mapping(address => uint256)) projectWinnerIndex;
    mapping(uint => uint) projectRaisedAmount;
    mapping (address => bool) admins;

    mapping (address => bool) stableCoins;

    // ADMIN
    function setAdmin(address _admin, bool isAdmin) public onlyOwner {
        admins[_admin] = isAdmin;
    }

    function removeAdmin(address adminAddress) public onlyAdmin {
        _removeAdminFromAdmins(adminAddress);
    }

    function setStableCoin(address _address, bool isActive) public onlyOwner {
        stableCoins[_address] = isActive;
    }

    function createProject(uint projectId, string calldata projectName, uint raiseGoal, uint endDate, address contractAddress, address billingAddress, uint firstPayoutInPercent, uint256 tokenPrice) external onlyAdmin {
        require(!_checkProjectExistById(projectId), "Project with this ID exist.");

        Project memory newProject = Project(projectId, projectName, raiseGoal, endDate, contractAddress, billingAddress, firstPayoutInPercent, tokenPrice, false);

        projects[projectId] = newProject;
    }

    function updateProject(uint projectId, string calldata projectName, uint raiseGoal, uint endDate, address contractAddress, address billingAddress, uint firstPayoutInPercent, uint256 tokenPrice) external onlyAdmin {

        // Each non-existent record returns 0
        require(projects[projectId].id == projectId, "Project with this ID not exist.");

        projects[projectId].name = projectName;
        projects[projectId].raiseGoal = raiseGoal;
        projects[projectId].endDate = endDate;
        projects[projectId].contractAddress = contractAddress;
        projects[projectId].billingAddress = billingAddress;
        projects[projectId].firstPayoutInPercent= firstPayoutInPercent;
        projects[projectId].tokenPrice = tokenPrice;
    }

    function removeProject(uint projectId) external onlyAdmin {
        _removeWhitelist(projectId);
        _removeProject(projectId);
    }

    // If there are any resources, the owner can withdraw them
    // SWC-Unprotected Ether Withdrawal: L117 - L119
    function withdraw() public payable onlyOwner {
        payable (msg.sender).transfer(address(this).balance);
    }

    function withdrawTokens(uint projectId, address recipient) public onlyAdmin {
        address contractAddress = projects[projectId].contractAddress;
        // Create a token from a given contract address
        IERC20 token = IERC20(contractAddress);
        token.transfer(recipient, token.balanceOf(address(this)));
    }

    // Add users to the whitelist in bulk
    function addUsersToWhitelist(uint projectId, address[] calldata users, bool checkEndDate) external onlyAdmin {

        if(checkEndDate){
            require(_checkOpenProject(projectId), "Project is close.");
        }
        // We will check if the whitelisting is open
        require(!projects[projectId].draw, "The lottery has been launched and project is completed close.");
        for (uint i; i < users.length; i++) {
            if(!_checkUserExistInProject(projectId, users[i])){
                projectsWhitelist[projectId].push(
                    Whitelist({
                        projectId: projectId,
                        userAddress: users[i],
                        signupDate: block.timestamp
                    })
                );
                projectStakeCap[projectId] += getUserTicketValue(users[i]);
                uint256 index = projectsWhitelist[projectId].length - 1;
                projectUserIndex[projectId][users[i]] = index;
                projectUserCount[projectId]++;
                emit eventAddUserToWhitelist(projectId, users[i], block.timestamp);
            }
        }
    }

    // Bulk removal of users from the whitelist
    function removeUsersFromWhitelist(uint projectId, address[] calldata users) external onlyAdmin {
        for (uint i; i < users.length; i++) {
            _removeUserFromProject(projectId, users[i]);
        }
    }

    function getUserTicketValue(address _address) public view returns (uint256) {
        uint256 userStake = tokenStaking.hasStakeWithRewards(_address);
        if(userStake >= tierOne * decimals){
            return tierOneTicketValue;
        } else if (userStake >= tierTwo * decimals){
            return tierTwoTicketValue;
        } else if (userStake >= tierThree * decimals){
            return tierThreeTicketValue;
        }
        return 0;
    }

    function getProjectStakeCap(uint projectId) public view returns(uint256) {
        return projectStakeCap[projectId];
    }

    function getProjectRaisedAmount(uint projectId) public view returns(uint256) {
        return projectRaisedAmount[projectId];
    }

    function lotteryDraw(uint projectId, address[] calldata users) external onlyAdmin {
        require(_checkProjectExistById(projectId), "Project with this ID does not exist.");
        require(!_checkOpenProject(projectId), "Project is open and should be closed.");
        // We will check if the lottery is open
        require(!projects[projectId].draw, "The lottery has been already drawn.");

        for (uint i; i < users.length; i++) {
            address user = users[i];
            if(_checkUserExistInProject(projectId, user) && !_checkUserIsProjectWinner(projectId, user)){
                uint reward = getUserTicketValue(user);
                if (reward > 0) {
                    lotteryWinners[projectId].push(
                        LotteryWinner({
                            projectId: projectId,
                            userAddress: user,
                            reward: reward,
                            claimed: false
                        })
                    );
                    uint256 index = lotteryWinners[projectId].length - 1;
                    projectWinnerIndex[projectId][user] = index;
                    lotteryWinnerCount[projectId]++;
                    emit eventAddUserToLotteryWinners(projectId, user, reward, 0);
                }
            }
        }

        // Set the project lottery draw status to true to avoid multiple lottery rounds
        projects[projectId].draw = true;
    }

    function getProject(uint projectId) external view returns (Project memory) {
        return projects[projectId];
    }

    function getUserCount(uint projectId) external view returns (uint) {
        return projectUserCount[projectId];
    }

    function getProjectUser(uint projectId, address userAddress) public view returns (Whitelist memory) {
        uint256 index = projectUserIndex[projectId][userAddress];
        require(projectsWhitelist[projectId][index].userAddress == userAddress, "User not found");
        return projectsWhitelist[projectId][index];
    }

    function getLotteryWinner(uint projectId, address userAddress) public view returns (LotteryWinner memory) {
        uint256 index = projectWinnerIndex[projectId][userAddress];
        require(lotteryWinners[projectId][index].userAddress == userAddress, "Winner not found");
        return lotteryWinners[projectId][index];
    }

    function getLotteryWinnerCount(uint projectId) external view returns (uint) {
        return lotteryWinnerCount[projectId];
    }

    function setLotteryWinnerClaimedStatus(uint projectId, address userAddress) internal {
        uint256 index = projectWinnerIndex[projectId][userAddress];
        require(lotteryWinners[projectId][index].userAddress == userAddress, "User not found");
        lotteryWinners[projectId][index].claimed = true;
    }

    // Helper functions
    function changeTierOne(uint _value) external onlyAdmin {
        require(_value > 0, "Tier value has to be more than 0");
        require(_value > tierTwo, "Tier value has to be more than Tier Two");
        require(_value > tierThree, "Tier value has to be more than Tier Three");
        tierOne = _value;
    }
    function changeTierTwo(uint _value) external onlyAdmin {
        require(_value > 0, "Tier value has to be more than 0");
        require(_value < tierOne, "Tier value has to be less than Tier One");
        require(_value > tierThree, "Tier value has to be more than Tier Three");
        tierTwo = _value;
    }
    function changeTierThree(uint _value) external onlyAdmin {
        require(_value > 0, "Tier value has to be more than 0");
        require(_value < tierOne, "Tier value has to be less than Tier One");
        require(_value < tierTwo, "Tier value has to be less than Tier Two");
        tierThree = _value;
    }
    function changeTierOneTicketValue(uint _value) external onlyAdmin {
        require(_value > 0, "Tier Ticket value has to be more than 0");
        require(_value > tierTwoTicketValue, "Tier Ticket value has to be more than Tier Two");
        require(_value > tierThreeTicketValue, "Tier Ticket value has to be more than Tier Three");
        tierOneTicketValue = _value;
    }
    function changeTierTwoTicketValue(uint _value) external onlyAdmin {
        require(_value > 0, "Tier Ticket value has to be more than 0");
        require(_value < tierOneTicketValue, "Tier Ticket value has to be less than Tier One");
        require(_value > tierThreeTicketValue, "Tier Ticket value has to be more than Tier Three");
        tierTwoTicketValue = _value;
    }
    function changeTierThreeTicketValue(uint _value) external onlyAdmin {
        require(_value > 0, "Tier Ticket value has to be more than 0");
        require(_value < tierOneTicketValue, "Tier Ticket value has to be less than Tier One");
        require(_value < tierTwoTicketValue, "Tier Ticket value has to be less than Tier Two");
        tierThreeTicketValue = _value;
    }

    // USER
    function signUpToWhitelist(uint projectId) external {
        // We will check if the whitelisting is open
        require(_checkOpenProject(projectId), "Project is close.");
        // We will check if the user exists in the list
        require(!_checkUserExistInProject(projectId, msg.sender), "User is already in whitelist.");
        projectsWhitelist[projectId].push(
            Whitelist({
                projectId: projectId,
                userAddress: msg.sender,
                signupDate: block.timestamp
            })
        );
        projectStakeCap[projectId] += getUserTicketValue(msg.sender);
        uint256 index = projectsWhitelist[projectId].length - 1;
        projectUserIndex[projectId][msg.sender] = index;
        projectUserCount[projectId]++;
        emit eventAddUserToWhitelist(projectId, msg.sender, block.timestamp);
    }

    function logoutFromWhitelist(uint projectId) external {
        _removeUserFromProject(projectId, msg.sender);
    }

    // We will check if the whitelisting is open
    function isProjectOpen(uint projectId) external view returns (bool){
        return _checkOpenProject(projectId);
    }

    // We will check if the user exists in the list
    function isUserInWhitelist(uint projectId) external view returns (bool) {
        return _checkUserExistInProject(projectId, msg.sender);
    }

    function checkBuy(uint projectId, uint256 tokensToBuy) public view returns (bool) {
        // The project id is required
        require(projectId > 0, "ProjectId must be selected");
        require(_checkProjectExistById(projectId), "Project with this ID does not exist.");

        // Project info
        address contractAddress = projects[projectId].contractAddress;

        // We will check how many tokens there are in the contract account
        uint256 availableTokens = anyoneTokenBalance(contractAddress, address(this));
        require(availableTokens > 0, "Insufficient tokens in contract");

        // We'll check to see if there are enough tokens to pay out in contract account
        require(tokensToBuy > 0, "Insufficient tokens to send");
        require(tokensToBuy < availableTokens, "Insufficient tokens in contract to send");

        // We will get the winner and check if there is still reward available
        LotteryWinner memory winner = getLotteryWinner(projectId, msg.sender);
        require(!winner.claimed, "User already claimed the reward");

        return true;
    }

    function buy(uint projectId, uint pay, address tokenForPayContractAddress) external {

        require(stableCoins[tokenForPayContractAddress], "This Token is not available for payment");

        // Payment must be greater than 0
        require(pay > 0, "You need to send some ether");
        require(getUserTicketValue(msg.sender) == pay, "You need to pay the exact tier value before claiming the reward");

        uint256 tokensToBuy = decimals * (pay * decimals) / projects[projectId].tokenPrice * projects[projectId].firstPayoutInPercent / 100;

        // Check requirements before any transactions
        checkBuy(projectId, tokensToBuy);

        address billingAddress = projects[projectId].billingAddress;
        address contractAddress = projects[projectId].contractAddress;
        require(billingAddress != contractAddress, "Billing Address must be different as Contract Address");

        // Create a token from a given contract address
        IERC20 token = IERC20(contractAddress);
        // I will transfer a certain number of tokens to the payer. Not all
        token.transfer(msg.sender, tokensToBuy);

        // Transfer stable Coin to Token owner
        IERC20 stableCoin = IERC20(tokenForPayContractAddress);
        stableCoin.transferFrom(msg.sender, billingAddress, pay * decimals);

        // Set the claimed attribute to true to avoid repeatedly withdrawn
        setLotteryWinnerClaimedStatus(projectId, msg.sender);
        projectRaisedAmount[projectId] += pay;
    }

    // Check the balance for a specific token for a specific address
    function anyoneTokenBalance(address tokenContractAddress, address userAddress) public view returns(uint) {
        IERC20 token = IERC20(tokenContractAddress);
        return token.balanceOf(userAddress);
    }

    // Internal functions
    function _checkProjectExistById(uint projectId) internal view returns (bool) {
        if(projects[projectId].id > 0){
            return true;
        }
        return false;
    }

    function _checkUserExistInProject(uint projectId, address userAddress) internal view returns (bool) {
        if (projectsWhitelist[projectId].length == 0) {
            return false;
        }

        uint256 index = projectUserIndex[projectId][userAddress];
        if (projectsWhitelist[projectId][index].userAddress == userAddress) {
            return true;
        }
        return false;
    }

    function _checkUserIsProjectWinner(uint projectId, address userAddress) internal view returns (bool) {
        if (lotteryWinners[projectId].length == 0) {
            return false;
        }

        uint256 index = projectWinnerIndex[projectId][userAddress];
        if (lotteryWinners[projectId][index].userAddress == userAddress) {
            return true;
        }
        return false;
    }

    function _checkOpenProject(uint projectId) internal view returns (bool) {
        return projects[projectId].id > 0 && projects[projectId].endDate > block.timestamp;
    }

    function _removeUserFromProject(uint256 projectId, address userAddress) internal {
        uint256 index = projectUserIndex[projectId][userAddress];
        if (projectsWhitelist[projectId][index].userAddress == userAddress) {
            delete projectUserIndex[projectId][userAddress];
            projectStakeCap[projectId] -= getUserTicketValue(projectsWhitelist[projectId][index].userAddress);
            delete projectsWhitelist[projectId][index];
            projectUserCount[projectId]--;
        }
    }

    function _removeAdminFromAdmins(address adminAddress) internal {
        delete admins[adminAddress];
    }

    function _removeWhitelist(uint projectId) internal {
        projectStakeCap[projectId] = 0;
        projectRaisedAmount[projectId] = 0;
        delete projectsWhitelist[projectId];
    }

    function _removeProject(uint projectId) internal {
        projectUserCount[projectId] = 0;
        lotteryWinnerCount[projectId] = 0;
        delete projects[projectId];
    }

}
