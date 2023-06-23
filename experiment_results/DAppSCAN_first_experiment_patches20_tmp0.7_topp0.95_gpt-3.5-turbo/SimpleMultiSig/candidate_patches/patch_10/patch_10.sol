// SWC-Outdated Compiler Version: L2
pragma solidity ^0.5.16;

contract SimpleMultiSig {

    // EIP712 Precomputed hashes:
    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
    bytes32 constant EIP712DOMAINTYPE_HASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)"
    );

    // keccak256("Simple MultiSig")
    bytes32 constant NAME_HASH = keccak256("Simple MultiSig");

    // keccak256("1")
    bytes32 constant VERSION_HASH = keccak256("1");

    // keccak256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)")
    bytes32 constant TXTYPE_HASH = keccak256(
        "MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)"
    );

    bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;

    uint public nonce; // (only) mutable state
    uint public threshold; // immutable state
    mapping(address => bool) public isOwner; // immutable state
    address[] public ownersArr; // immutable state

    bytes32 DOMAIN_SEPARATOR; // hash for EIP712, computed from contract address

    // Note that owners_ must be strictly increasing, in order to prevent duplicates
    constructor(uint threshold_, address[] memory owners_, uint chainId) public {
        require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ > 0);

        address lastAdd = address(0);
        for (uint i = 0; i < owners_.length; i++) {
            require(owners_[i] > lastAdd);
            isOwner[owners_[i]] = true;
            lastAdd = owners_[i];
        }
        ownersArr = owners_;
        threshold = threshold_;

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712DOMAINTYPE_HASH,
                NAME_HASH,
                VERSION_HASH,
                chainId,
                address(this),
                SALT
            )
        );
    }

    // Note that address recovered from signatures must be strictly increasing, in order to prevent duplicates
    function execute(
        uint8[] memory sigV,
        bytes32[] memory sigR,
        bytes32[] memory sigS,
        address destination,
        uint256 value,
        bytes memory data,
        address executor,
        uint256 gasLimit
    ) public {
        require(sigR.length == threshold);
        require(sigR.length == sigS.length && sigR.length == sigV.length);
        require(executor == msg.sender || executor == address(0));

        // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
        bytes32 txInputHash = keccak256(
            abi.encode(
                TXTYPE_HASH,
                destination,
                value,
                keccak256(data),
                nonce,
                executor,
                gasLimit
            )
        );
        bytes32 totalHash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash)
        );

        address lastAdd = address(0); // cannot have address(0) as an owner
        for (uint i = 0; i < threshold; i++) {
            address recovered = ecrecover(totalHash, sigV[i], sigR[i], sigS[i]);
            require(recovered > lastAdd && isOwner[recovered]);
            lastAdd = recovered;
        }

        // If we make it here all signatures are accounted for.
        // The address.call() syntax is no longer recommended, see:
        // https://github.com/ethereum/solidity/issues/2884
        nonce = nonce + 1;
        (bool success, ) = address(destination).call.value(value)(data);
        require(success);
    }

    function() external payable {}
}