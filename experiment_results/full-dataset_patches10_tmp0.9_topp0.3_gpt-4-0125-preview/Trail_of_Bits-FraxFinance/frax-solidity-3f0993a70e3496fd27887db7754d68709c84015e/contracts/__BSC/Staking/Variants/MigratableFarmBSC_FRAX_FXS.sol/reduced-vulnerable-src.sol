


pragma solidity 0.8.2;




library Math {
    


    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    


    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    



    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }

    
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}



pragma solidity 0.8.2;















library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    








    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    








    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    










    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    










    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    










    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}





pragma solidity 0.8.2;











contract Context {
    
    
    constructor() {}

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; 
        return msg.data;
    }
}




pragma solidity 0.8.2;













contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    


    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    


    function owner() public view returns (address) {
        return _owner;
    }

    


    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }

    






    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    



    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    


    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



pragma solidity 0.8.2;

interface IBEP20 {
    


    function totalSupply() external view returns (uint256);

    


    function decimals() external view returns (uint8);

    


    function symbol() external view returns (string memory);

    


    function name() external view returns (string memory);

    


    function getOwner() external view returns (address);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address _owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}





pragma solidity 0.8.2;




library Address {
    
















    function isContract(address account) internal view returns (bool) {
        
        
        
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    















    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');

        
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }

    

















    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }

    





    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    










    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

    





    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');

        
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                

                
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}




pragma solidity 0.8.2;





























contract BEP20 is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    








    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    


    function getOwner() external override view returns (address) {
        return owner();
    }

    


    function name() public override view returns (string memory) {
        return _name;
    }

    


    function decimals() public override view returns (uint8) {
        return _decimals;
    }

    


    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    


    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    


    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    







    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    


    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    






    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    











    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
        );
        return true;
    }

    











    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    













    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
        );
        return true;
    }

    







    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    













    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), 'BEP20: transfer from the zero address');
        require(recipient != address(0), 'BEP20: transfer to the zero address');

        _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    








    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    










    function _burn(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: burn from the zero address');

        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    












    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), 'BEP20: approve from the zero address');
        require(spender != address(0), 'BEP20: approve to the zero address');

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    





    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
        );
    }
}




pragma solidity 0.8.2;












library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    






    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        
        
        
        
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeBEP20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            'SafeBEP20: decreased allowance below zero'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    





    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        
        
        

        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {
            
            
            require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
        }
    }
}




pragma solidity 0.8.2;



library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferBNB(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }
}




pragma solidity 0.8.2;

















contract ReentrancyGuard {
    
    
    
    
    

    
    
    
    
    
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    






    modifier nonReentrant() {
        
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        
        _status = _ENTERED;

        _;

        
        
        _status = _NOT_ENTERED;
    }
}




pragma solidity 0.8.2;


contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor(address _owner) public {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner may perform this action");
        _;
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}




pragma solidity 0.8.2;




abstract contract Pausable is Owned {
    uint public lastPauseTime;
    bool public paused;

    constructor() internal {
        
        require(owner != address(0), "Owner must be set");
        
    }

    



    function setPaused(bool _paused) external onlyOwner {
        
        if (_paused == paused) {
            return;
        }

        
        paused = _paused;

        
        if (paused) {
            lastPauseTime = block.timestamp;
        }

        
        emit PauseChanged(paused);
    }

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "This action cannot be performed while the contract is paused");
        _;
    }
}




pragma solidity 0.8.2;
pragma experimental ABIEncoderV2;
































contract MigratableFarmBSC is Owned, ReentrancyGuard, Pausable {
    using SafeMath for uint256;
    using SafeBEP20 for BEP20;

    

    BEP20 public rewardsToken0;
    BEP20 public rewardsToken1;
    BEP20 public stakingToken;
    uint256 public periodFinish;

    
    uint256 private constant PRICE_PRECISION = 1e6;
    uint256 private constant MULTIPLIER_BASE = 1e6;

    
    uint256 public rewardRate0;
    uint256 public rewardRate1;

    
    uint256 public rewardsDuration = 604800; 

    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored0 = 0;
    uint256 public rewardPerTokenStored1 = 0;

    address public owner_address;
    address public timelock_address; 

    uint256 public locked_stake_max_multiplier = 3000000; 
    uint256 public locked_stake_time_for_max_multiplier = 3 * 365 * 86400; 
    uint256 public locked_stake_min_time = 604800; 
    string private locked_stake_min_time_str = "604800"; 

    mapping(address => uint256) public userRewardPerTokenPaid0;
    mapping(address => uint256) public userRewardPerTokenPaid1;
    mapping(address => uint256) public rewards0;
    mapping(address => uint256) public rewards1;

    uint256 private _staking_token_supply = 0;
    uint256 private _staking_token_boosted_supply = 0;
    mapping(address => uint256) private _unlocked_balances;
    mapping(address => uint256) private _locked_balances;
    mapping(address => uint256) private _boosted_balances;

    mapping(address => LockedStake[]) private lockedStakes;

    
    mapping(address => bool) public valid_migrators;
    address[] public valid_migrators_array;

    
    mapping(address => mapping(address => bool)) public staker_allowed_migrators;

    mapping(address => bool) public greylist;

    bool public token1_rewards_on = false;

    bool public migrationsOn = false; 
    bool public stakesUnlocked = false; 
    bool public withdrawalsPaused = false; 
    bool public rewardsCollectionPaused = false; 

    struct LockedStake {
        bytes32 kek_id;
        uint256 start_timestamp;
        uint256 amount;
        uint256 ending_timestamp;
        uint256 multiplier; 
    }

    

    modifier onlyByOwnerOrGovernance() {
        require(msg.sender == owner_address || msg.sender == timelock_address, "You are not the owner or the governance timelock");
        _;
    }

    modifier onlyByOwnerOrGovernanceOrMigrator() {
        require(msg.sender == owner_address || msg.sender == timelock_address || valid_migrators[msg.sender] == true, "You are not the owner, governance timelock, or a migrator");
        _;
    }

    modifier isMigrating() {
        require(migrationsOn == true, "Contract is not in migration");
        _;
    }

    modifier notWithdrawalsPaused() {
        require(withdrawalsPaused == false, "Withdrawals are paused");
        _;
    }

    modifier notRewardsCollectionPaused() {
        require(rewardsCollectionPaused == false, "Rewards collection is paused");
        _;
    }
    

    modifier updateReward(address account) {
        
        sync();

        if (account != address(0)) {
            (uint256 earned0, uint256 earned1) = earned(account);
            rewards0[account] = earned0;
            rewards1[account] = earned1;
            userRewardPerTokenPaid0[account] = rewardPerTokenStored0;
            userRewardPerTokenPaid1[account] = rewardPerTokenStored1;
        }
        _;
    }



    

    constructor(
        address _owner,
        address _rewardsToken0,
        address _rewardsToken1,
        address _stakingToken,
        address _timelock_address
    ) public Owned(_owner){
        owner_address = _owner;
        rewardsToken0 = BEP20(_rewardsToken0);
        rewardsToken1 = BEP20(_rewardsToken1);
        stakingToken = BEP20(_stakingToken);
        lastUpdateTime = block.timestamp;
        timelock_address = _timelock_address;

        
        rewardRate0 = (uint256(365000e18)).div(365 * 86400); 

        
        rewardRate1 = 0; 
        migrationsOn = false;
        stakesUnlocked = false;
    }

    

    function totalSupply() external view returns (uint256) {
        return _staking_token_supply;
    }

    function totalBoostedSupply() external view returns (uint256) {
        return _staking_token_boosted_supply;
    }

    function stakingMultiplier(uint256 secs) public view returns (uint256) {
        uint256 multiplier = uint(MULTIPLIER_BASE).add(secs.mul(locked_stake_max_multiplier.sub(MULTIPLIER_BASE)).div(locked_stake_time_for_max_multiplier));
        if (multiplier > locked_stake_max_multiplier) multiplier = locked_stake_max_multiplier;
        return multiplier;
    }

    
    function balanceOf(address account) external view returns (uint256) {
        return (_unlocked_balances[account]).add(_locked_balances[account]);
    }

    
    function unlockedBalanceOf(address account) external view returns (uint256) {
        return _unlocked_balances[account];
    }

    
    function lockedBalanceOf(address account) public view returns (uint256) {
        return _locked_balances[account];
    }

    
    
    function boostedBalanceOf(address account) external view returns (uint256) {
        return _boosted_balances[account];
    }

    function lockedStakesOf(address account) external view returns (LockedStake[] memory) {
        return lockedStakes[account];
    }

    function stakingDecimals() external view returns (uint256) {
        return stakingToken.decimals();
    }

    function rewardsFor(address account) external view returns (uint256, uint256) {
        
        return (rewards0[account], rewards1[account]);
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function rewardPerToken() public view returns (uint256, uint256) {
        if (_staking_token_supply == 0) {
            return (rewardPerTokenStored0, rewardPerTokenStored1);
        }
        else {
            return (
                
                rewardPerTokenStored0.add(
                    lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate0).mul(1e18).div(_staking_token_boosted_supply)
                ),
                
                
                rewardPerTokenStored1.add(
                    lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate1).mul(1e18).div(_staking_token_boosted_supply)
                )
            );
        }
    }

    function earned(address account) public view returns (uint256, uint256) {
        (uint256 reward0, uint256 reward1) = rewardPerToken();
        return (
            _boosted_balances[account].mul(reward0.sub(userRewardPerTokenPaid0[account])).div(1e18).add(rewards0[account]),
            _boosted_balances[account].mul(reward1.sub(userRewardPerTokenPaid1[account])).div(1e18).add(rewards1[account])
        );
    }

    function getRewardForDuration() external view returns (uint256, uint256) {
        return (
            rewardRate0.mul(rewardsDuration),
            rewardRate1.mul(rewardsDuration)
        );
    }

    function migratorApprovedForStaker(address staker_address, address migrator_address) public view returns (bool) {
        
        if (valid_migrators[migrator_address] == false) return false;

        
        if (staker_allowed_migrators[staker_address][migrator_address] == true) return true;

        
        return false;
    }

    

    
    function stakerAllowMigrator(address migrator_address) public {
        require(staker_allowed_migrators[msg.sender][migrator_address] == false, "Address already exists");
        require(valid_migrators[migrator_address], "Invalid migrator address");
        staker_allowed_migrators[msg.sender][migrator_address] = true; 
    }

    
    function stakerDisallowMigrator(address migrator_address) public {
        require(staker_allowed_migrators[msg.sender][migrator_address] == true, "Address doesn't exist already");
        
        
        

        
        delete staker_allowed_migrators[msg.sender][migrator_address];
    }
    
    
    function stake(uint256 amount) public {
        _stake(msg.sender, msg.sender, amount);
    }

    
    
    function _stake(address staker_address, address source_address, uint256 amount) internal nonReentrant updateReward(staker_address) {
        require((paused == false && migrationsOn == false) || valid_migrators[msg.sender] == true, "Staking is paused, or migration is happening");
        require(amount > 0, "Cannot stake 0");
        require(greylist[staker_address] == false, "address has been greylisted");

        
        TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), amount);

        
        _staking_token_supply = _staking_token_supply.add(amount);
        _staking_token_boosted_supply = _staking_token_boosted_supply.add(amount);

        
        _unlocked_balances[staker_address] = _unlocked_balances[staker_address].add(amount);
        _boosted_balances[staker_address] = _boosted_balances[staker_address].add(amount);

        emit Staked(staker_address, amount, source_address);
    }

    
    function stakeLocked(uint256 amount, uint256 secs) public {
        _stakeLocked(msg.sender, msg.sender, amount, secs);
    }

    
    
    function _stakeLocked(address staker_address, address source_address, uint256 amount, uint256 secs) internal nonReentrant updateReward(staker_address) {
        require((paused == false && migrationsOn == false) || valid_migrators[msg.sender] == true, "Staking is paused, or migration is happening");
        require(amount > 0, "Cannot stake 0");
        require(secs > 0, "Cannot wait for a negative number");
        require(greylist[staker_address] == false, "address has been greylisted");
        require(secs >= locked_stake_min_time, "Minimum stake time not met");
        require(secs <= locked_stake_time_for_max_multiplier, "You are trying to stake for too long");

        uint256 multiplier = stakingMultiplier(secs);
        uint256 boostedAmount = amount.mul(multiplier).div(PRICE_PRECISION);
        lockedStakes[staker_address].push(LockedStake(
            keccak256(abi.encodePacked(staker_address, block.timestamp, amount)),
            block.timestamp,
            amount,
            block.timestamp.add(secs),
            multiplier
        ));

        
        TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), amount);

        
        _staking_token_supply = _staking_token_supply.add(amount);
        _staking_token_boosted_supply = _staking_token_boosted_supply.add(boostedAmount);

        
        _locked_balances[staker_address] = _locked_balances[staker_address].add(amount);
        _boosted_balances[staker_address] = _boosted_balances[staker_address].add(boostedAmount);

        emit StakeLocked(staker_address, amount, secs, source_address);
    }

    
    function withdraw(uint256 amount) public {
        _withdraw(msg.sender, msg.sender, amount);
    }

    
    
    function _withdraw(address staker_address, address destination_address, uint256 amount) internal nonReentrant notWithdrawalsPaused updateReward(staker_address) {
        require(amount > 0, "Cannot withdraw 0");

        
        _unlocked_balances[staker_address] = _unlocked_balances[staker_address].sub(amount);
        _boosted_balances[staker_address] = _boosted_balances[staker_address].sub(amount);

        
        _staking_token_supply = _staking_token_supply.sub(amount);
        _staking_token_boosted_supply = _staking_token_boosted_supply.sub(amount);

        
        stakingToken.safeTransfer(destination_address, amount);
        emit Withdrawn(staker_address, amount, destination_address);
    }

    
    function withdrawLocked(bytes32 kek_id) public {
        _withdrawLocked(msg.sender, msg.sender, kek_id);
    }

    
    
    function _withdrawLocked(address staker_address, address destination_address, bytes32 kek_id) internal nonReentrant notWithdrawalsPaused updateReward(staker_address) {
        LockedStake memory thisStake;
        thisStake.amount = 0;
        uint theIndex;
        for (uint i = 0; i < lockedStakes[staker_address].length; i++){ 
            if (kek_id == lockedStakes[staker_address][i].kek_id){
                thisStake = lockedStakes[staker_address][i];
                theIndex = i;
                break;
            }
        }
        require(thisStake.kek_id == kek_id, "Stake not found");
        require(block.timestamp >= thisStake.ending_timestamp || stakesUnlocked == true || valid_migrators[msg.sender] == true, "Stake is still locked!");

        uint256 theAmount = thisStake.amount;
        uint256 boostedAmount = theAmount.mul(thisStake.multiplier).div(PRICE_PRECISION);
        if (theAmount > 0){
            
            _locked_balances[staker_address] = _locked_balances[staker_address].sub(theAmount);
            _boosted_balances[staker_address] = _boosted_balances[staker_address].sub(boostedAmount);

            
            _staking_token_supply = _staking_token_supply.sub(theAmount);
            _staking_token_boosted_supply = _staking_token_boosted_supply.sub(boostedAmount);

            
            delete lockedStakes[staker_address][theIndex];

            
            stakingToken.safeTransfer(destination_address, theAmount);

            emit WithdrawnLocked(staker_address, theAmount, kek_id, destination_address);
        }

    }
    
    
    function getReward() public {
        _getReward(msg.sender, msg.sender);
    }

    
    
    function _getReward(address rewardee, address destination_address) internal nonReentrant notRewardsCollectionPaused updateReward(rewardee) {
        uint256 reward0 = rewards0[rewardee];
        uint256 reward1 = rewards1[rewardee];
        if (reward0 > 0) {
            rewards0[rewardee] = 0;
            rewardsToken0.transfer(destination_address, reward0);
            emit RewardPaid(rewardee, reward0, address(rewardsToken0), destination_address);
        }
        
            if (reward1 > 0) {
                rewards1[rewardee] = 0;
                rewardsToken1.transfer(destination_address, reward1);
                emit RewardPaid(rewardee, reward1, address(rewardsToken1), destination_address);
            }
        
    }

    function renewIfApplicable() external {
        if (block.timestamp > periodFinish) {
            retroCatchUp();
        }
    }

    
    function retroCatchUp() internal {
        
        require(block.timestamp > periodFinish, "Period has not expired yet!");

        
        
        
        
        uint256 num_periods_elapsed = uint256(block.timestamp.sub(periodFinish)) / rewardsDuration; 
        uint balance0 = rewardsToken0.balanceOf(address(this));
        uint balance1 = rewardsToken1.balanceOf(address(this));
        require(rewardRate0.mul(rewardsDuration).mul(num_periods_elapsed + 1) <= balance0, "Not enough FXS available for rewards!");
        
        if (token1_rewards_on){
            require(rewardRate1.mul(rewardsDuration).mul(num_periods_elapsed + 1) <= balance1, "Not enough token1 available for rewards!");
        }
        
        
        

        
        periodFinish = periodFinish.add((num_periods_elapsed.add(1)).mul(rewardsDuration));

        (uint256 reward0, uint256 reward1) = rewardPerToken();
        rewardPerTokenStored0 = reward0;
        rewardPerTokenStored1 = reward1;
        lastUpdateTime = lastTimeRewardApplicable();

        emit RewardsPeriodRenewed(address(stakingToken));
    }

    function sync() public {
        if (block.timestamp > periodFinish) {
            retroCatchUp();
        }
        else {
            (uint256 reward0, uint256 reward1) = rewardPerToken();
            rewardPerTokenStored0 = reward0;
            rewardPerTokenStored1 = reward1;
            lastUpdateTime = lastTimeRewardApplicable();
        }
    }

    

    
    function migrator_stake_for(address staker_address, uint256 amount) external isMigrating {
        require(migratorApprovedForStaker(staker_address, msg.sender), "msg.sender is either an invalid migrator or the staker has not approved them");
        _stake(staker_address, msg.sender, amount);
    }

    
    function migrator_stakeLocked_for(address staker_address, uint256 amount, uint256 secs) external isMigrating {
        require(migratorApprovedForStaker(staker_address, msg.sender), "msg.sender is either an invalid migrator or the staker has not approved them");
        _stakeLocked(staker_address, msg.sender, amount, secs);
    }

    
    function migrator_withdraw_unlocked(address staker_address) external isMigrating {
        require(migratorApprovedForStaker(staker_address, msg.sender), "msg.sender is either an invalid migrator or the staker has not approved them");
        _withdraw(staker_address, msg.sender, _unlocked_balances[staker_address]);
    }

    
    function migrator_withdraw_locked(address staker_address, bytes32 kek_id) external isMigrating {
        require(migratorApprovedForStaker(staker_address, msg.sender), "msg.sender is either an invalid migrator or the staker has not approved them");
        _withdrawLocked(staker_address, msg.sender, kek_id);
    }

    
    function addMigrator(address migrator_address) public onlyByOwnerOrGovernance {
        require(valid_migrators[migrator_address] == false, "address already exists");
        valid_migrators[migrator_address] = true; 
        valid_migrators_array.push(migrator_address);
    }

    
    function removeMigrator(address migrator_address) public onlyByOwnerOrGovernance {
        require(valid_migrators[migrator_address] == true, "address doesn't exist already");
        
        
        delete valid_migrators[migrator_address];

        
        for (uint i = 0; i < valid_migrators_array.length; i++){ 
            if (valid_migrators_array[i] == migrator_address) {
                valid_migrators_array[i] = address(0); 
                break;
            }
        }
    }

    
    function recoverBEP20(address tokenAddress, uint256 tokenAmount) external onlyByOwnerOrGovernance {
        
        if(!migrationsOn){
            require(tokenAddress != address(stakingToken), "Cannot withdraw staking tokens unless migration is on"); 
        }
        
        BEP20(tokenAddress).transfer(owner_address, tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    function setRewardsDuration(uint256 _rewardsDuration) external onlyByOwnerOrGovernance {
        require(
            periodFinish == 0 || block.timestamp > periodFinish,
            "Previous rewards period must be complete before changing the duration for the new period"
        );
        rewardsDuration = _rewardsDuration;
        emit RewardsDurationUpdated(rewardsDuration);
    }

    function setMultipliers(uint256 _locked_stake_max_multiplier) external onlyByOwnerOrGovernance {
        require(_locked_stake_max_multiplier >= 1, "Multiplier must be greater than or equal to 1");

        locked_stake_max_multiplier = _locked_stake_max_multiplier;
        
        emit LockedStakeMaxMultiplierUpdated(locked_stake_max_multiplier);
    }

    function setLockedStakeTimeForMinAndMaxMultiplier(uint256 _locked_stake_time_for_max_multiplier, uint256 _locked_stake_min_time) external onlyByOwnerOrGovernance {
        require(_locked_stake_time_for_max_multiplier >= 1, "Multiplier Max Time must be greater than or equal to 1");
        require(_locked_stake_min_time >= 1, "Multiplier Min Time must be greater than or equal to 1");
        
        locked_stake_time_for_max_multiplier = _locked_stake_time_for_max_multiplier;

        locked_stake_min_time = _locked_stake_min_time;

        emit LockedStakeTimeForMaxMultiplier(locked_stake_time_for_max_multiplier);
        emit LockedStakeMinTime(_locked_stake_min_time);
    }

    function initializeDefault() external onlyByOwnerOrGovernance {
        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp.add(rewardsDuration);
        emit DefaultInitialization();
    }

    function greylistAddress(address _address) external onlyByOwnerOrGovernance {
        greylist[_address] = !(greylist[_address]);
    }

    function unlockStakes() external onlyByOwnerOrGovernance {
        stakesUnlocked = !stakesUnlocked;
    }

    function toggleMigrations() external onlyByOwnerOrGovernance {
        migrationsOn = !migrationsOn;
    }

    function toggleWithdrawals() external onlyByOwnerOrGovernance {
        withdrawalsPaused = !withdrawalsPaused;
    }

    function toggleRewardsCollection() external onlyByOwnerOrGovernance {
        rewardsCollectionPaused = !rewardsCollectionPaused;
    }

    function setRewardRates(uint256 _new_rate0, uint256 _new_rate1, bool sync_too) external onlyByOwnerOrGovernance {
        rewardRate0 = _new_rate0;
        rewardRate1 = _new_rate1;

        if (sync_too){
            sync();
        }
    }

    function toggleToken1Rewards() external onlyByOwnerOrGovernance {
        if (token1_rewards_on) {
            rewardRate1 = 0;
        }
        token1_rewards_on = !token1_rewards_on;
    }

    function setOwner(address _owner_address) external onlyByOwnerOrGovernance {
        owner_address = _owner_address;
    }

    function setTimelock(address _new_timelock) external onlyByOwnerOrGovernance {
        timelock_address = _new_timelock;
    }

    

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount, address source_address );
    event StakeLocked(address indexed user, uint256 amount, uint256 secs, address source_address);
    event Withdrawn(address indexed user, uint256 amount, address destination_address);
    event WithdrawnLocked(address indexed user, uint256 amount, bytes32 kek_id, address destination_address);
    event RewardPaid(address indexed user, uint256 reward, address token_address, address destination_address);
    event RewardsDurationUpdated(uint256 newDuration);
    event Recovered(address token, uint256 amount);
    event RewardsPeriodRenewed(address token);
    event DefaultInitialization();
    event LockedStakeMaxMultiplierUpdated(uint256 multiplier);
    event LockedStakeTimeForMaxMultiplier(uint256 secs);
    event LockedStakeMinTime(uint256 secs);
}




pragma solidity 0.8.2;
pragma experimental ABIEncoderV2;

contract MigratableFarmBSC_FRAX_FXS is MigratableFarmBSC {
    constructor(
        address _owner,
        address _rewardsToken0,
        address _rewardsToken1,
        address _stakingToken,
        address _timelock_address
    ) 
    MigratableFarmBSC(_owner, _rewardsToken0, _rewardsToken1, _stakingToken, _timelock_address)
    public {}
}