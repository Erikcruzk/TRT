



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










interface IERC777 {
    


    function name() external view returns (string memory);

    



    function symbol() external view returns (string memory);

    






    function granularity() external view returns (uint256);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address owner) external view returns (uint256);

    















    function send(address recipient, uint256 amount, bytes calldata data) external;

    












    function burn(uint256 amount, bytes calldata data) external;

    






    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);

    










    function authorizeOperator(address operator) external;

    










    function revokeOperator(address operator) external;

    







    function defaultOperators() external view returns (address[] memory);

    


















    function operatorSend(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    














    function operatorBurn(
        address account,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );

    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);

    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);

    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);

    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}





pragma solidity >=0.6.0 <0.8.0;











interface IERC777Sender {
    









    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}





pragma solidity >=0.6.0 <0.8.0;











interface IERC777Recipient {
    









    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}





pragma solidity >=0.6.0 <0.8.0;















interface IERC1820Registry {
    












    function setManager(address account, address newManager) external;

    




    function getManager(address account) external view returns (address);

    



















    function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;

    








    function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);

    




    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

    




    function updateERC165Cache(address account, bytes4 interfaceId) external;

    








    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

    





    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

    event ManagerChanged(address indexed account, address indexed newManager);
}





pragma solidity >=0.6.0 <0.8.0;







interface IERC1820Implementer {
    





    function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) external view returns (bytes32);
}





pragma solidity >=0.6.0 <0.8.0;









contract ERC1820Implementer is IERC1820Implementer {
    bytes32 constant private _ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

    mapping(bytes32 => mapping(address => bool)) private _supportedInterfaces;

    


    function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) public view override returns (bytes32) {
        return _supportedInterfaces[interfaceHash][account] ? _ERC1820_ACCEPT_MAGIC : bytes32(0x00);
    }

    






    function _registerInterfaceForAddress(bytes32 interfaceHash, address account) internal virtual {
        _supportedInterfaces[interfaceHash][account] = true;
    }
}





pragma solidity >=0.6.0 <0.8.0;






contract ERC777SenderRecipientMock is Context, IERC777Sender, IERC777Recipient, ERC1820Implementer {
    event TokensToSendCalled(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes data,
        bytes operatorData,
        address token,
        uint256 fromBalance,
        uint256 toBalance
    );

    event TokensReceivedCalled(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes data,
        bytes operatorData,
        address token,
        uint256 fromBalance,
        uint256 toBalance
    );

    bool private _shouldRevertSend;
    bool private _shouldRevertReceive;

    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH = keccak256("ERC777TokensSender");
    bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");

    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        if (_shouldRevertSend) {
            revert();
        }

        IERC777 token = IERC777(_msgSender());

        uint256 fromBalance = token.balanceOf(from);
        
        uint256 toBalance = token.balanceOf(to);

        emit TokensToSendCalled(
            operator,
            from,
            to,
            amount,
            userData,
            operatorData,
            address(token),
            fromBalance,
            toBalance
        );
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        if (_shouldRevertReceive) {
            revert();
        }

        IERC777 token = IERC777(_msgSender());

        uint256 fromBalance = token.balanceOf(from);
        
        uint256 toBalance = token.balanceOf(to);

        emit TokensReceivedCalled(
            operator,
            from,
            to,
            amount,
            userData,
            operatorData,
            address(token),
            fromBalance,
            toBalance
        );
    }

    function senderFor(address account) public {
        _registerInterfaceForAddress(_TOKENS_SENDER_INTERFACE_HASH, account);

        address self = address(this);
        if (account == self) {
            registerSender(self);
        }
    }

    function registerSender(address sender) public {
        _erc1820.setInterfaceImplementer(address(this), _TOKENS_SENDER_INTERFACE_HASH, sender);
    }

    function recipientFor(address account) public {
        _registerInterfaceForAddress(_TOKENS_RECIPIENT_INTERFACE_HASH, account);

        address self = address(this);
        if (account == self) {
            registerRecipient(self);
        }
    }

    function registerRecipient(address recipient) public {
        _erc1820.setInterfaceImplementer(address(this), _TOKENS_RECIPIENT_INTERFACE_HASH, recipient);
    }

    function setShouldRevertSend(bool shouldRevert) public {
        _shouldRevertSend = shouldRevert;
    }

    function setShouldRevertReceive(bool shouldRevert) public {
        _shouldRevertReceive = shouldRevert;
    }

    function send(IERC777 token, address to, uint256 amount, bytes memory data) public {
        
        token.send(to, amount, data); 
    }

    function burn(IERC777 token, uint256 amount, bytes memory data) public {
        token.burn(amount, data);
    }
}