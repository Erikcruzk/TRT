



pragma solidity 0.8.13;




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






pragma solidity 0.8.13;










interface IERC2612 {
    





















    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    






    function nonces(address owner) external view returns (uint256);
    
    


    function DOMAIN_SEPARATOR() external view returns (bytes32);
}




pragma solidity 0.8.13;


interface IERC3156FlashBorrower {

    








    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}




pragma solidity 0.8.13;

interface IERC3156FlashLender {

    




    function maxFlashLoan(
        address token
    ) external view returns (uint256);

    





    function flashFee(
        address token,
        uint256 amount
    ) external view returns (uint256);

    






    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}






pragma solidity 0.8.13;








interface IWASTR is IERC20, IERC2612, IERC3156FlashLender {

    
    function flashMinted() external view returns(uint256);

    
    
    function deposit() external payable;

    
    
    function depositTo(address to) external payable;

    
    
    
    
    function withdraw(uint256 value) external;

    
    
    
    
    function withdrawTo(address payable to, uint256 value) external;

    
    
    
    
    
    
    
    function withdrawFrom(address from, address payable to, uint256 value) external;

    
    
    
    
    
    function depositToAndCall(address to, bytes calldata data) external payable returns (bool);

    
    
    
    
    
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);

    
    
    
    
    
    
    
    
    function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
}





pragma solidity 0.8.13;









abstract contract Ownable {
    mapping (address => uint) public owners;

    event OwnershipChanged(address indexed owner, uint indexed isOwned);

    


    constructor () {
        owners[msg.sender] = 1;
        emit OwnershipChanged(msg.sender, 1);
    }

    


    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    


    function isOwner() public view returns (bool) {
        return owners[msg.sender] != 0;
    }

    


    function setOwnership(address _address, uint _isOwned) public onlyOwner {
        owners[_address] = _isOwned;
        emit OwnershipChanged(_address, _isOwned);
    }
}



































































pragma solidity 0.8.13;



interface ITransferReceiver {
    function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
}

interface IApprovalReceiver {
    function onTokenApproval(address, uint, bytes calldata) external returns (bool);
}




contract WASTR is IWASTR, Ownable {

    string public constant name = "Wrapped Astar";
    string public constant symbol = "WASTR";
    uint8  public constant decimals = 18;

    bytes32 public immutable CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    bytes32 public immutable PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    uint256 public immutable deploymentChainId;
    bytes32 private immutable _DOMAIN_SEPARATOR;

    
    mapping (address => uint256) public override balanceOf;

    
    
    mapping (address => uint256) public override nonces;

    
    mapping (address => mapping (address => uint256)) public override allowance;

    
    uint256 public override flashMinted;
    
    
    constructor() Ownable() {
        uint256 chainId;
        assembly {chainId := chainid()}
        deploymentChainId = chainId;
        _DOMAIN_SEPARATOR = _calculateDomainSeparator(chainId);
    }

    
    function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );
    }

    
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        uint256 chainId;
        assembly {chainId := chainid()}
        return chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
    }
    
    
    function totalSupply() external view override returns (uint256) {
        return address(this).balance + flashMinted;
    }

    
    
    receive() external payable {
        
        balanceOf[msg.sender] += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    
    
    function deposit() external override payable {
        
        balanceOf[msg.sender] += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    
    
    function depositTo(address to) external override payable {
        
        balanceOf[to] += msg.value;
        emit Transfer(address(0), to, msg.value);
    }

    
    
    
    
    
    function depositToAndCall(address to, bytes calldata data) external override payable returns (bool success) {
        
        balanceOf[to] += msg.value;
        emit Transfer(address(0), to, msg.value);

        return ITransferReceiver(to).onTokenTransfer(msg.sender, msg.value, data);
    }

    
    function maxFlashLoan(address token) external view override returns (uint256) {
        return token == address(this) ? type(uint112).max - flashMinted : 0; 
    }

    
    function flashFee(address token, uint256) external view override returns (uint256) {
        require(token == address(this), "WASTR: flash mint only WASTR");
        return 0;
    }

    
    
    
    
    
    
    
    
    
    
    
    function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 value, bytes calldata data) external override returns (bool) {
        require(token == address(this), "WASTR: flash mint only WASTR");
        require(value <= type(uint112).max, "WASTR: individual loan limit exceeded");
        flashMinted = flashMinted + value;
        require(flashMinted <= type(uint112).max, "WASTR: total loan limit exceeded");
        
        
        balanceOf[address(receiver)] += value;
        emit Transfer(address(0), address(receiver), value);

        require(
            receiver.onFlashLoan(msg.sender, address(this), value, 0, data) == CALLBACK_SUCCESS,
            "WASTR: flash loan failed"
        );
        
        
        uint256 allowed = allowance[address(receiver)][address(this)];
        if (allowed != type(uint256).max) {
            require(allowed >= value, "WASTR: request exceeds allowance");
            uint256 reduced = allowed - value;
            allowance[address(receiver)][address(this)] = reduced;
            emit Approval(address(receiver), address(this), reduced);
        }

        
        uint256 balance = balanceOf[address(receiver)];
        require(balance >= value, "WASTR: burn amount exceeds balance");
        balanceOf[address(receiver)] = balance - value;
        emit Transfer(address(receiver), address(0), value);
        
        flashMinted = flashMinted - value;
        return true;
    }

    
    
    
    
    function withdraw(uint256 value) external override {
        
        uint256 balance = balanceOf[msg.sender];
        require(balance >= value, "WASTR: burn amount exceeds balance");
        balanceOf[msg.sender] = balance - value;
        emit Transfer(msg.sender, address(0), value);

        
        (bool success, ) = msg.sender.call{value: value}("");
        require(success, "WASTR: ASTR transfer failed");
    }

    
    
    
    
    function withdrawTo(address payable to, uint256 value) external override {
        
        uint256 balance = balanceOf[msg.sender];
        require(balance >= value, "WASTR: burn amount exceeds balance");
        balanceOf[msg.sender] = balance - value;
        emit Transfer(msg.sender, address(0), value);

        
        (bool success, ) = to.call{value: value}("");
        require(success, "WASTR: ASTR transfer failed");
    }

    
    
    
    
    
    
    
    function withdrawFrom(address from, address payable to, uint256 value) external override {
        if (from != msg.sender) {
            
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= value, "WASTR: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
                emit Approval(from, msg.sender, reduced);
            }
        }
        
        
        uint256 balance = balanceOf[from];
        require(balance >= value, "WASTR: burn amount exceeds balance");
        balanceOf[from] = balance - value;
        emit Transfer(from, address(0), value);

        
        (bool success, ) = to.call{value: value}("");
        require(success, "WASTR: Ether transfer failed");
    }

    
    
    
    function approve(address spender, uint256 value) external override returns (bool) {
        
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);

        return true;
    }

    
    
    
    
    
    function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
        
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        
        return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
    }

    
    
    
    
    
    
    
    
    
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
        require(block.timestamp <= deadline, "WASTR: Expired permit");

        uint256 chainId;
        assembly {chainId := chainid()}

        bytes32 hashStruct = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                value,
                nonces[owner]++,
                deadline));

        bytes32 hash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId),
                hashStruct));

        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0) && signer == owner, "WASTR: invalid permit");

        
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    
    
    
    
    
    
    function transfer(address to, uint256 value) external virtual override returns (bool) {
        
        if (to != address(0)) { 
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WASTR: transfer amount exceeds balance");

            balanceOf[msg.sender] = balance - value;
            balanceOf[to] += value;
            emit Transfer(msg.sender, to, value);
        } else { 
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WASTR: burn amount exceeds balance");
            balanceOf[msg.sender] = balance - value;
            emit Transfer(msg.sender, address(0), value);
            
            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WASTR: ASTR transfer failed");
        }
        
        return true;
    }

    
    
    
    
    
    
    
    
    
    
    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        if (from != msg.sender) {
            
            uint256 allowed = allowance[from][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= value, "WASTR: request exceeds allowance");
                uint256 reduced = allowed - value;
                allowance[from][msg.sender] = reduced;
                emit Approval(from, msg.sender, reduced);
            }
        }
        
        
        if (to != address(0)) { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WASTR: transfer amount exceeds balance");

            balanceOf[from] = balance - value;
            balanceOf[to] += value;
            emit Transfer(from, to, value);
        } else { 
            uint256 balance = balanceOf[from];
            require(balance >= value, "WASTR: burn amount exceeds balance");
            balanceOf[from] = balance - value;
            emit Transfer(from, address(0), value);
        
            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WASTR: ASTR transfer failed");
        }
        
        return true;
    }

    
    
    
    
    
    
    
    
    function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
        
        if (to != address(0)) { 
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WASTR: transfer amount exceeds balance");

            balanceOf[msg.sender] = balance - value;
            balanceOf[to] += value;
            emit Transfer(msg.sender, to, value);
        } else { 
            uint256 balance = balanceOf[msg.sender];
            require(balance >= value, "WASTR: burn amount exceeds balance");
            balanceOf[msg.sender] = balance - value;
            emit Transfer(msg.sender, address(0), value);
        
            (bool success, ) = msg.sender.call{value: value}("");
            require(success, "WASTR: ASTR transfer failed");
        }

        return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
    }
}