

pragma solidity 0.4.24;






contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;

}



pragma solidity 0.4.24;





contract Ownable is EternalStorage {
    




    event OwnershipTransferred(address previousOwner, address newOwner);

    


    modifier onlyOwner() {
        require(msg.sender == owner());
        _;
    }

    



    function owner() public view returns (address) {
        return addressStorage[keccak256(abi.encodePacked("owner"))];
    }

    



    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        setOwner(newOwner);
    }

    


    function setOwner(address newOwner) internal {
        emit OwnershipTransferred(owner(), newOwner);
        addressStorage[keccak256(abi.encodePacked("owner"))] = newOwner;
    }
}



pragma solidity 0.4.24;






library SafeMath {

  


  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  


  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    
    uint256 c = a / b;
    
    return c;
  }

  


  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  


  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}



pragma solidity 0.4.24;



contract BaseBridgeValidators is EternalStorage, Ownable {
    using SafeMath for uint256;

    address public constant F_ADDR = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;

    event ValidatorAdded (address indexed validator);
    event ValidatorRemoved (address indexed validator);
    event RequiredSignaturesChanged (uint256 requiredSignatures);

    function setRequiredSignatures(uint256 _requiredSignatures)
    external
    onlyOwner
    {
        require(validatorCount() >= _requiredSignatures);
        require(_requiredSignatures != 0);
        uintStorage[keccak256(abi.encodePacked("requiredSignatures"))] = _requiredSignatures;
        emit RequiredSignaturesChanged(_requiredSignatures);
    }

    function getBridgeValidatorsInterfacesVersion()
    public
    pure
    returns (uint64 major, uint64 minor, uint64 patch)
    {
        return (2, 2, 0);
    }

    function validatorList() public view returns (address[]) {
        address [] memory list = new address[](validatorCount());
        uint256 counter = 0;
        address nextValidator = getNextValidator(F_ADDR);
        require(nextValidator != address(0));

        while (nextValidator != F_ADDR) {
            list[counter] = nextValidator;
            nextValidator = getNextValidator(nextValidator);
            counter++;

            if (nextValidator == address(0) ) {
                revert();
            }
        }

        return list;
    }

    function _addValidator(address _validator) internal {
        require(_validator != address(0) && _validator != F_ADDR);
        require(!isValidator(_validator));

        address firstValidator = getNextValidator(F_ADDR);
        require(firstValidator != address(0));
        setNextValidator(_validator, firstValidator);
        setNextValidator(F_ADDR, _validator);
        setValidatorCount(validatorCount().add(1));
    }

    function _removeValidator(address _validator) internal {
        require(validatorCount() > requiredSignatures());
        require(isValidator(_validator));
        address validatorsNext = getNextValidator(_validator);
        address index = F_ADDR;
        address next = getNextValidator(index);
        require(next != address(0));

        while (next != _validator) {
            index = next;
            next = getNextValidator(index);

            if (next == F_ADDR || next == address(0) ) {
                revert();
            }
        }

        setNextValidator(index, validatorsNext);
        deleteItemFromAddressStorage("validatorsList", _validator);
        setValidatorCount(validatorCount().sub(1));
    }

    function requiredSignatures() public view returns (uint256) {
        return uintStorage[keccak256(abi.encodePacked("requiredSignatures"))];
    }

    function validatorCount() public view returns (uint256) {
        return uintStorage[keccak256(abi.encodePacked("validatorCount"))];
    }

    function isValidator(address _validator) public view returns (bool) {
        return _validator != F_ADDR && getNextValidator(_validator) != address(0);
    }

    function isInitialized() public view returns (bool) {
        return boolStorage[keccak256(abi.encodePacked("isInitialized"))];
    }

    function deployedAtBlock() public view returns (uint256) {
        return uintStorage[keccak256("deployedAtBlock")];
    }

    function getNextValidator(address _address) public view returns (address) {
        return addressStorage[keccak256(abi.encodePacked("validatorsList", _address))];
    }

    function deleteItemFromAddressStorage(string _mapName, address _address) internal {
        delete addressStorage[keccak256(abi.encodePacked(_mapName, _address))];
    }

    function setValidatorCount(uint256 _validatorCount) internal {
        uintStorage[keccak256(abi.encodePacked("validatorCount"))] = _validatorCount;
    }

    function setNextValidator(address _prevValidator, address _validator) internal {
        addressStorage[keccak256(abi.encodePacked("validatorsList", _prevValidator))] = _validator;
    }

    function setInitialize(bool _status) internal {
        boolStorage[keccak256(abi.encodePacked("isInitialized"))] = _status;
    }
}



pragma solidity 0.4.24;

contract RewardableValidators is BaseBridgeValidators {

    function initialize(
        uint256 _requiredSignatures,
        address[] _initialValidators,
        address[] _initialRewards,
        address _owner
    )
    public
    returns (bool)
    {
        require(!isInitialized());
        require(_owner != address(0));
        setOwner(_owner);
        require(_requiredSignatures != 0);
        require(_initialValidators.length >= _requiredSignatures);
        require(_initialValidators.length == _initialRewards.length);

        for (uint256 i = 0; i < _initialValidators.length; i++) {
            require(_initialValidators[i] != address(0) && _initialValidators[i] != F_ADDR);
            require(_initialRewards[i] != address(0));
            require(!isValidator(_initialValidators[i]));

            if (i == 0) {
                setNextValidator(F_ADDR, _initialValidators[i]);
                if (_initialValidators.length == 1) {
                    setNextValidator(_initialValidators[i], F_ADDR);
                }
            } else if (i == _initialValidators.length - 1) {
                setNextValidator(_initialValidators[i - 1], _initialValidators[i]);
                setNextValidator(_initialValidators[i], F_ADDR);
            } else {
                setNextValidator(_initialValidators[i - 1], _initialValidators[i]);
            }

            setValidatorCount(validatorCount().add(1));
            setValidatorRewardAddress(_initialValidators[i], _initialRewards[i]);
            emit ValidatorAdded(_initialValidators[i]);
        }

        uintStorage[keccak256(abi.encodePacked("requiredSignatures"))] = _requiredSignatures;
        uintStorage[keccak256("deployedAtBlock")] = block.number;
        setInitialize(true);
        emit RequiredSignaturesChanged(_requiredSignatures);

        return isInitialized();
    }

    function addRewardableValidator(address _validator, address _reward) external onlyOwner {
        require(_reward != address(0));
        _addValidator(_validator);
        setValidatorRewardAddress(_validator, _reward);
        emit ValidatorAdded(_validator);
    }

    function removeValidator(address _validator) external onlyOwner {
        _removeValidator(_validator);
        deleteItemFromAddressStorage("validatorsRewards", _validator);
        emit ValidatorRemoved(_validator);
    }

    function getValidatorRewardAddress(address _validator) public view returns (address) {
        return addressStorage[keccak256(abi.encodePacked("validatorsRewards", _validator))];
    }

    function setValidatorRewardAddress(address _validator, address _reward) internal {
        addressStorage[keccak256(abi.encodePacked("validatorsRewards", _validator))] = _reward;
    }
}