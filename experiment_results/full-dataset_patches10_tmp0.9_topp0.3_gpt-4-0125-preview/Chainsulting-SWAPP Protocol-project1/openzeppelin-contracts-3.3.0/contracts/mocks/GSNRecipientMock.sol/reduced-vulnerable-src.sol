



pragma solidity >=0.6.0 <0.8.0;











abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}





pragma solidity >=0.6.0 <0.8.0;

contract ContextMock is Context {
    event Sender(address sender);

    function msgSender() public {
        emit Sender(_msgSender());
    }

    event Data(bytes data, uint256 integerValue, string stringValue);

    function msgData(uint256 integerValue, string memory stringValue) public {
        emit Data(_msgData(), integerValue, stringValue);
    }
}

contract ContextMockCaller {
    function callSender(ContextMock context) public {
        context.msgSender();
    }

    function callData(ContextMock context, uint256 integerValue, string memory stringValue) public {
        context.msgData(integerValue, stringValue);
    }
}





pragma solidity >=0.6.0 <0.8.0;






interface IRelayRecipient {
    


    function getHubAddr() external view returns (address);

    
















    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    










    function preRelayedCall(bytes calldata context) external returns (bytes32);

    













    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}





pragma solidity >=0.6.0 <0.8.0;








interface IRelayHub {
    

    









    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    


    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    








    function registerRelay(uint256 transactionFee, string calldata url) external;

    



    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    







    function removeRelayByOwner(address relay) external;

    


    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    





    function unstake(address relay) external;

    


    event Unstaked(address indexed relay, uint256 stake);

    
    enum RelayState {
        Unknown, 
        Staked, 
        Registered, 
        Removed    
    }

    



    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    

    






    function depositFor(address target) external payable;

    


    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    


    function balanceOf(address target) external view returns (uint256);

    





    function withdraw(uint256 amount, address payable dest) external;

    


    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    

    









    function canRelay(
        address relay,
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external view returns (uint256 status, bytes memory recipientContext);

    
    enum PreconditionCheck {
        OK,                         
        WrongSignature,             
        WrongNonce,                 
        AcceptRelayedCallReverted,  
        InvalidRecipientStatusCode  
    }

    




























    function relayCall(
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external;

    








    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    







    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    
    enum RelayCallStatus {
        OK,                      
        RelayedCallFailed,       
        PreRelayedFailed,        
        PostRelayedFailed,       
        RecipientBalanceChanged  
    }

    



    function requiredGas(uint256 relayedCallStipend) external view returns (uint256);

    


    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);

     
     
    
    

    





    function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;

    


    function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;

    


    event Penalized(address indexed relay, address sender, uint256 amount);

    


    function getNonce(address from) external view returns (uint256);
}





pragma solidity >=0.6.0 <0.8.0;














abstract contract GSNRecipient is IRelayRecipient, Context {
    
    address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;

    uint256 constant private _RELAYED_CALL_ACCEPTED = 0;
    uint256 constant private _RELAYED_CALL_REJECTED = 11;

    
    uint256 constant internal _POST_RELAYED_CALL_MAX_GAS = 100000;

    


    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);

    


    function getHubAddr() public view override returns (address) {
        return _relayHub;
    }

    






    function _upgradeRelayHub(address newRelayHub) internal virtual {
        address currentRelayHub = _relayHub;
        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");

        emit RelayHubChanged(currentRelayHub, newRelayHub);

        _relayHub = newRelayHub;
    }

    



    
    
    function relayHubVersion() public view returns (string memory) {
        this; 
        return "1.0.0";
    }

    




    function _withdrawDeposits(uint256 amount, address payable payee) internal virtual {
        IRelayHub(_relayHub).withdraw(amount, payee);
    }

    
    
    
    

    





    function _msgSender() internal view virtual override returns (address payable) {
        if (msg.sender != _relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    





    function _msgData() internal view virtual override returns (bytes memory) {
        if (msg.sender != _relayHub) {
            return msg.data;
        } else {
            return _getRelayedCallData();
        }
    }

    
    

    








    function preRelayedCall(bytes memory context) public virtual override returns (bytes32) {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        return _preRelayedCall(context);
    }

    






    function _preRelayedCall(bytes memory context) internal virtual returns (bytes32);

    








    function postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) public virtual override {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        _postRelayedCall(context, success, actualCharge, preRetVal);
    }

    






    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal virtual;

    



    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
        return _approveRelayedCall("");
    }

    




    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
        return (_RELAYED_CALL_ACCEPTED, context);
    }

    


    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
        return (_RELAYED_CALL_REJECTED + errorCode, "");
    }

    



    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
        
        
        return (gas * gasPrice * (100 + serviceFee)) / 100;
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        
        
        
        
        

        
        

        
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        
        assembly {
            
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    function _getRelayedCallData() private pure returns (bytes memory) {
        
        

        uint256 actualDataLength = msg.data.length - 20;
        bytes memory actualData = new bytes(actualDataLength);

        for (uint256 i = 0; i < actualDataLength; ++i) {
            actualData[i] = msg.data[i];
        }

        return actualData;
    }
}





pragma solidity >=0.6.0 <0.8.0;



contract GSNRecipientMock is ContextMock, GSNRecipient {
    function withdrawDeposits(uint256 amount, address payable payee) public {
        _withdrawDeposits(amount, payee);
    }

    function acceptRelayedCall(address, address, bytes calldata, uint256, uint256, uint256, uint256, bytes calldata, uint256)
        external
        view
        override
        returns (uint256, bytes memory)
    {
        return (0, "");
    }

    function _preRelayedCall(bytes memory) internal override returns (bytes32) { }

    function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal override { }

    function upgradeRelayHub(address newRelayHub) public {
        return _upgradeRelayHub(newRelayHub);
    }

    function _msgSender() internal override(Context, GSNRecipient) view virtual returns (address payable) {
        return GSNRecipient._msgSender();
    }

    function _msgData() internal override(Context, GSNRecipient) view virtual returns (bytes memory) {
        return GSNRecipient._msgData();
    }
}