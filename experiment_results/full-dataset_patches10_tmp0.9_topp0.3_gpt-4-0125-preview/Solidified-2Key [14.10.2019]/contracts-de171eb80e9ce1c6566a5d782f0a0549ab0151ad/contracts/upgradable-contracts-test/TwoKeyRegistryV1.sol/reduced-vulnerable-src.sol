

pragma solidity ^0.4.24;

library Call {
    function params0(address c, bytes _method) public view returns (uint answer) {
        
        
        bytes4 sig = bytes4(keccak256(_method));
        assembly {
        
            let ptr := mload(0x40)
        
            mstore(ptr,sig)

            let result := call(  
            15000, 
            c, 
            0, 
            ptr, 
            0x04, 
            ptr,  
            0x20) 

            if eq(result, 0) {
                revert(0, 0)
            }

            answer := mload(ptr) 
            mstore(0x40,add(ptr,0x24)) 
        }
    }

    function params1(address c, bytes _method, uint _val) public view returns (uint answer) {
        
        
        bytes4 sig = bytes4(keccak256(_method));
        assembly {
        
            let ptr := mload(0x40)
        
            mstore(ptr,sig)
        
            mstore(add(ptr,0x04), _val)

            let result := call(  
            15000, 
            c, 
            0, 
            ptr, 
            0x24, 
            ptr,  
            0x20) 

            if eq(result, 0) {
                revert(0, 0)
            }

            answer := mload(ptr) 
            mstore(0x40,add(ptr,0x24)) 
        }
    }

    function params2(address c, bytes _method, uint _val1, uint _val2) public view returns (uint answer) {
        
        
        bytes4 sig = bytes4(keccak256(_method));
        assembly {
        
            let ptr := mload(0x40)
        
            mstore(ptr,sig)
        
            mstore(add(ptr,0x04), _val1)
            mstore(add(ptr,0x24), _val2)

            let result := call(  
            15000, 
            c, 
            0, 
            ptr, 
            0x44, 
            ptr,  
            0x20) 

        
        
        
        

            answer := mload(ptr) 
            mstore(0x40,add(ptr,0x20)) 
        }
    }

    function loadAddress(bytes sig, uint idx) public pure returns (address) {
        address influencer;
        idx += 20;
        assembly
        {
            influencer := mload(add(sig, idx))
        }
        return influencer;
    }

    function loadUint8(bytes sig, uint idx) public pure returns (uint8) {
        uint8 weight;
        idx += 1;
        assembly
        {
            weight := mload(add(sig, idx))
        }
        return weight;
    }


    function recoverHash(bytes32 hash, bytes sig, uint idx) public pure returns (address) {
        
        
        
        
        require (sig.length >= 65+idx, 'bad signature length');
        idx += 32;
        bytes32 r;
        assembly
        {
            r := mload(add(sig, idx))
        }

        idx += 32;
        bytes32 s;
        assembly
        {
            s := mload(add(sig, idx))
        }

        idx += 1;
        uint8 v;
        assembly
        {
            v := mload(add(sig, idx))
        }
        if (v >= 32) { 
            v -= 32;
            bytes memory prefix = "\x19Ethereum Signed Message:\n32"; 
            hash = keccak256(abi.encodePacked(prefix, hash));
        }
        if (v <= 1) v += 27;
        require(v==27 || v==28,'bad sig v');
        return ecrecover(hash, v, r, s);

    }

    function recoverSigMemory(bytes sig) private pure returns (address[], address[], uint8[], uint[], uint) {
        uint8 version = loadUint8(sig, 0);
        uint msg_len = (version == 1) ? 1+65+20 : 1+20+20;
        uint n_influencers = (sig.length-21) / (65+msg_len);
        uint8[] memory weights = new uint8[](n_influencers);
        address[] memory keys = new address[](n_influencers);
        if ((sig.length-21) % (65+msg_len) > 0) {
            n_influencers++;
        }
        address[] memory influencers = new address[](n_influencers);
        uint[] memory offsets = new uint[](n_influencers);

        return (influencers, keys, weights, offsets, msg_len);
    }

    function recoverSigParts(bytes sig, address last_address) private pure returns (address[], address[], uint8[], uint[]) {
        
        
        
        
        
        
        
        
        
        
        
        
        
        uint idx = 0;
        uint msg_len;
        uint8[] memory weights;
        address[] memory keys;
        address[] memory influencers;
        uint[] memory offsets;
        (influencers, keys, weights, offsets, msg_len) = recoverSigMemory(sig);
        idx += 1;  

        idx += 20; 
        uint count_influencers = 0;

        while (idx + 65 <= sig.length) {
            offsets[count_influencers] = idx;
            idx += 65;  

            if (idx + msg_len <= sig.length) {  
                weights[count_influencers] = loadUint8(sig, idx);
                require(weights[count_influencers] > 0,'weight not defined (1..255)');  
                idx++;


                if (msg_len == 41)  
                {
                    influencers[count_influencers] = loadAddress(sig, idx);
                    idx += 20;
                    keys[count_influencers] = loadAddress(sig, idx);
                    idx += 20;
                } else if (msg_len == 86)  
                {
                    keys[count_influencers] = loadAddress(sig, idx+65);
                    influencers[count_influencers] = recoverHash(
                        keccak256(
                            abi.encodePacked(
                                keccak256(abi.encodePacked("bytes binding to weight","bytes binding to public")),
                                keccak256(abi.encodePacked(weights[count_influencers],keys[count_influencers]))
                            )
                        ),sig,idx);
                    idx += 65;
                    idx += 20;
                }

            } else {
                
                influencers[count_influencers] = last_address;
            }
            count_influencers++;
        }
        require(idx == sig.length,'illegal message size');

        return (influencers, keys, weights, offsets);
    }

    function recoverSig(bytes sig, address old_key, address last_address) public pure returns (address[], address[], uint8[]) {
        
        
        
        
        require(old_key != address(0),'no public link key');

        address[] memory influencers;
        address[] memory keys;
        uint8[] memory weights;
        uint[] memory offsets;
        (influencers, keys, weights, offsets) = recoverSigParts(sig, last_address);

        
        for(uint i = 0; i < influencers.length; i++) {
            if (i < weights.length) {
                require (recoverHash(keccak256(abi.encodePacked(weights[i], keys[i], influencers[i])),sig,offsets[i]) == old_key, 'illegal signature');
                old_key = keys[i];
            } else {
                
                require (recoverHash(keccak256(abi.encodePacked(influencers[i])),sig,offsets[i]) == old_key, 'illegal last signature');
            }
        }

        return (influencers, keys, weights);
    }
}



pragma solidity ^0.4.24;

contract ITwoKeyMaintainersRegistry {
    function onlyMaintainer(address _sender) public view returns (bool);
}



pragma solidity ^0.4.0;





contract Utils {

    



    function stringToBytes32(
        string memory source
    )
    internal
    pure
    returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

    




    function strConcat(
        string _a,
        string _b,
        string _c
    )
    internal
    pure
    returns (string)
    {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        return string(babcde);
    }


}



pragma solidity ^0.4.24;





interface ITwoKeySingletonesRegistry {

    



    event ProxyCreated(address proxy);


    




    event VersionAdded(string version, address implementation);

    




    function addVersion(string _contractName, string version, address implementation) public;

    





    function getVersion(string _contractName, string version) public view returns (address);
}



pragma solidity ^0.4.24;





contract UpgradeabilityStorage {
    
    ITwoKeySingletonesRegistry internal registry;

    
    address internal _implementation;

    



    function implementation() public view returns (address) {
        return _implementation;
    }
}



pragma solidity ^0.4.24;

contract Upgradeable is UpgradeabilityStorage {
    



    function initialize(address sender) public payable {
        require(msg.sender == address(registry));
    }
}



pragma solidity ^0.4.24;




contract ITwoKeySingletoneRegistryFetchAddress {
    function getContractProxyAddress(string _contractName) public view returns (address);
    function getNonUpgradableContractAddress(string contractName) public view returns (address);
    function getLatestContractVersion(string contractName) public view returns (string);
}



pragma solidity ^0.4.24;


contract ITwoKeySingletonUtils {

    address public TWO_KEY_SINGLETON_REGISTRY;

    
    modifier onlyMaintainer {
        address twoKeyMaintainersRegistry = getAddressFromTwoKeySingletonRegistry("TwoKeyMaintainersRegistry");
        require(ITwoKeyMaintainersRegistry(twoKeyMaintainersRegistry).onlyMaintainer(msg.sender));
        _;
    }

    
    function getAddressFromTwoKeySingletonRegistry(string contractName) internal view returns (address) {
        return ITwoKeySingletoneRegistryFetchAddress(TWO_KEY_SINGLETON_REGISTRY)
        .getContractProxyAddress(contractName);
    }
}



pragma solidity ^0.4.0;

contract IStructuredStorage {

    function setProxyLogicContractAndDeployer(address _proxyLogicContract, address _deployer) external;
    function setProxyLogicContract(address _proxyLogicContract) external;

    
    function getUint(bytes32 _key) external view returns(uint);
    function getString(bytes32 _key) external view returns(string);
    function getAddress(bytes32 _key) external view returns(address);
    function getBytes(bytes32 _key) external view returns(bytes);
    function getBool(bytes32 _key) external view returns(bool);
    function getInt(bytes32 _key) external view returns(int);
    function getBytes32(bytes32 _key) external view returns(bytes32);

    
    function getBytes32Array(bytes32 _key) external view returns (bytes32[]);
    function getAddressArray(bytes32 _key) external view returns (address[]);
    function getUintArray(bytes32 _key) external view returns (uint[]);
    function getIntArray(bytes32 _key) external view returns (int[]);
    function getBoolArray(bytes32 _key) external view returns (bool[]);

    
    function setUint(bytes32 _key, uint _value) external;
    function setString(bytes32 _key, string _value) external;
    function setAddress(bytes32 _key, address _value) external;
    function setBytes(bytes32 _key, bytes _value) external;
    function setBool(bytes32 _key, bool _value) external;
    function setInt(bytes32 _key, int _value) external;
    function setBytes32(bytes32 _key, bytes32 _value) external;

    
    function setBytes32Array(bytes32 _key, bytes32[] _value) external;
    function setAddressArray(bytes32 _key, address[] _value) external;
    function setUintArray(bytes32 _key, uint[] _value) external;
    function setIntArray(bytes32 _key, int[] _value) external;
    function setBoolArray(bytes32 _key, bool[] _value) external;

    
    function deleteUint(bytes32 _key) external;
    function deleteString(bytes32 _key) external;
    function deleteAddress(bytes32 _key) external;
    function deleteBytes(bytes32 _key) external;
    function deleteBool(bytes32 _key) external;
    function deleteInt(bytes32 _key) external;
    function deleteBytes32(bytes32 _key) external;
}



pragma solidity ^0.4.24;

contract ITwoKeyRegistryStorage is IStructuredStorage {

}



pragma solidity ^0.4.24;






contract TwoKeyRegistry is Upgradeable, Utils, ITwoKeySingletonUtils {

    using Call for *;

    bool initialized;

    ITwoKeyRegistryStorage public PROXY_STORAGE_CONTRACT;

    
    event UserNameChanged(address owner, string name);


    function isMaintainer(address x) internal view returns (bool) {
        address twoKeyMaintainersRegistry = getAddressFromTwoKeySingletonRegistry("TwoKeyMaintainersRegistry");
        return ITwoKeyMaintainersRegistry(twoKeyMaintainersRegistry).onlyMaintainer(x);
    }


    


    function setInitialParams(
        address _twoKeySingletonesRegistry,
        address _proxyStorage
    )
    external
    {
        require(initialized == false);

        TWO_KEY_SINGLETON_REGISTRY = _twoKeySingletonesRegistry;
        PROXY_STORAGE_CONTRACT = ITwoKeyRegistryStorage(_proxyStorage);

        initialized = true;
    }



    
    
    
    
    function addNameInternal(
        string _name,
        address _sender
    )
    internal
    {
        bytes32 name = stringToBytes32(_name);

        bytes32 keyHashUserNameToAddress = keccak256("username2currentAddress", name);
        bytes32 keyHashAddressToUserName = keccak256("address2username", _sender);

        
        if (PROXY_STORAGE_CONTRACT.getAddress(keyHashUserNameToAddress) != address(0)) {
            revert();
        }

        PROXY_STORAGE_CONTRACT.setString(keyHashAddressToUserName, _name);
        PROXY_STORAGE_CONTRACT.setAddress(keyHashUserNameToAddress, _sender);

        emit UserNameChanged(_sender, _name);
    }

    


    function addNameAndSetWalletName(
        string _name,
        address _sender,
        string _fullName,
        string _email,
        string _username_walletName,
        bytes _signatureName,
        bytes _signatureWalletName
    )
    public
    {
        require(isMaintainer(msg.sender));
        addName(_name, _sender, _fullName, _email, _signatureName);
        setWalletName(_name, _sender, _username_walletName, _signatureWalletName);
    }

    
    
    
    function addName(
        string _name,
        address _sender,
        string _fullName,
        string _email,
        bytes signature
    )
    public
    {
        require(isMaintainer(msg.sender)== true || msg.sender == address(this));

        string memory concatenatedValues = strConcat(_name,_fullName,_email);
        bytes32 hash = keccak256(abi.encodePacked(keccak256(abi.encodePacked("bytes binding to name")),
            keccak256(abi.encodePacked(concatenatedValues))));
        address message_signer = Call.recoverHash(hash, signature, 0);
        require(message_signer == _sender);
        bytes32 keyHashUsername = keccak256("addressToUserData", "username", _sender);
        bytes32 keyHashFullName = keccak256("addressToUserData", "fullName", _sender);
        bytes32 keyHashEmail = keccak256("addressToUserData", "email", _sender);

        PROXY_STORAGE_CONTRACT.setString(keyHashUsername, _name);
        PROXY_STORAGE_CONTRACT.setString(keyHashFullName, _fullName);
        PROXY_STORAGE_CONTRACT.setString(keyHashEmail, _email);

        addNameInternal(_name, _sender);
    }

    
    
    
    function addNameSigned(
        string _name,
        bytes external_sig
    )
    public
    {
        bytes32 hash = keccak256(abi.encodePacked(keccak256(abi.encodePacked("bytes binding to name")),
            keccak256(abi.encodePacked(_name))));
        address eth_address = Call.recoverHash(hash,external_sig,0);
        require (msg.sender == eth_address || isMaintainer(msg.sender) == true, "only maintainer or user can change name");
        addNameInternal(_name, eth_address);
    }

    function setNoteInternal(
        bytes note,
        address me
    )
    private
    {
        bytes32 keyHashNotes = keccak256("notes", me);
        PROXY_STORAGE_CONTRACT.setBytes(keyHashNotes, note);
    }

    function setNoteByUser(
        bytes note
    )
    public
    {
        
        setNoteInternal(note, msg.sender);
    }


    
    
    
    
    function setWalletName(
        string memory username,
        address _address,
        string memory _username_walletName,
        bytes signature
    )
    public
    {
        require(isMaintainer(msg.sender) == true || msg.sender == address(this));
        require(_address != address(0));
        bytes32 usernameHex = stringToBytes32(username);
        address usersAddress = PROXY_STORAGE_CONTRACT.getAddress(keccak256("username2currentAddress", usernameHex));
        require(usersAddress == _address); 

        string memory concatenatedValues = strConcat(username,_username_walletName,"");

        bytes32 hash = keccak256(abi.encodePacked(keccak256(abi.encodePacked("bytes binding to name")),
            keccak256(abi.encodePacked(concatenatedValues))));
        address message_signer = Call.recoverHash(hash, signature, 0);
        require(message_signer == _address);

        bytes32 walletTag = stringToBytes32(_username_walletName);
        bytes32 keyHashAddress2WalletTag = keccak256("address2walletTag", _address);
        PROXY_STORAGE_CONTRACT.setBytes32(keyHashAddress2WalletTag, walletTag);

        bytes32 keyHashWalletTag2Address = keccak256("walletTag2address", walletTag);
        PROXY_STORAGE_CONTRACT.setAddress(keyHashWalletTag2Address, _address);
    }

    function addPlasma2EthereumInternal(
        bytes sig,
        address eth_address
    )
    private
    {
        
        
        bytes32 hash = keccak256(abi.encodePacked(keccak256(abi.encodePacked("bytes binding to ethereum address")),keccak256(abi.encodePacked(eth_address))));
        address plasma_address = Call.recoverHash(hash,sig,0);
        bytes32 keyHashPlasmaToEthereum = keccak256("plasma2ethereum", plasma_address);
        bytes32 keyHashEthereumToPlasma = keccak256("ethereum2plasma", eth_address);

        require(PROXY_STORAGE_CONTRACT.getAddress(keyHashPlasmaToEthereum) == address(0) || PROXY_STORAGE_CONTRACT.getAddress(keyHashPlasmaToEthereum) == eth_address, "cant change eth=>plasma");

        PROXY_STORAGE_CONTRACT.setAddress(keyHashPlasmaToEthereum, eth_address);
        PROXY_STORAGE_CONTRACT.setAddress(keyHashEthereumToPlasma, plasma_address);
    }

    function addPlasma2EthereumByUser(
        bytes sig
    )
    public
    {
        addPlasma2EthereumInternal(sig, msg.sender);
    }

    function setPlasma2EthereumAndNoteSigned(
        bytes sig,
        bytes note,
        bytes external_sig
    )
    public
    {
        bytes32 hash = keccak256(abi.encodePacked(keccak256(abi.encodePacked("bytes binding to ethereum-plasma")),
            keccak256(abi.encodePacked(sig,note))));
        address eth_address = Call.recoverHash(hash,external_sig,0);
        require (msg.sender == eth_address || isMaintainer(msg.sender), "only maintainer or user can change ethereum-plasma");
        addPlasma2EthereumInternal(sig, eth_address);
        setNoteInternal(note, eth_address);
    }

    
    
    
    
    function getUserName2UserAddress(
        string _name
    )
    external
    view
    returns (address)
    {
        bytes32 name = stringToBytes32(_name);
        return PROXY_STORAGE_CONTRACT.getAddress(keccak256("username2currentAddress", _name));
    }

    
    
    
    
    function getUserAddress2UserName(
        address _sender
    )
    external
    view
    returns (string)
    {
        return PROXY_STORAGE_CONTRACT.getString(keccak256("address2username", _sender));
    }


































    




    function getPlasmaToEthereum(
        address plasma
    )
    public
    view
    returns (address)
    {
        bytes32 keyHashPlasmaToEthereum = keccak256("plasma2ethereum", plasma);
        address ethereum = PROXY_STORAGE_CONTRACT.getAddress(keyHashPlasmaToEthereum);
        if(ethereum!= address(0)) {
            return ethereum;
        }
        return plasma;
    }

    




    function getEthereumToPlasma(
        address ethereum
    )
    public
    view
    returns (address)
    {
        bytes32 keyHashEthereumToPlasma = keccak256("ethereum2plasma", ethereum);
        address plasma = PROXY_STORAGE_CONTRACT.getAddress(keyHashEthereumToPlasma);
        if(plasma != address(0)) {
            return plasma;
        }
        return ethereum;
    }


    




    function checkIfUserExists(
        address _userAddress
    )
    external
    view
    returns (bool)
    {
        string memory username = PROXY_STORAGE_CONTRACT.getString(keccak256("address2username", _userAddress));
        bytes memory tempEmptyStringTest = bytes(username);
        bytes32 keyHashEthereumToPlasma = keccak256("ethereum2plasma", _userAddress);
        address plasma = PROXY_STORAGE_CONTRACT.getAddress(keyHashEthereumToPlasma);
        
        bytes memory savedNotes = PROXY_STORAGE_CONTRACT.getBytes(keccak256("notes", _userAddress));
        bytes32 walletTag = PROXY_STORAGE_CONTRACT.getBytes32(keccak256("address2walletTag", _userAddress));
        if(tempEmptyStringTest.length == 0 || walletTag == 0 || plasma == address(0) || savedNotes.length == 0) {
            return false;
        }
        return true;
    }


    function getUserData(
        address _user
    )
    external
    view
    returns (bytes)
    {
        bytes32 keyHashUsername = keccak256("addressToUserData", "username", _user);
        bytes32 keyHashFullName = keccak256("addressToUserData", "fullName", _user);
        bytes32 keyHashEmail = keccak256("addressToUserData", "email", _user);


        bytes32 username = stringToBytes32(PROXY_STORAGE_CONTRACT.getString(keyHashUsername));
        bytes32 fullName = stringToBytes32(PROXY_STORAGE_CONTRACT.getString(keyHashFullName));
        bytes32 email = stringToBytes32(PROXY_STORAGE_CONTRACT.getString(keyHashEmail));

        return (abi.encodePacked(username, fullName, email));
    }

    function notes(
        address keyAddress
    )
    public
    view
    returns (bytes)
    {
        return PROXY_STORAGE_CONTRACT.getBytes(keccak256("notes", keyAddress));
    }

    function address2walletTag(
        address keyAddress
    )
    public
    view
    returns (bytes32)
    {
        return PROXY_STORAGE_CONTRACT.getBytes32(keccak256("address2walletTag", keyAddress));
    }

    function walletTag2address(
        bytes32 walletTag
    )
    public
    view
    returns (address)
    {
        return PROXY_STORAGE_CONTRACT.getAddress(keccak256("walletTag2address", walletTag));
    }

    function address2username(
        address keyAddress
    )
    public
    view
    returns (string)
    {
        return PROXY_STORAGE_CONTRACT.getString(keccak256("address2username", keyAddress));
    }

    function username2currentAddress(
        bytes32 _username
    )
    public
    view
    returns (address)
    {
        return PROXY_STORAGE_CONTRACT.getAddress(keccak256("username2currentAddress", _username));
    }



}



pragma solidity ^0.4.24;

contract TwoKeyRegistryV1 is TwoKeyRegistry {
    function getMaintainers() public view returns (address[]) {
        address [] memory add = new address[](1);
        add[0] = 0x9aace881c7a80b596d38eaff66edbb5368d2f2c5;
        return add;
    }
}