// File: ../sc_datasets/DAppSCAN/QuillAudits-Empower the DAO-Empower the DAO/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-protocol/test/contracts/ERC20BasicNS.sol

pragma solidity ^0.5.8;

/**
 * @title ERC20BasicNS (Non-Standard)
 * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
 * See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
 */
contract ERC20BasicNS {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public;
    event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Empower the DAO-Empower the DAO/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-protocol/test/contracts/ERC20NS.sol

pragma solidity ^0.5.8;

/**
 * @title ERC20 interface (non-standard)
 * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
 * See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
 */
contract ERC20NS is ERC20BasicNS {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public;
    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}