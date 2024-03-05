



















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





















pragma solidity ^0.5.9;


contract MixinCoordinatorRegistryCore is
    ICoordinatorRegistryCore
{
    
    mapping (address => string) internal coordinatorEndpoints;

    
    
    function setCoordinatorEndpoint(string calldata coordinatorEndpoint) external {
        address coordinatorOperator = msg.sender;
        coordinatorEndpoints[coordinatorOperator] = coordinatorEndpoint;
        emit CoordinatorEndpointSet(coordinatorOperator, coordinatorEndpoint);
    }

    
    
    function getCoordinatorEndpoint(address coordinatorOperator)
        external
        view
        returns (string memory coordinatorEndpoint)
    {
        return coordinatorEndpoints[coordinatorOperator];
    }
}





















pragma solidity ^0.5.9;


contract CoordinatorRegistry is
    MixinCoordinatorRegistryCore
{
    constructor ()
        public
        MixinCoordinatorRegistryCore()
    {}
}