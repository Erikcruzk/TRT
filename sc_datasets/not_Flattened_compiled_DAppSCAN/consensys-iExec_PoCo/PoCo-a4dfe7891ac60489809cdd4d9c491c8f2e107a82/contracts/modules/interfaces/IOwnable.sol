pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface IOwnable
{
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	function owner() external view returns (address);
	function renounceOwnership() external;
	function transferOwnership(address) external;
}
