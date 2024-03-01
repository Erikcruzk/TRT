

pragma solidity ^0.4.24;

library NameFilter {
    
    









    function nameFilter(string memory _input)
        internal
        pure
        returns(bytes32)
    {
        bytes memory _temp = bytes(_input);
        uint256 _length = _temp.length;
        
        
        require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
        
        require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
        
        if (_temp[0] == 0x30)
        {
            require(_temp[1] != 0x78, "string cannot start with 0x");
            require(_temp[1] != 0x58, "string cannot start with 0X");
        }
        
        
        bool _hasNonNumber;
        
        
        for (uint256 i = 0; i < _length; i++)
        {
            
            if (_temp[i] > 0x40 && _temp[i] < 0x5b)
            {
                
                _temp[i] = byte(uint(_temp[i]) + 32);
                
                
                if (_hasNonNumber == false)
                    _hasNonNumber = true;
            } else {
                require
                (
                    
                    _temp[i] == 0x20 || 
                    
                    (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
                    
                    (_temp[i] > 0x2f && _temp[i] < 0x3a),
                    "string contains invalid characters"
                );
                
                if (_temp[i] == 0x20)
                    require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
                
                
                if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
                    _hasNonNumber = true;    
            }
        }
        
        require(_hasNonNumber == true, "string cannot be only numbers");
        
        bytes32 _ret;
        assembly {
            _ret := mload(add(_temp, 32))
        }
        return (_ret);
    }
}


interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    






    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    








    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    










    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    










    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Playerbook {
    using NameFilter for string;
    using SafeMath for uint256;

    mapping(address => bytes32) public PlayerXName;
    mapping(bytes32 => address) public NameXPlayer;
    mapping(address => uint256) public ReferralReward;
    mapping(address => uint256) public ReferralTotalReward;
    mapping(address => mapping(address => bool)) public ReferralRecordAddress;
    mapping(address => uint256) public ReferralRecord;

    uint256 public registrationFee;
    IERC20 public rewardToken;
    address public dev;

    event NewReward(address _player, uint256 _amount);

    constructor(
        uint256 _registrationFee,
        IERC20 _rewardToken,
        address _dev
    ) public {
        registrationFee = _registrationFee;
        rewardToken = _rewardToken;
        dev = _dev;

        string memory _name = "dev";
        bytes32 name = _name.nameFilter();
        PlayerXName[_dev] = name;
        NameXPlayer[name] = _dev;
    }

    function registerPlayerName(address _player, string memory _name)
        public
        payable
        returns (bool)
    {
        require(
            msg.value >= registrationFee,
            "umm.....  you have to pay the name fee"
        );

        require(_player != address(0), "Must be normal address");

        require(checkIfNameValid(_name), "Must be unuse name");

        bytes32 name = _name.nameFilter();

        PlayerXName[_player] = name;
        NameXPlayer[name] = _player;

        return true;
    }

    function incomingReward(
        address _user,
        string memory _name,
        uint256 _amount
    ) public returns (bool) {
        rewardToken.transferFrom(msg.sender, address(this), _amount);
        bytes32 name = _name.nameFilter();
        address _player = NameXPlayer[name];

        if (_player == address(0)) {
            _player = dev;
        }

        ReferralReward[_player] = ReferralReward[_player].add(_amount);
        ReferralTotalReward[_player] = ReferralTotalReward[_player].add(
            _amount
        );
        emit NewReward(_player, _amount);

        if (!ReferralRecordAddress[_player][_user]) {
            ReferralRecordAddress[_player][_user] = true;
            ReferralRecord[_player] = ReferralRecord[_player] + 1;
        }

        return true;
    }

    function withdarwReard() external returns (bool) {
        uint256 reward = ReferralReward[msg.sender];
        require(rewardToken.balanceOf(address(this)) >= reward);

        rewardToken.transfer(msg.sender, reward);

        ReferralReward[msg.sender] = 0;

        return true;
    }

    function withdrawETH(address _receiver) external returns (bool) {
        require(msg.sender == dev);
        _receiver.transfer(address(this).balance);
        return true;
    }

    function setFee(uint _fee) external {
        require(msg.sender == dev);

        registrationFee = _fee;
    }

    function forceExit(IERC20 _token) public {
        require(msg.sender == dev);
        _token.transfer(msg.sender, _token.balanceOf(address(this)));
    }

    function getNameFee() external view returns (uint256) {
        return (registrationFee);
    }

    function getReferralReward(address _user) external view returns (uint256) {
        return (ReferralReward[_user]);
    }

    function getPlayer(string memory _nameStr) public view returns (address) {
        bytes32 _name = _nameStr.nameFilter();
        return NameXPlayer[_name];
    }

    function checkIfNameValid(string memory _nameStr)
        public
        view
        returns (bool)
    {
        bytes32 _name = _nameStr.nameFilter();
        if (NameXPlayer[_name] == address(0)) return (true);
        else return (false);
    }
}