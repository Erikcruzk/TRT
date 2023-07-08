// File: ../sc_datasets/DAppSCAN/openzeppelin-EtherCamp_Hacker_Gold/virtual-accelerator-2529ffe5efd5294b44f1bc89dc9a4721a7b16409 2/contracts/EventInfo.sol

/**
 * 
 * EventInfo - imutable class that denotes
 * the time of the virtual accelerator hack
 * event
 * 
 */
contract EventInfo{
    
    
    uint constant HACKATHON_5_WEEKS = 60 * 60 * 24 * 7 * 5;
    uint constant T_1_WEEK = 60 * 60 * 24 * 7;

    uint eventStart = 1478512800;
    uint eventEnd = eventStart + HACKATHON_5_WEEKS;
    
    function getEventStart() constant returns (uint result){
        
       return eventStart;
    } 
    
    function getEventEnd() constant returns (uint result){
        
       return eventEnd;
    } 
    
    function getVotingStart() constant returns (uint result){
        return eventStart+ T_1_WEEK;
    }

    function getTradingStart() constant returns (uint result){
        return eventStart+ T_1_WEEK;
    }

    function getNow() constant returns (uint result){
        
       return now;
    } 
    
}
