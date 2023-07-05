// File: ../sc_datasets/DAppSCAN/PeckShield-LensProtocol/lens-protocol-dd137b2dee64c5edf288df297ee4249a0e6c11d4/contracts/libraries/DataTypes.sol

// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.8.10;

/**
 * @title DataTypes
 * @author Lens
 *
 * @notice A standard library of data types used throughout the Lens protocol.
 */
library DataTypes {
    /**
     * @notice An enum containing the different states the protocol can be in, limiting certain actions.
     *
     * @param Unpaused The fully unpaused state.
     * @param PublishingPaused The state where only publication creation functions are paused.
     * @param Paused The fully paused state.
     */
    enum ProtocolState {
        Unpaused,
        PublishingPaused,
        Paused
    }

    /**
     * @notice An enum specifically used in a helper function to easily retrieve the publication type for integrations.
     *
     * @param Post A standard post, having a URI, a collect module but no pointer to another publication.
     * @param Comment A comment, having a URI, a collect module and a pointer to another publication.
     * @param Mirror A mirror, having a pointer to another publication, but no URI or collect module.
     * @param Nonexistent An indicator showing the queried publication does not exist.
     */
    enum PubType {
        Post,
        Comment,
        Mirror,
        Nonexistent
    }

    /**
     * @notice A struct containing the necessary information to reconstruct an EIP-712 typed data signature.
     *
     * @param v The signature's recovery parameter.
     * @param r The signature's r parameter.
     * @param s The signature's s parameter
     * @param deadline The signature's deadline
     */
    struct EIP712Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 deadline;
    }

    /**
     * @notice A struct containing profile data.
     *
     * @param pubCount The number of publications made to this profile.
     * @param followModule The address of the current follow module in use by this profile, can be empty.
     * @param followNFT The address of the followNFT associated with this profile, can be empty..
     * @param handle The profile's associated handle.
     * @param imageURI The URI to be used for the profile's image.
     * @param followNFTURI The URI to be used for the follow NFT.
     */
    struct ProfileStruct {
        uint256 pubCount;
        address followModule;
        address followNFT;
        string handle;
        string imageURI;
        string followNFTURI;
    }

    /**
     * @notice A struct containing data associated with each new publication.
     *
     * @param profileIdPointed The profile token ID this publication points to, for mirrors and comments.
     * @param pubIdPointed The publication ID this publication points to, for mirrors and comments.
     * @param contentURI The URI associated with this publication.
     * @param referenceModule The address of the current reference module in use by this profile, can be empty.
     * @param collectModule The address of the collect module associated with this publication, this exists for all publication.
     * @param collectNFT The address of the collectNFT associated with this publication, if any.
     */
    struct PublicationStruct {
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        string contentURI;
        address referenceModule;
        address collectModule;
        address collectNFT;
    }

    /**
     * @notice A struct containing the parameters required for the `createProfile()` function.
     *
     * @param to The address receiving the profile.
     * @param handle The handle to set for the profile, must be unique and non-empty.
     * @param imageURI The URI to set for the profile image.
     * @param followModule The follow module to use, can be the zero address.
     * @param followModuleData The follow module initialization data, if any.
     * @param followNFTURI The URI to use for the follow NFT.
     */
    struct CreateProfileData {
        address to;
        string handle;
        string imageURI;
        address followModule;
        bytes followModuleData;
        string followNFTURI;
    }

    /**
     * @notice A struct containing the parameters required for the `setFollowModuleWithSig()` function. Parameters are
     * the same as the regular `setFollowModule()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to change the followModule for.
     * @param followModule The followModule to set for the given profile, must be whitelisted.
     * @param followModuleData The data to be passed to the followModule for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct SetFollowModuleWithSigData {
        uint256 profileId;
        address followModule;
        bytes followModuleData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setDispatcherWithSig()` function. Parameters are the same
     * as the regular `setDispatcher()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to set the dispatcher for.
     * @param dispatcher The dispatcher address to set for the profile.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct SetDispatcherWithSigData {
        uint256 profileId;
        address dispatcher;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setProfileImageURIWithSig()` function. Parameters are the same
     * as the regular `setProfileImageURI()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to set the URI for.
     * @param imageURI The URI to set for the given profile image.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct SetProfileImageURIWithSigData {
        uint256 profileId;
        string imageURI;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setFollowNFTURIWithSig()` function. Parameters are the same
     * as the regular `setFollowNFTURI()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile for which to set the followNFT URI.
     * @param followNFTURI The follow NFT URI to set.
     * @param sig The EIP712Signature struct containing the followNFT's associated profile owner's signature.
     */
    struct SetFollowNFTURIWithSigData {
        uint256 profileId;
        string followNFTURI;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `post()` function.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set for this new publication.
     * @param collectModule The collect module to set for this new publication.
     * @param collectModuleData The data to pass to the collect module's initialization.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     */
    struct PostData {
        uint256 profileId;
        string contentURI;
        address collectModule;
        bytes collectModuleData;
        address referenceModule;
        bytes referenceModuleData;
    }

    /**
     * @notice A struct containing the parameters required for the `postWithSig()` function. Parameters are the same as
     * the regular `post()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set for this new publication.
     * @param collectModule The collectModule to set for this new publication.
     * @param collectModuleData The data to pass to the collectModule's initialization.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct PostWithSigData {
        uint256 profileId;
        string contentURI;
        address collectModule;
        bytes collectModuleData;
        address referenceModule;
        bytes referenceModuleData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `comment()` function.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set for this new publication.
     * @param profileIdPointed The profile token ID to point the comment to.
     * @param pubIdPointed The publication ID to point the comment to.
     * @param collectModule The collect module to set for this new publication.
     * @param collectModuleData The data to pass to the collect module's initialization.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     */
    struct CommentData {
        uint256 profileId;
        string contentURI;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        address collectModule;
        bytes collectModuleData;
        address referenceModule;
        bytes referenceModuleData;
    }

    /**
     * @notice A struct containing the parameters required for the `commentWithSig()` function. Parameters are the same as
     * the regular `comment()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set for this new publication.
     * @param profileIdPointed The profile token ID to point the comment to.
     * @param pubIdPointed The publication ID to point the comment to.
     * @param collectModule The collectModule to set for this new publication.
     * @param collectModuleData The data to pass to the collectModule's initialization.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct CommentWithSigData {
        uint256 profileId;
        string contentURI;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        address collectModule;
        bytes collectModuleData;
        address referenceModule;
        bytes referenceModuleData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `mirror()` function.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param profileIdPointed The profile token ID to point the mirror to.
     * @param pubIdPointed The publication ID to point the mirror to.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     */
    struct MirrorData {
        uint256 profileId;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        address referenceModule;
        bytes referenceModuleData;
    }

    /**
     * @notice A struct containing the parameters required for the `mirrorWithSig()` function. Parameters are the same as
     * the regular `mirror()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param profileIdPointed The profile token ID to point the mirror to.
     * @param pubIdPointed The publication ID to point the mirror to.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct MirrorWithSigData {
        uint256 profileId;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        address referenceModule;
        bytes referenceModuleData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `followWithSig()` function. Parameters are the same
     * as the regular `follow()` function, with the follower's (signer) address and an EIP712Signature added.
     *
     * @param follower The follower which is the message signer.
     * @param profileIds The array of token IDs of the profiles to follow.
     * @param datas The array of arbitrary data to pass to the followModules if needed.
     * @param sig The EIP712Signature struct containing the follower's signature.
     */
    struct FollowWithSigData {
        address follower;
        uint256[] profileIds;
        bytes[] datas;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `collectWithSig()` function. Parameters are the same as
     * the regular `collect()` function, with the collector's (signer) address and an EIP712Signature added.
     *
     * @param collector The collector which is the message signer.
     * @param profileId The token ID of the profile that published the publication to collect.
     * @param pubId The publication to collect's publication ID.
     * @param data The arbitrary data to pass to the collectModule if needed.
     * @param sig The EIP712Signature struct containing the collector's signature.
     */
    struct CollectWithSigData {
        address collector;
        uint256 profileId;
        uint256 pubId;
        bytes data;
        EIP712Signature sig;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-LensProtocol/lens-protocol-dd137b2dee64c5edf288df297ee4249a0e6c11d4/contracts/core/storage/LensHubStorage.sol

// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.8.10;

contract LensHubStorage {
    bytes32 internal constant CREATE_PROFILE_WITH_SIG_TYPEHASH =
        0x9ac3269d9abd6f8c5e850e07f21b199079e8a5cc4a55466d8c96ab0c4a5be403;
    // keccak256(
    // 'CreateProfileWithSig(string handle,string uri,address followModule,bytes followModuleData,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant SET_FOLLOW_MODULE_WITH_SIG_TYPEHASH =
        0x6f3f6455a608af1cc57ef3e5c0a49deeb88bba264ec8865b798ff07358859d4b;
    // keccak256(
    // 'SetFollowModuleWithSig(uint256 profileId,address followModule,bytes followModuleData,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant SET_FOLLOW_NFT_URI_WITH_SIG_TYPEHASH =
        0xd8d76e8b2b26e1ebe72def13fb559a68561ef064055b0de01f955bc26e25d42f;
    // keccak256(
    // 'SetFollowNFTURIWithSig(uint256 profileId,string followNFTURI,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant SET_DISPATCHER_WITH_SIG_TYPEHASH =
        0x77ba3e9f5fa75343bbad1241fb539a0064de97694b47d463d1eb5c54aba11f0f;
    // keccak256(
    // 'SetDispatcherWithSig(uint256 profileId,address dispatcher,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant SET_PROFILE_IMAGE_URI_WITH_SIG_TYPEHASH =
        0x5b9860bd835e648945b22d053515bc1f53b7d9fab4b23b1b49db15722e945d14;
    // keccak256(
    // 'SetProfileImageURIWithSig(uint256 profileId,string imageURI,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant POST_WITH_SIG_TYPEHASH =
        0xfb8f057542e7551386ead0b891a45f102af78c47f8cc58b4a919c7cfeccd0e1e;
    // keccak256(
    // 'PostWithSig(uint256 profileId,string contentURI,address collectModule,bytes collectModuleData,address referenceModule,bytes referenceModuleData,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant COMMENT_WITH_SIG_TYPEHASH =
        0xb30910150df56294e05b2d03e181803697a2b935abb1b9bdddde9310f618fe9b;
    // keccak256(
    // 'CommentWithSig(uint256 profileId,string contentURI,uint256 profileIdPointed,uint256 pubIdPointed,address collectModule,bytes collectModuleData,address referenceModule,bytes referenceModuleData,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant MIRROR_WITH_SIG_TYPEHASH =
        0x64f4578fc098f96a2450fbe601cb8c5318ebeb2ff72d2031a36be1ff6932d5ee;
    // keccak256(
    // 'MirrorWithSig(uint256 profileId,uint256 profileIdPointed,uint256 pubIdPointed,address referenceModule,bytes referenceModuleData,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant FOLLOW_WITH_SIG_TYPEHASH =
        0xfb6b7f1cd1b38daf3822aff0abbe78124db5d62a4748bcff007c15ccd6d30bc5;
    // keccak256(
    // 'FollowWithSig(uint256[] profileIds,bytes[] datas,uint256 nonce,uint256 deadline)'
    // );
    bytes32 internal constant COLLECT_WITH_SIG_TYPEHASH =
        0x7f9b4ea1fc678b4fda1611ac5cbd28f339e235d89b1540635e9b2e0223a3c101;
    // keccak256(
    // 'CollectWithSig(uint256 profileId,uint256 pubId,bytes data,uint256 nonce,uint256 deadline)'
    // );

    mapping(address => bool) internal _profileCreatorWhitelisted;
    mapping(address => bool) internal _followModuleWhitelisted;
    mapping(address => bool) internal _collectModuleWhitelisted;
    mapping(address => bool) internal _referenceModuleWhitelisted;

    mapping(uint256 => address) internal _dispatcherByProfile;
    mapping(bytes32 => uint256) internal _profileIdByHandleHash;
    mapping(uint256 => DataTypes.ProfileStruct) internal _profileById;
    mapping(uint256 => mapping(uint256 => DataTypes.PublicationStruct)) internal _pubByIdByProfile;

    uint256 internal _profileCounter;
    address internal _governance;
    address internal _emergencyAdmin;
}
