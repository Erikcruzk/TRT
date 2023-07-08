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
