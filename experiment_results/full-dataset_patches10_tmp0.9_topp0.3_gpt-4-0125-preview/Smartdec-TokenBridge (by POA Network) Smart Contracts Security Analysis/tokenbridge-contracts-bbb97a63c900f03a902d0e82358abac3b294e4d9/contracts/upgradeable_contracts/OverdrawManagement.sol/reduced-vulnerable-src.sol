

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


interface IOwnedUpgradeabilityProxy {
    function proxyOwner() public view returns (address);
}



pragma solidity 0.4.24;

contract OwnedUpgradeability {

    function upgradeabilityAdmin() public view returns (address) {
        return IOwnedUpgradeabilityProxy(this).proxyOwner();
    }

    
    modifier onlyIfOwnerOfProxy() {
        require(msg.sender == upgradeabilityAdmin());
        _;
    }
}



pragma solidity 0.4.24;



contract OverdrawManagement is EternalStorage, OwnedUpgradeability {
    using SafeMath for uint256;

    event UserRequestForSignature(address recipient, uint256 value);

    function fixAssetsAboveLimits(bytes32 txHash, bool unlockOnForeign) external onlyIfOwnerOfProxy {
        require(!fixedAssets(txHash));
        address recipient;
        uint256 value;
        (recipient, value) = txAboveLimits(txHash);
        require(recipient != address(0) && value > 0);
        setOutOfLimitAmount(outOfLimitAmount().sub(value));
        if (unlockOnForeign) {
            emit UserRequestForSignature(recipient, value);
        }
        setFixedAssets(txHash, true);
    }

    function outOfLimitAmount() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("outOfLimitAmount"))];
    }

    function fixedAssets(bytes32 _txHash) public view returns(bool) {
        return boolStorage[keccak256(abi.encodePacked("fixedAssets", _txHash))];
    }

    function setOutOfLimitAmount(uint256 _value) internal {
        uintStorage[keccak256(abi.encodePacked("outOfLimitAmount"))] = _value;
    }

    function txAboveLimits(bytes32 _txHash) internal view returns(address recipient, uint256 value) {
        recipient = addressStorage[keccak256(abi.encodePacked("txOutOfLimitRecipient", _txHash))];
        value = uintStorage[keccak256(abi.encodePacked("txOutOfLimitValue", _txHash))];
    }

    function setTxAboveLimits(address _recipient, uint256 _value, bytes32 _txHash) internal {
        addressStorage[keccak256(abi.encodePacked("txOutOfLimitRecipient", _txHash))] = _recipient;
        uintStorage[keccak256(abi.encodePacked("txOutOfLimitValue", _txHash))] = _value;
    }

    function setFixedAssets(bytes32 _txHash, bool _status) internal {
        boolStorage[keccak256(abi.encodePacked("fixedAssets", _txHash))] = _status;
    }
}