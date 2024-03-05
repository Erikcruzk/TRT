


pragma solidity 0.8.11;


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

contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Fidometa is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;

    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _isExcludedFromCommunity_charge;
    mapping(address => bool) public _isExcludedFromReward;

    address[] private _excluded;

    mapping(address => bool) public _isExcludedFromEcoSysFee;
    mapping(address => bool) public _isExcludedFromSurcharge1;
    mapping(address => bool) public _isExcludedFromSurcharge2;
    mapping(address => bool) public _isExcludedFromSurcharge3;

    uint256 private constant MAX = ~uint256(0);

    string public name = "Fido Meta";
    string public symbol = "FMC";
    uint8 public decimals = 9;
    uint256 private _tTotal = 15000000000 * 10**uint256(decimals);
    uint256 public _cap;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 public _tCommunityChargeTotal;

    address public _ecoSysWallet;
    address public _surcharge_1_Wallet;
    address public _surcharge_2_Wallet;
    address public _surcharge_3_Wallet;

    uint256 public _community_charge = 3 * 10**uint256(decimals);
    uint256 public _ecoSysFee = 15 * 10**8;
    uint256 public _surcharge1 = 5 * 10**8;
    uint256 public _surcharge2 = 0;
    uint256 public _surcharge3 = 0;

    uint256 private _previousCommunityCharge = _community_charge;
    uint256 private _previousEcoSysFee = _ecoSysFee;
    uint256 private _previousSurcharge1 = _surcharge1;
    uint256 private _previousSurcharge2 = _surcharge2;
    uint256 private _previousSurcharge3 = _surcharge3;

    uint256 public _maxTxAmount = 5000000 * 10**uint256(decimals);

    event Burn(address from, uint256 value);
    event Mint(address from, uint256 value);

    mapping(address => LockDetails) public locks;

    struct LockDetails {
        uint256 startTime;
        uint256 initialLock;
        uint256 lockedToken;
        uint256 remainedToken;
        uint256 monthCount;
    }

    struct TValues {
        uint256 tTransferAmount;
        uint256 tCommunityCharge;
        uint256 tEcoSysFee;
        uint256 tSurcharge1;
        uint256 tSurcharge2;
        uint256 tSurcharge3;
    }

    struct MValues {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rCommunityCharge;
        uint256 tTransferAmount;
        uint256 tCommunityCharge;
        uint256 tEcoSysFee;
        uint256 tSurcharge1;
        uint256 tSurcharge2;
        uint256 tSurcharge3;
    }

    constructor() {
        _rOwned[_msgSender()] = _rTotal;

        
        _isExcludedFromCommunity_charge[owner()] = true;
        _isExcludedFromCommunity_charge[address(this)] = true;

        _isExcludedFromEcoSysFee[owner()] = true;
        _isExcludedFromEcoSysFee[address(this)] = true;

        _isExcludedFromSurcharge1[owner()] = true;
        _isExcludedFromSurcharge1[address(this)] = true;

        _isExcludedFromSurcharge2[owner()] = true;
        _isExcludedFromSurcharge2[address(this)] = true;

        _isExcludedFromSurcharge3[owner()] = true;
        _isExcludedFromSurcharge3[address(this)] = true;

        _cap = _tTotal;
    }

    


    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    


    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromReward[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    



    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    







    function allowance(address ownerAccount, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[ownerAccount][spender];
    }

    













    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    


    function increaseAllowance(address spender, uint256 addedValue)
        external
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    


    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    


    function burn(uint256 value) external onlyOwner {
        require(value > 0, "BEP20: burn amount not valid");
        require(
            value <= balanceOf(msg.sender),
            "BEP20: burn amount exceeds balance"
        );
        _tTotal = _tTotal.sub(value);
        emit Burn(msg.sender, value);
    }

    


    function mint(uint256 value) external onlyOwner {
        require(value > 0, "BEP20: mint amount not valid");
        require(totalSupply() + value <= _cap, "BEP20Capped: cap exceeded");
        _tTotal = _tTotal.add(value);
        emit Mint(msg.sender, value);
    }

    








    function setCharges(
        uint256 community_charge,
        uint256 ecoSysFee,
        uint256 surcharge1,
        uint256 surcharge2,
        uint256 surcharge3
    ) external onlyOwner {
        require(
            community_charge <= (100 * 10**uint256(decimals)),
            "Community Charge % should be less than equal to 100%"
        );
        require(
            ecoSysFee <= (100 * 10**uint256(decimals)),
            "EcoSysFee % should be less than equal to 100%"
        );
        require(
            surcharge1 <= (100 * 10**uint256(decimals)),
            "surcharge1 % should be less than equal to 100%"
        );
        require(
            surcharge2 <= (100 * 10**uint256(decimals)),
            "surcharge2 % should be less than equal to 100%"
        );
        require(
            surcharge3 <= (100 * 10**uint256(decimals)),
            "surcharge3 % should be less than equal to 100%"
        );
        _community_charge = community_charge;
        _ecoSysFee = ecoSysFee;
        _surcharge1 = surcharge1;
        _surcharge2 = surcharge2;
        _surcharge3 = surcharge3;
    }

    







    function setServiceWallet(
        address ecoSysWallet,
        address surcharge_1_wallet,
        address surcharge_2_wallet,
        address surcharge_3_wallet
    ) external onlyOwner {
        require(
            ecoSysWallet != address(0),
            "Ecosystem wallet wallet is not valid"
        );

        
        _ecoSysWallet = ecoSysWallet;
        _surcharge_1_Wallet = surcharge_1_wallet;
        _surcharge_2_Wallet = surcharge_2_wallet;
        _surcharge_3_Wallet = surcharge_3_wallet;

        
        excludeFromCharges(_ecoSysWallet, true, true, true, true, true);
        excludeFromCharges(_surcharge_1_Wallet, true, true, true, true, true);
        excludeFromCharges(_surcharge_2_Wallet, true, true, true, true, true);
        excludeFromCharges(_surcharge_3_Wallet, true, true, true, true, true);

        _isExcludedFromReward[_ecoSysWallet] = true;
        _isExcludedFromReward[_surcharge_1_Wallet] = true;
        _isExcludedFromReward[_surcharge_2_Wallet] = true;
        _isExcludedFromReward[_surcharge_3_Wallet] = true;
    }

    


    function tokenFromReflection(uint256 rAmount)
        private
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    




    function excludeFromCharges(
        address account,
        bool communityCharge,
        bool ecoSysFee,
        bool surcharge1,
        bool surcharge2,
        bool surcharge3
    ) public onlyOwner {
        _isExcludedFromCommunity_charge[account] = communityCharge;
        _isExcludedFromEcoSysFee[account] = ecoSysFee;
        _isExcludedFromSurcharge1[account] = surcharge1;
        _isExcludedFromSurcharge2[account] = surcharge2;
        _isExcludedFromSurcharge3[account] = surcharge3;
    }

    
    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcludedFromReward[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcludedFromReward[account] = true;
        _excluded.push(account);
    }

    


    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
    }

    


    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tCommunityChargeTotal = _tCommunityChargeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (MValues memory) {
        uint256 currentRate = _getRate();
        TValues memory value = _getTValues(tAmount);
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rCommunityCharge
        ) = _getRValues(tAmount, value.tCommunityCharge, currentRate);
        uint256 rEcoSysFee = value.tEcoSysFee.mul(currentRate);
        uint256 rSurcharge1 = value.tSurcharge1.mul(currentRate);
        uint256 rSurcharge2 = value.tSurcharge2.mul(currentRate);
        uint256 rSurcharge3 = value.tSurcharge3.mul(currentRate);
        rTransferAmount = rTransferAmount
            .sub(rEcoSysFee)
            .sub(rSurcharge1)
            .sub(rSurcharge2)
            .sub(rSurcharge3);
        MValues memory mValues = MValues({
            rAmount: rAmount,
            rTransferAmount: rTransferAmount,
            rCommunityCharge: rCommunityCharge,
            tTransferAmount: value.tTransferAmount,
            tCommunityCharge: value.tCommunityCharge,
            tEcoSysFee: value.tEcoSysFee,
            tSurcharge1: value.tSurcharge1,
            tSurcharge2: value.tSurcharge2,
            tSurcharge3: value.tSurcharge3
        });
        return (mValues);
    }

    function _getTValues(uint256 tAmount)
        private
        view
        returns (TValues memory)
    {
        uint256 tCommunityCharge = tAmount.mul(_community_charge).div(10**11);
        uint256 tEcoSysFee = tAmount.mul(_ecoSysFee).div(10**11);
        uint256 tSurcharge1 = tAmount.mul(_surcharge1).div(10**11);
        uint256 tSurcharge2 = tAmount.mul(_surcharge2).div(10**11);
        uint256 tSurcharge3 = tAmount.mul(_surcharge3).div(10**11);
        uint256 tTransferAmountEco = tAmount.sub(tCommunityCharge).sub(
            tEcoSysFee
        );
        uint256 tTransferAmount = tTransferAmountEco
            .sub(tSurcharge1)
            .sub(tSurcharge2)
            .sub(tSurcharge3);
        TValues memory tvalue = TValues({
            tTransferAmount: tTransferAmount,
            tCommunityCharge: tCommunityCharge,
            tEcoSysFee: tEcoSysFee,
            tSurcharge1: tSurcharge1,
            tSurcharge2: tSurcharge2,
            tSurcharge3: tSurcharge3
        });
        return (tvalue);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        uint cacheLength = _excluded.length;
        
        for (uint256 i = 0; i < cacheLength; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    


    
    function takeCharges(
        uint256 tEcoSys,
        uint256 tSurcharge1,
        uint256 tSurcharge2,
        uint256 tSurcharge3
    ) private {
        uint256 currentRate = _getRate();
        if (tEcoSys > 0) {
            uint256 rEcosys = tEcoSys.mul(currentRate);
            _rOwned[_ecoSysWallet] = _rOwned[_ecoSysWallet].add(rEcosys);
            if (_isExcludedFromEcoSysFee[_ecoSysWallet])
                _tOwned[_ecoSysWallet] = _tOwned[_ecoSysWallet].add(tEcoSys);
        }
        if (tSurcharge1 > 0) {
            uint256 rSurcharge1 = tSurcharge1.mul(currentRate);
            _rOwned[_surcharge_1_Wallet] = _rOwned[_surcharge_1_Wallet].add(
                rSurcharge1
            );
            if (_isExcludedFromSurcharge1[_surcharge_1_Wallet])
                _tOwned[_surcharge_1_Wallet] = _tOwned[_surcharge_1_Wallet].add(
                    tSurcharge1
                );
        }
        if (tSurcharge2 > 0) {
            uint256 rSurcharge2 = tSurcharge2.mul(currentRate);
            _rOwned[_surcharge_2_Wallet] = _rOwned[_surcharge_2_Wallet].add(
                rSurcharge2
            );
            if (_isExcludedFromSurcharge1[_surcharge_2_Wallet])
                _tOwned[_surcharge_2_Wallet] = _tOwned[_surcharge_2_Wallet].add(
                    tSurcharge2
                );
        }
        if (tSurcharge3 > 0) {
            uint256 rSurcharge3 = tSurcharge3.mul(currentRate);
            _rOwned[_surcharge_3_Wallet] = _rOwned[_surcharge_3_Wallet].add(
                rSurcharge3
            );
            if (_isExcludedFromSurcharge3[_surcharge_3_Wallet])
                _tOwned[_surcharge_3_Wallet] = _tOwned[_surcharge_3_Wallet].add(
                    tSurcharge3
                );
        }
    }

    




    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(from != to, "Invalid target");
        if (from != owner() && to != owner())
            require(
                amount <= _maxTxAmount,
                "Transfer amount exceeds the maxTxAmount."
            );

        
        
        
        if (locks[from].lockedToken > 0) {
            uint256 withdrawable = balanceOf(from) - locks[from].remainedToken;
            require(
                amount <= withdrawable,
                "Not enough Unlocked token Available"
            );
        }

        
        bool takeCommunityCharge = true;
        bool takeEcosysFee = true;
        bool takeSurcharge1 = true;
        bool takeSurcharge2 = true;
        bool takeSurcharge3 = true;

        
        if (_isExcludedFromCommunity_charge[from]) {
            takeCommunityCharge = false;
        }
        
        if (_isExcludedFromEcoSysFee[from]) {
            takeEcosysFee = false;
        }
        
        if (_isExcludedFromSurcharge1[from]) {
            takeSurcharge1 = false;
        }
        
        if (_isExcludedFromSurcharge2[from]) {
            takeSurcharge2 = false;
        }
        
        if (_isExcludedFromSurcharge3[from]) {
            takeSurcharge3 = false;
        }

        _tokenTransfer(
            from,
            to,
            amount,
            takeCommunityCharge,
            takeEcosysFee,
            takeSurcharge1,
            takeSurcharge2,
            takeSurcharge3
        );
    }

    


    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeCommunityCharge,
        bool takeEcosysFee,
        bool takeSurcharge1,
        bool takeSurcharge2,
        bool takeSurcharge3
    ) private {
        if (!takeCommunityCharge) {
            _previousCommunityCharge = _community_charge;
            _community_charge = 0;
        }

        if (!takeEcosysFee) {
            _previousEcoSysFee = _ecoSysFee;
            _ecoSysFee = 0;
        }

        if (!takeSurcharge1) {
            _previousSurcharge1 = _surcharge1;
            _surcharge1 = 0;
        }

        if (!takeSurcharge2) {
            _previousSurcharge2 = _surcharge2;
            _surcharge2 = 0;
        }

        if (!takeSurcharge3) {
            _previousSurcharge3 = _surcharge3;
            _surcharge3 = 0;
        }

        if (
            _isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]
        ) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (
            !_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
        ) {
            _transferToExcluded(sender, recipient, amount);
        } else if (
            !_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]
        ) {
            _transferStandard(sender, recipient, amount);
        } else if (
            _isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
        ) {
            _transferBothExcluded(sender, recipient, amount);
            
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if (!takeCommunityCharge) _community_charge = _previousCommunityCharge;
        if (!takeEcosysFee) _ecoSysFee = _previousEcoSysFee;
        if (!takeSurcharge1) _surcharge1 = _previousSurcharge1;
        if (!takeSurcharge2) _surcharge2 = _previousSurcharge2;
        if (!takeSurcharge3) _surcharge3 = _previousSurcharge3;
    }

    




    function unlock(address target_) external {
        require(target_ != address(0), "Invalid target");
        require(_msgSender() == target_, "Invalid target");
        uint256 startTime = locks[target_].startTime;
        uint256 lockedToken = locks[target_].lockedToken;
        uint256 remainedToken = locks[target_].remainedToken;
        uint256 monthCount = locks[target_].monthCount;
        uint256 initialLock = locks[target_].initialLock;
        require(remainedToken != 0, "All tokens are unlocked");

        require(
            block.timestamp > startTime + (initialLock * 1 days),
            "UnLocking period is not opened"
        );
        
        uint256 timePassed = block.timestamp -
            (startTime + (initialLock * 1 days));

        uint256 monthNumber = (uint256(timePassed) + (uint256(30 days) - 1)) /
            uint256(30 days);

        uint256 remainedMonth = monthNumber - monthCount;

        if (remainedMonth > 5) remainedMonth = 5;
        require(remainedMonth > 0, "Releasable token till now is released");

        uint256 receivableToken = (lockedToken * (remainedMonth * 20)) / 100;

        locks[target_].monthCount += remainedMonth;
        locks[target_].remainedToken -= receivableToken;

        if (locks[target_].remainedToken == 0) {
            delete locks[target_];
        }
    }

    





    function transferWithLock(
        address recipient,
        uint256 tAmount,
        uint256 initialLock
    ) external onlyOwner {
        require(recipient != address(0), "Invalid target");
        
        require(
            locks[recipient].lockedToken == 0,
            "This address is already in vesting period"
        );
        require(
            initialLock >= 0,
            "timeindays should be greater than or equal to 0"
        );
        _transfer(_msgSender(), recipient, tAmount);
        locks[recipient] = LockDetails(
            block.timestamp,
            initialLock,
            tAmount,
            tAmount,
            0
        );
    }


    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        MValues memory mvalues = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(mvalues.rAmount);
        _doTransfer(mvalues, sender, recipient);
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        MValues memory mvalues = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(mvalues.rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(mvalues.tTransferAmount);
        _doTransfer(mvalues, sender, recipient);
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        MValues memory mvalues = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(mvalues.rAmount);
        _doTransfer(mvalues, sender, recipient);
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        MValues memory mvalues = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(mvalues.rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(mvalues.tTransferAmount);
        _doTransfer(mvalues, sender, recipient);
    }

    function _doTransfer(
        MValues memory mvalues,
        address sender,
        address recipient
    ) private {
        _rOwned[recipient] = _rOwned[recipient].add(mvalues.rTransferAmount);
        takeCharges(
            mvalues.tEcoSysFee,
            mvalues.tSurcharge1,
            mvalues.tSurcharge2,
            mvalues.tSurcharge3
        );
        _reflectFee(mvalues.rCommunityCharge, mvalues.tCommunityCharge);
        emit Transfer(sender, recipient, mvalues.tTransferAmount);
    }
}