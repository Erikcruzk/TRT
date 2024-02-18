



pragma solidity ^0.8.0;




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





pragma solidity ^0.8.0;






interface IERC20Metadata is IERC20 {
    


    function name() external view returns (string memory);

    


    function symbol() external view returns (string memory);

    


    function decimals() external view returns (uint8);
}





pragma solidity ^0.8.0;











abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; 
        return msg.data;
    }
}





pragma solidity ^0.8.0;



























contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

    string internal _name;
    string internal _symbol;

    








    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    


    function name() public view virtual override returns (string memory) {
        return _name;
    }

    



    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    












    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    


    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    







    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    






    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    












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

    











    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    













    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    unchecked {
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
    }

        return true;
    }

    













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

    








    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    










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

    













    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    













    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}





pragma solidity ^0.8.0;













abstract contract Ownable is Context {
    address private _owner;
    address private _pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    


    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    


    function owner() public view returns (address) {
        return _owner;
    }

    


    function pendingOwner() public view returns (address) {
        return _pendingOwner;
    }

    


    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    


    modifier onlyPendingOwner() {
        require(pendingOwner() == _msgSender(), "Ownable: caller is not the pending owner");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _pendingOwner = newOwner;
    }

    function claimOwnership() external onlyPendingOwner {
        _owner = _pendingOwner;
        _pendingOwner = address(0);
        emit OwnershipTransferred(_owner, _pendingOwner);
    }
}




pragma solidity ^0.8.0;

interface IERC677 is IERC20 {
    function transferAndCall(
        address to,
        uint256 value,
        bytes memory data
    ) external returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
}




pragma solidity ^0.8.0;

interface IERC677Receiver {
    function onTokenTransfer(address _sender, uint _value, bytes memory _data) external;
}




pragma solidity ^0.8.0;




contract CGUToken is ERC20, IERC677, Ownable {
    event Lock(address account, uint256 amount, uint256 timestamp);
    event Burn(address account, uint256 amount);

    struct AccountLock {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => AccountLock) public locks;

    bool private initialized;

    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20(tokenName, tokenSymbol) {}

    function init(address _initialHolder) external onlyOwner {
        require(!initialized, "Initialized");
        _mint(_initialHolder, 1000000000 * 10**8);
        initialized = true;
    }

    function _checksForLock(address account, uint256 amount) internal {
        if (locks[account].timestamp != 0) {
            uint256 lockedAmount = getLockedAmount(account);
            uint256 freeAmount = _balances[account] - lockedAmount;
            require(amount <= freeAmount, 'Such token amount is locked or you have insufficient balance');
        }
    }

    function lock(address account, uint256 amount, uint256 timestamp) external onlyOwner {
        require(locks[account].timestamp == 0, 'You can create a lock only once for address');
        _transfer(_msgSender(), account, amount);
        locks[account] = AccountLock(amount, timestamp);
        emit Lock(account, amount, timestamp);
    }

    function burn(uint256 amount) external {
        _checksForLock(_msgSender(), amount);
        _burn(_msgSender(), amount);
        emit Burn(_msgSender(), amount);
    }


    function getLockedAmount(address account) public view returns (uint256) {
        return locks[account].timestamp > block.timestamp ? locks[account].amount : 0;
    }

    function transfer(address recipient, uint256 amount) public override(ERC20, IERC20) returns (bool) {
        _checksForLock(_msgSender(), amount);
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override(ERC20, IERC20) returns (bool) {
        _checksForLock(sender, amount);
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
    unchecked {
        _approve(sender, _msgSender(), currentAllowance - amount);
    }
        return true;
    }


    function transferAndCall(address _to, uint _value, bytes memory _data) public override returns (bool success)
    {
        _checksForLock(_msgSender(), _value);
        transfer(_to, _value);
        emit Transfer(_msgSender(), _to, _value, _data);
        if (isContract(_to)) {
            contractFallback(_to, _value, _data);
        }
        return true;
    }

    function contractFallback(address _to, uint _value, bytes memory _data) private
    {
        IERC677Receiver receiver = IERC677Receiver(_to);
        receiver.onTokenTransfer(_msgSender(), _value, _data);
    }

    function isContract(address _addr) private view returns (bool hasCode)
    {
        uint length;
        assembly {length := extcodesize(_addr)}
        return length > 0;
    }

}