// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-SeaportProtocol/seaport-f17082fca3e99b409f53040d8858e84b0246aa22/contracts/test/wyvern/ERC20Basic.sol

pragma solidity ^0.4.13;

contract ERC20Basic {
    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-SeaportProtocol/seaport-f17082fca3e99b409f53040d8858e84b0246aa22/contracts/test/wyvern/ERC20.sol

pragma solidity ^0.4.13;

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender)
        public
        view
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-SeaportProtocol/seaport-f17082fca3e99b409f53040d8858e84b0246aa22/contracts/test/wyvern/TokenRecipient.sol

pragma solidity ^0.4.13;

contract TokenRecipient {
    event ReceivedEther(address indexed sender, uint256 amount);
    event ReceivedTokens(
        address indexed from,
        uint256 value,
        address indexed token,
        bytes extraData
    );

    /**
     * @dev Receive tokens and generate a log event
     * @param from Address from which to transfer tokens
     * @param value Amount of tokens to transfer
     * @param token Address of token
     * @param extraData Additional data to log
     */
    function receiveApproval(
        address from,
        uint256 value,
        address token,
        bytes extraData
    ) public {
        ERC20 t = ERC20(token);
        require(t.transferFrom(from, this, value));
        emit ReceivedTokens(from, value, token, extraData);
    }

    /**
     * @dev Receive Ether and generate a log event
     */
    function() public payable {
        emit ReceivedEther(msg.sender, msg.value);
    }
}
