

pragma solidity ^0.6.0;














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



pragma solidity ^0.6.0;




interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}



pragma solidity ^0.6.2;




library Address {
    
















    function isContract(address account) internal view returns (bool) {
        
        
        
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    















    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}



pragma solidity ^0.6.0;












library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        
        
        
        
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    





    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        
        

        
        
        
        
        
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { 
            
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}



pragma solidity >=0.4.24 <0.7.0;














contract Initializable {

  


  bool private initialized;

  


  bool private initializing;

  


  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  
  function isConstructor() private view returns (bool) {
    
    
    
    
    
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
}



pragma solidity ^0.6.0;

















contract ReentrancyGuardUpgradeSafe is Initializable {
    bool private _notEntered;


    function __ReentrancyGuard_init() internal initializer {
        __ReentrancyGuard_init_unchained();
    }

    function __ReentrancyGuard_init_unchained() internal initializer {


        
        
        
        
        
        
        _notEntered = true;

    }


    






    modifier nonReentrant() {
        
        require(_notEntered, "ReentrancyGuard: reentrant call");

        
        _notEntered = false;

        _;

        
        
        _notEntered = true;
    }

    uint256[49] private __gap;
}



pragma solidity ^0.6.0;











contract ContextUpgradeSafe is Initializable {
    
    

    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {


    }


    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }

    uint256[50] private __gap;
}



pragma solidity ^0.6.0;














contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    



    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {


        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);

    }


    


    function owner() public view returns (address) {
        return _owner;
    }

    


    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    






    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    



    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}
















pragma solidity 0.6.12;







contract GrazingRange is OwnableUpgradeSafe, ReentrancyGuardUpgradeSafe {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  
  struct UserInfo {
    uint256 amount; 
    uint256 rewardDebt; 
  }

  
  struct CampaignInfo {
    IERC20 stakingToken; 
    IERC20 rewardToken; 
    uint256 startBlock; 
    uint256 lastRewardBlock; 
    uint256 accRewardPerShare; 
    uint256 totalStaked; 
    uint256 totalRewards;
  }

  
  struct RewardInfo {
    uint256 endBlock;
    uint256 rewardPerBlock;
  }

  
  
  
  mapping(uint256 => RewardInfo[]) public campaignRewardInfo;

  
  CampaignInfo[] public campaignInfo;
  
  mapping(uint256 => mapping(address => UserInfo)) public userInfo;

  
  
  uint256 public rewardInfoLimit;
  
  address public rewardHolder;

  event Deposit(address indexed user, uint256 amount, uint256 campaign);
  event Withdraw(address indexed user, uint256 amount, uint256 campaign);
  event EmergencyWithdraw(address indexed user, uint256 amount, uint256 campaign);
  event AddCampaignInfo(uint256 indexed campaignID, IERC20 stakingToken, IERC20 rewardToken, uint256 startBlock);
  event AddRewardInfo(uint256 indexed campaignID, uint256 indexed phase, uint256 endBlock, uint256 rewardPerBlock);
  event SetRewardInfoLimit(uint256 rewardInfoLimit);
  event SetRewardHolder(address rewardHolder);

  function initialize(address _rewardHolder) external initializer {
    OwnableUpgradeSafe.__Ownable_init();
    ReentrancyGuardUpgradeSafe.__ReentrancyGuard_init();
    rewardInfoLimit = 52; 
    rewardHolder = _rewardHolder;
  }

  function upgradePrecision() external {
    require(msg.sender == 0x5379F32C8D5F663EACb61eeF63F722950294f452, "!proxy admin");
    uint256 length = campaignInfo.length;
    for (uint256 pid = 0; pid < length; ++pid) {
      campaignInfo[pid].accRewardPerShare = campaignInfo[pid].accRewardPerShare.mul(1e8);
    }
  }

  
  function setRewardHolder(address _rewardHolder) external onlyOwner {
    rewardHolder = _rewardHolder;
    emit SetRewardHolder(_rewardHolder);
  }

  
  function setRewardInfoLimit(uint256 _updatedRewardInfoLimit) external onlyOwner {
    rewardInfoLimit = _updatedRewardInfoLimit;
    emit SetRewardInfoLimit(rewardInfoLimit);
  }

  
  function addCampaignInfo(
    IERC20 _stakingToken,
    IERC20 _rewardToken,
    uint256 _startBlock
  ) external onlyOwner {
    campaignInfo.push(
      CampaignInfo({
        stakingToken: _stakingToken,
        rewardToken: _rewardToken,
        startBlock: _startBlock,
        lastRewardBlock: _startBlock,
        accRewardPerShare: 0,
        totalStaked: 0,
        totalRewards: 0
      })
    );
    emit AddCampaignInfo(campaignInfo.length - 1, _stakingToken, _rewardToken, _startBlock);
  }

  
  function addRewardInfo(
    uint256 _campaignID,
    uint256 _endBlock,
    uint256 _rewardPerBlock
  ) external onlyOwner {
    RewardInfo[] storage rewardInfo = campaignRewardInfo[_campaignID];
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    require(rewardInfo.length < rewardInfoLimit, "GrazingRange::addRewardInfo::reward info length exceeds the limit");
    require(
      rewardInfo.length == 0 || rewardInfo[rewardInfo.length - 1].endBlock >= block.number,
      "GrazingRange::addRewardInfo::reward period ended"
    );
    require(
      rewardInfo.length == 0 || rewardInfo[rewardInfo.length - 1].endBlock < _endBlock,
      "GrazingRange::addRewardInfo::bad new endblock"
    );
    uint256 startBlock = rewardInfo.length == 0 ? campaign.startBlock : rewardInfo[rewardInfo.length - 1].endBlock;
    uint256 blockRange = _endBlock.sub(startBlock);
    uint256 totalRewards = _rewardPerBlock.mul(blockRange);
    campaign.rewardToken.safeTransferFrom(rewardHolder, address(this), totalRewards);
    campaign.totalRewards = campaign.totalRewards.add(totalRewards);
    rewardInfo.push(RewardInfo({ endBlock: _endBlock, rewardPerBlock: _rewardPerBlock }));
    emit AddRewardInfo(_campaignID, rewardInfo.length - 1, _endBlock, _rewardPerBlock);
  }

  function rewardInfoLen(uint256 _campaignID) external view returns (uint256) {
    return campaignRewardInfo[_campaignID].length;
  }

  function campaignInfoLen() external view returns (uint256) {
    return campaignInfo.length;
  }

  
  function currentEndBlock(uint256 _campaignID) external view returns (uint256) {
    return _endBlockOf(_campaignID, block.number);
  }

  function _endBlockOf(uint256 _campaignID, uint256 _blockNumber) internal view returns (uint256) {
    RewardInfo[] memory rewardInfo = campaignRewardInfo[_campaignID];
    uint256 len = rewardInfo.length;
    if (len == 0) {
      return 0;
    }
    for (uint256 i = 0; i < len; ++i) {
      if (_blockNumber <= rewardInfo[i].endBlock) return rewardInfo[i].endBlock;
    }
    
    
    return rewardInfo[len - 1].endBlock;
  }

  
  function currentRewardPerBlock(uint256 _campaignID) external view returns (uint256) {
    return _rewardPerBlockOf(_campaignID, block.number);
  }

  function _rewardPerBlockOf(uint256 _campaignID, uint256 _blockNumber) internal view returns (uint256) {
    RewardInfo[] memory rewardInfo = campaignRewardInfo[_campaignID];
    uint256 len = rewardInfo.length;
    if (len == 0) {
      return 0;
    }
    for (uint256 i = 0; i < len; ++i) {
      if (_blockNumber <= rewardInfo[i].endBlock) return rewardInfo[i].rewardPerBlock;
    }
    
    
    return 0;
  }

  
  function getMultiplier(
    uint256 _from,
    uint256 _to,
    uint256 _endBlock
  ) public pure returns (uint256) {
    if ((_from >= _endBlock) || (_from > _to)) {
      return 0;
    }
    if (_to <= _endBlock) {
      return _to.sub(_from);
    }
    return _endBlock.sub(_from);
  }

  
  function pendingReward(uint256 _campaignID, address _user) external view returns (uint256) {
    return _pendingReward(_campaignID, userInfo[_campaignID][_user].amount, userInfo[_campaignID][_user].rewardDebt);
  }

  function _pendingReward(
    uint256 _campaignID,
    uint256 _amount,
    uint256 _rewardDebt
  ) internal view returns (uint256) {
    CampaignInfo memory campaign = campaignInfo[_campaignID];
    RewardInfo[] memory rewardInfo = campaignRewardInfo[_campaignID];
    uint256 accRewardPerShare = campaign.accRewardPerShare;
    if (block.number > campaign.lastRewardBlock && campaign.totalStaked != 0) {
      uint256 cursor = campaign.lastRewardBlock;
      for (uint256 i = 0; i < rewardInfo.length; ++i) {
        uint256 multiplier = getMultiplier(cursor, block.number, rewardInfo[i].endBlock);
        if (multiplier == 0) continue;
        cursor = rewardInfo[i].endBlock;
        accRewardPerShare = accRewardPerShare.add(
          multiplier.mul(rewardInfo[i].rewardPerBlock).mul(1e20).div(campaign.totalStaked)
        );
      }
    }
    return _amount.mul(accRewardPerShare).div(1e20).sub(_rewardDebt);
  }

  function updateCampaign(uint256 _campaignID) external nonReentrant {
    _updateCampaign(_campaignID);
  }

  
  function _updateCampaign(uint256 _campaignID) internal {
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    RewardInfo[] memory rewardInfo = campaignRewardInfo[_campaignID];
    if (block.number <= campaign.lastRewardBlock) {
      return;
    }
    if (campaign.totalStaked == 0) {
      
      
      
      
      if (block.number > _endBlockOf(_campaignID, block.number)) {
        campaign.lastRewardBlock = block.number;
      }
      return;
    }
    
    for (uint256 i = 0; i < rewardInfo.length; ++i) {
      
      
      
      uint256 multiplier = getMultiplier(campaign.lastRewardBlock, block.number, rewardInfo[i].endBlock);
      if (multiplier == 0) continue;
      
      
      if (block.number > rewardInfo[i].endBlock) {
        campaign.lastRewardBlock = rewardInfo[i].endBlock;
      } else {
        campaign.lastRewardBlock = block.number;
      }
      campaign.accRewardPerShare = campaign.accRewardPerShare.add(
        multiplier.mul(rewardInfo[i].rewardPerBlock).mul(1e20).div(campaign.totalStaked)
      );
    }
  }

  
  function massUpdateCampaigns() external nonReentrant {
    uint256 length = campaignInfo.length;
    for (uint256 pid = 0; pid < length; ++pid) {
      _updateCampaign(pid);
    }
  }

  
  function deposit(uint256 _campaignID, uint256 _amount) external nonReentrant {
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    UserInfo storage user = userInfo[_campaignID][msg.sender];
    _updateCampaign(_campaignID);
    if (user.amount > 0) {
      uint256 pending = user.amount.mul(campaign.accRewardPerShare).div(1e20).sub(user.rewardDebt);
      if (pending > 0) {
        campaign.rewardToken.safeTransfer(address(msg.sender), pending);
      }
    }
    if (_amount > 0) {
      campaign.stakingToken.safeTransferFrom(address(msg.sender), address(this), _amount);
      user.amount = user.amount.add(_amount);
      campaign.totalStaked = campaign.totalStaked.add(_amount);
    }
    user.rewardDebt = user.amount.mul(campaign.accRewardPerShare).div(1e20);
    emit Deposit(msg.sender, _amount, _campaignID);
  }

  
  function withdraw(uint256 _campaignID, uint256 _amount) external nonReentrant {
    _withdraw(_campaignID, _amount);
  }

  
  function _withdraw(uint256 _campaignID, uint256 _amount) internal {
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    UserInfo storage user = userInfo[_campaignID][msg.sender];
    require(user.amount >= _amount, "GrazingRange::withdraw::bad withdraw amount");
    _updateCampaign(_campaignID);
    uint256 pending = user.amount.mul(campaign.accRewardPerShare).div(1e20).sub(user.rewardDebt);
    if (pending > 0) {
      campaign.rewardToken.safeTransfer(address(msg.sender), pending);
    }
    if (_amount > 0) {
      user.amount = user.amount.sub(_amount);
      campaign.stakingToken.safeTransfer(address(msg.sender), _amount);
      campaign.totalStaked = campaign.totalStaked.sub(_amount);
    }
    user.rewardDebt = user.amount.mul(campaign.accRewardPerShare).div(1e20);

    emit Withdraw(msg.sender, _amount, _campaignID);
  }

  
  function harvest(uint256[] calldata _campaignIDs) external nonReentrant {
    for (uint256 i = 0; i < _campaignIDs.length; ++i) {
      _withdraw(_campaignIDs[i], 0);
    }
  }

  
  function emergencyWithdraw(uint256 _campaignID) external nonReentrant {
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    UserInfo storage user = userInfo[_campaignID][msg.sender];
    uint256 _amount = user.amount;
    campaign.totalStaked = campaign.totalStaked.sub(_amount);
    user.amount = 0;
    user.rewardDebt = 0;
    campaign.stakingToken.safeTransfer(address(msg.sender), _amount);
    emit EmergencyWithdraw(msg.sender, _amount, _campaignID);
  }

  
  function emergencyRewardWithdraw(
    uint256 _campaignID,
    uint256 _amount,
    address _beneficiary
  ) external onlyOwner nonReentrant {
    CampaignInfo storage campaign = campaignInfo[_campaignID];
    uint256 currentStakingPendingReward = _pendingReward(_campaignID, campaign.totalStaked, 0);
    require(
      currentStakingPendingReward.add(_amount) <= campaign.totalRewards,
      "GrazingRange::emergencyRewardWithdraw::not enough reward token"
    );
    campaign.totalRewards = campaign.totalRewards.sub(_amount);
    campaign.rewardToken.safeTransfer(_beneficiary, _amount);
  }
}