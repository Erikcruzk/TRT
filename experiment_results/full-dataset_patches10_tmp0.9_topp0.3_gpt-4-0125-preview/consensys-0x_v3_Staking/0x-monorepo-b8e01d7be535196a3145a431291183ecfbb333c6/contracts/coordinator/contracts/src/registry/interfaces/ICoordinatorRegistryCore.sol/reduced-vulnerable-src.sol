



















pragma solidity ^0.5.9;



contract ICoordinatorRegistryCore
{
    
    event CoordinatorEndpointSet(
        address coordinatorOperator,
        string coordinatorEndpoint
    );

    
    
    function setCoordinatorEndpoint(string calldata coordinatorEndpoint) external;

    
    
    function getCoordinatorEndpoint(address coordinatorOperator)
        external
        view
        returns (string memory coordinatorEndpoint);
}