/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/wrong_constructor_name/incorrect_constructor.sol
 * @author: Ben Perez
 * Modified by Gerhard Wagner
 */

pragma solidity ^0.5.0;

contract Missing{
    address payable private owner;

    modifier onlyowner {
        require(msg.sender==owner);
        _;
    }

    // The name of the constructor should be Missing
    // Anyone can call the IamMissing once the contract is deployed
    constructor()
        public
    {
        owner = msg.sender;
    }

    function () payable external {}

    function withdraw()
        public
        onlyowner
    {
       owner.transfer(address(this).balance);
    }
}
