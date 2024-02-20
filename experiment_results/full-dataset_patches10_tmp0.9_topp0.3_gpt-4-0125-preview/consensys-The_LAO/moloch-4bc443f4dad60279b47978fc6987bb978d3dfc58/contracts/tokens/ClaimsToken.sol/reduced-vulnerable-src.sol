

pragma solidity ^0.5.2;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}



pragma solidity ^0.5.2;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}



pragma solidity ^0.5.2;














contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    




    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    





    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    




    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    








    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    







    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    









    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    









    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    





    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    






    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    





    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    





    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    







    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}



pragma solidity ^0.5.2;






contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    




    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    


    function name() public view returns (string memory) {
        return _name;
    }

    



    function symbol() public view returns (string memory) {
        return _symbol;
    }

    











    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

interface IClaimsToken {

	




	event FundsReceived(address indexed from, uint256 fundsReceived);

	




	event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn);

	


	function withdrawFunds() external payable;

	




	function availableFunds(address _forAddress) external view returns (uint256);

	



	function totalReceivedFunds() external view returns (uint256);
}

contract ClaimsToken is IClaimsToken, ERC20, ERC20Detailed {

	using SafeMath for uint256;

	
	uint256 public receivedFunds;
	
	mapping (address => uint256) public processedFunds;
	
	mapping (address => uint256) public claimedFunds;


	constructor(address _owner)
		public
		ERC20Detailed("ClaimsToken", "CST", 18)
	{
		_mint(_owner, 10000 * (10 ** uint256(18)));

		receivedFunds = 0;
	}

	






	function transfer(address _to, uint256 _value)
		public
		returns (bool)
	{
		_claimFunds(msg.sender);
		_claimFunds(_to);

		return super.transfer(_to, _value);
	}


	







	function transferFrom(address _from, address _to, uint256 _value)
		public
		returns (bool)
	{
		_claimFunds(_from);
		_claimFunds(_to);

		return super.transferFrom(_from, _to, _value);
	}

	



	function totalReceivedFunds()
		external
		view
		returns (uint256)
	{
		return receivedFunds;
	}

	




	function availableFunds(address _forAddress)
		public
		view
		returns (uint256)
	{
		return _calcUnprocessedFunds(_forAddress).add(claimedFunds[_forAddress]);
	}

	




	function _registerFunds(uint256 _value)
		internal
	{
		receivedFunds = receivedFunds.add(_value);
	}

	



	function _calcUnprocessedFunds(address _forAddress)
		internal
		view
		returns (uint256)
	{
		uint256 newReceivedFunds = receivedFunds.sub(processedFunds[_forAddress]);
		return balanceOf(_forAddress).mul(newReceivedFunds).div(totalSupply());
	}

	



	function _claimFunds(address _forAddress) internal {
		uint256 unprocessedFunds = _calcUnprocessedFunds(_forAddress);

		processedFunds[_forAddress] = receivedFunds;
		claimedFunds[_forAddress] = claimedFunds[_forAddress].add(unprocessedFunds);
	}

	





	function _prepareWithdraw()
		internal
		returns (uint256)
	{
		uint256 withdrawableFunds = availableFunds(msg.sender);

		processedFunds[msg.sender] = receivedFunds;
		claimedFunds[msg.sender] = 0;

		return withdrawableFunds;
	}
}

contract ClaimsTokenERC20Extension is IClaimsToken, ClaimsToken {

	
	IERC20 public fundsToken;

	modifier onlyFundsToken () {
		require(msg.sender == address(fundsToken), "UNAUTHORIZED_SENDER");
		_;
	}

	constructor(address _owner, IERC20 _fundsToken)
		public
		ClaimsToken(_owner)
	{
		require(address(_fundsToken) != address(0));

		fundsToken = _fundsToken;
	}

	


	function withdrawFunds()
		external
		payable
	{
		require(msg.value == 0, "");

		uint256 withdrawableFunds = _prepareWithdraw();

		require(fundsToken.transfer(msg.sender, withdrawableFunds), "TRANSFER_FAILED");
	}

	





	function tokenFallback(address _sender, uint256 _value, bytes memory)
		public
		onlyFundsToken()
	{
		if (_value > 0) {
			_registerFunds(_value);
			emit FundsReceived(_sender, _value);
		}
	}
}