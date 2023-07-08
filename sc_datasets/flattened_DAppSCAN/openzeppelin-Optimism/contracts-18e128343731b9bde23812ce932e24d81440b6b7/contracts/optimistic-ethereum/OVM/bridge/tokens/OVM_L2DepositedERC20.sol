// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/bridge/tokens/iOVM_L1TokenGateway.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
pragma experimental ABIEncoderV2;

/**
 * @title iOVM_L1TokenGateway
 */
interface iOVM_L1TokenGateway {

    /**********
     * Events *
     **********/

    event DepositInitiated(
        address indexed _from,
        address _to,
        uint256 _amount
    );
  
    event WithdrawalFinalized(
        address indexed _to,
        uint256 _amount
    );


    /********************
     * Public Functions *
     ********************/

    function deposit(
        uint _amount
    )
        external;

    function depositTo(
        address _to,
        uint _amount
    )
        external;


    /*************************
     * Cross-chain Functions *
     *************************/

    function finalizeWithdrawal(
        address _to,
        uint _amount
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/standards/IUniswapV2ERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.8.0;

interface IUniswapV2ERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/standards/UniSafeMath.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.8.0;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library UniSafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/standards/UniswapV2ERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.8.0;


contract UniswapV2ERC20 is IUniswapV2ERC20 {
    using UniSafeMath for uint;

    string public override name;
    string public override symbol;
    uint8 public constant override decimals = 18;
    uint public override totalSupply;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;

    bytes32 public override DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant override PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public override nonces;

    constructor(
    string memory _name,
        string memory _symbol
    ) {
        name = _name;
        symbol = _symbol;

        uint chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external override returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/bridge/tokens/iOVM_L2DepositedToken.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
pragma experimental ABIEncoderV2;

/**
 * @title iOVM_L2DepositedToken
 */
interface iOVM_L2DepositedToken {

    /**********
     * Events *
     **********/

    event WithdrawalInitiated(
        address indexed _from,
        address _to,
        uint256 _amount
    );

    event DepositFinalized(
        address indexed _to,
        uint256 _amount
    );    


    /********************
     * Public Functions *
     ********************/

    function withdraw(
        uint _amount
    )
        external;

    function withdrawTo(
        address _to,
        uint _amount
    )
        external;


    /*************************
     * Cross-chain Functions *
     *************************/

    function finalizeDeposit(
        address _to,
        uint _amount
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/bridge/messaging/iAbs_BaseCrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @title iAbs_BaseCrossDomainMessenger
 */
interface iAbs_BaseCrossDomainMessenger {

    /**********
     * Events *
     **********/
    event SentMessage(bytes message);
    event RelayedMessage(bytes32 msgHash);

    /**********************
     * Contract Variables *
     **********************/
    function xDomainMessageSender() external view returns (address);

    /********************
     * Public Functions *
     ********************/

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/bridge/OVM_CrossDomainEnabled.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
/* Interface Imports */

/**
 * @title OVM_CrossDomainEnabled
 * @dev Helper contract for contracts performing cross-domain communications
 *
 * Compiler used: defined by inheriting contract
 * Runtime target: defined by inheriting contract
 */
contract OVM_CrossDomainEnabled {
    // Messenger contract used to send and recieve messages from the other domain.
    address public messenger;

    /***************
     * Constructor *
     ***************/    
    constructor(
        address _messenger
    ) {
        messenger = _messenger;
    }

    /**********************
     * Function Modifiers *
     **********************/

    /**
     * @notice Enforces that the modified function is only callable by a specific cross-domain account.
     * @param _sourceDomainAccount The only account on the originating domain which is authenticated to call this function.
     */
    modifier onlyFromCrossDomainAccount(
        address _sourceDomainAccount
    ) {
        require(
            msg.sender == address(getCrossDomainMessenger()),
            "OVM_XCHAIN: messenger contract unauthenticated"
        );

        require(
            getCrossDomainMessenger().xDomainMessageSender() == _sourceDomainAccount,
            "OVM_XCHAIN: wrong sender of cross-domain message"
        );

        _;
    }
    
    /**********************
     * Internal Functions *
     **********************/

    /**
     * @notice Gets the messenger, usually from storage.  This function is exposed in case a child contract needs to override.
     * @return The address of the cross-domain messenger contract which should be used. 
     */
    function getCrossDomainMessenger()
        internal
        virtual
        returns(
            iAbs_BaseCrossDomainMessenger
        )
    {
        return iAbs_BaseCrossDomainMessenger(messenger);
    }

    /**
     * @notice Sends a message to an account on another domain
     * @param _crossDomainTarget The intended recipient on the destination domain
     * @param _data The data to send to the target (usually calldata to a function with `onlyFromCrossDomainAccount()`)
     * @param _gasLimit The gasLimit for the receipt of the message on the target domain.
     */
    function sendCrossDomainMessage(
        address _crossDomainTarget,
        bytes memory _data,
        uint32 _gasLimit
    ) internal {
        getCrossDomainMessenger().sendMessage(_crossDomainTarget, _data, _gasLimit);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/bridge/tokens/Abs_L2DepositedToken.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Interface Imports */


/* Library Imports */

/**
 * @title Abs_L2DepositedToken
 * @dev An L2 Deposited Token is an L2 representation of funds which were deposited from L1.
 * Usually contract mints new tokens when it hears about deposits into the L1 ERC20 gateway.
 * This contract also burns the tokens intended for withdrawal, informing the L1 gateway to release L1 funds.
 *
 * NOTE: This abstract contract gives all the core functionality of a deposited token implementation except for the
 * token's internal accounting itself.  This gives developers an easy way to implement children with their own token code.
 *
 * Compiler used: optimistic-solc
 * Runtime target: OVM
 */
abstract contract Abs_L2DepositedToken is iOVM_L2DepositedToken, OVM_CrossDomainEnabled {

    /*******************
     * Contract Events *
     *******************/

    event Initialized(iOVM_L1TokenGateway _l1TokenGateway);

    /********************************
     * External Contract References *
     ********************************/

    iOVM_L1TokenGateway public l1TokenGateway;

    /********************************
     * Constructor & Initialization *
     ********************************/

    /**
     * @param _l2CrossDomainMessenger L1 Messenger address being used for cross-chain communications.
     */
    constructor(
        address _l2CrossDomainMessenger
    )
        OVM_CrossDomainEnabled(_l2CrossDomainMessenger)
    {}

    /**
     * @dev Initialize this contract with the L1 token gateway address.
     * The flow: 1) this contract gets deployed on L2, 2) the L1
     * gateway is deployed with addr from (1), 3) L1 gateway address passed here.
     *
     * @param _l1TokenGateway Address of the corresponding L1 gateway deployed to the main chain
     */

    function init(
        iOVM_L1TokenGateway _l1TokenGateway
    )
        public
    {
        require(address(l1TokenGateway) == address(0), "Contract has already been initialized");

        l1TokenGateway = _l1TokenGateway;
        
        emit Initialized(l1TokenGateway);
    }

    /**********************
     * Function Modifiers *
     **********************/

    modifier onlyInitialized() {
        require(address(l1TokenGateway) != address(0), "Contract has not yet been initialized");
        _;
    }

    /********************************
     * Overridable Accounting logic *
     ********************************/

    // Default gas value which can be overridden if more complex logic runs on L2.
    uint32 constant DEFAULT_FINALIZE_WITHDRAWAL_L1_GAS = 100000;

    /**
     * @dev Core logic to be performed when a withdrawal from L2 is initialized.
     * In most cases, this will simply burn the withdrawn L2 funds.
     *
     * param _to Address being withdrawn to
     * param _amount Amount being withdrawn
     */

    function _handleInitiateWithdrawal(
        address, // _to,
        uint // _amount
    )
        internal
        virtual
    {
        revert("Accounting must be implemented by child contract.");
    }

    /**
     * @dev Core logic to be performed when a deposit from L2 is finalized on L2.
     * In most cases, this will simply _mint() to credit L2 funds to the recipient.
     *
     * param _to Address being deposited to on L2
     * param _amount Amount which was deposited on L1
     */
    function _handleFinalizeDeposit(
        address, // _to
        uint // _amount
    )
        internal
        virtual
    {
        revert("Accounting must be implemented by child contract.");
    }

    /**
     * @dev Overridable getter for the *L1* gas limit of settling the withdrawal, in the case it may be
     * dynamic, and the above public constant does not suffice.
     *
     */

    function getFinalizeWithdrawalL1Gas()
        public
        view
        virtual
        returns(
            uint32
        )
    {
        return DEFAULT_FINALIZE_WITHDRAWAL_L1_GAS;
    }


    /***************
     * Withdrawing *
     ***************/

    /**
     * @dev initiate a withdraw of some tokens to the caller's account on L1
     * @param _amount Amount of the token to withdraw
     */
    function withdraw(
        uint _amount
    )
        external
        override
        onlyInitialized()
    {
        _initiateWithdrawal(msg.sender, _amount);
    }

    /**
     * @dev initiate a withdraw of some token to a recipient's account on L1
     * @param _to L1 adress to credit the withdrawal to
     * @param _amount Amount of the token to withdraw
     */
    function withdrawTo(
        address _to,
        uint _amount
    )
        external
        override
        onlyInitialized()
    {
        _initiateWithdrawal(_to, _amount);
    }

    /**
     * @dev Performs the logic for deposits by storing the token and informing the L2 token Gateway of the deposit.
     *
     * @param _to Account to give the withdrawal to on L1
     * @param _amount Amount of the token to withdraw
     */
    function _initiateWithdrawal(
        address _to,
        uint _amount
    )
        internal
    {
        // Call our withdrawal accounting handler implemented by child contracts (usually a _burn)
        _handleInitiateWithdrawal(_to, _amount);

        // Construct calldata for l1TokenGateway.finalizeWithdrawal(_to, _amount)
        bytes memory data = abi.encodeWithSelector(
            iOVM_L1TokenGateway.finalizeWithdrawal.selector,
            _to,
            _amount
        );

        // Send message up to L1 gateway
        sendCrossDomainMessage(
            address(l1TokenGateway),
            data,
            getFinalizeWithdrawalL1Gas()
        );

        emit WithdrawalInitiated(msg.sender, _to, _amount);
    }

    /************************************
     * Cross-chain Function: Depositing *
     ************************************/

    /**
     * @dev Complete a deposit from L1 to L2, and credits funds to the recipient's balance of this 
     * L2 token. 
     * This call will fail if it did not originate from a corresponding deposit in OVM_l1TokenGateway. 
     *
     * @param _to Address to receive the withdrawal at
     * @param _amount Amount of the token to withdraw
     */
    function finalizeDeposit(
        address _to,
        uint _amount
    )
        external
        override 
        onlyInitialized()
        onlyFromCrossDomainAccount(address(l1TokenGateway))
    {
        _handleFinalizeDeposit(_to, _amount);
        emit DepositFinalized(_to, _amount);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/bridge/tokens/OVM_L2DepositedERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Interface Imports */

/* Contract Imports */

/* Library Imports */

/**
 * @title OVM_L2DepositedERC20
 * @dev The L2 Deposited ERC20 is an ERC20 implementation which represents L1 assets deposited into L2.
 * This contract mints new tokens when it hears about deposits into the L1 ERC20 gateway.
 * This contract also burns the tokens intended for withdrawal, informing the L1 gateway to release L1 funds.
 *
 * NOTE: This contract implements the Abs_L2DepositedToken contract using Uniswap's ERC20 as the implementation.
 * Alternative implementations can be used in this similar manner.
 *
 * Compiler used: optimistic-solc
 * Runtime target: OVM
 */
contract OVM_L2DepositedERC20 is Abs_L2DepositedToken, UniswapV2ERC20 {

    /***************
     * Constructor *
     ***************/

    /**
     * @param _l2CrossDomainMessenger Cross-domain messenger used by this contract.
     * @param _name ERC20 name
     * @param _symbol ERC20 symbol
     */
    constructor(
        address _l2CrossDomainMessenger,
        string memory _name,
        string memory _symbol
    )
        Abs_L2DepositedToken(_l2CrossDomainMessenger)
        UniswapV2ERC20(_name, _symbol)
    {}

    // When a withdrawal is initiated, we burn the withdrawer's funds to prevent subsequent L2 usage.
    function _handleInitiateWithdrawal(
        address, // _to,
        uint _amount
    )
        internal
        override
    {
        _burn(msg.sender, _amount);
    }

    // When a deposit is finalized, we credit the account on L2 with the same amount of tokens.
    function _handleFinalizeDeposit(
        address _to,
        uint _amount
    )
        internal
        override
    {
        _mint(_to, _amount);
    }
}
