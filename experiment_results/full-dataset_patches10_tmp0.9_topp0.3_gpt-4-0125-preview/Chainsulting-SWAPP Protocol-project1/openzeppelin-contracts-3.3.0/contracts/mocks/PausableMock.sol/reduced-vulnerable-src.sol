



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










abstract contract Pausable is Context {
    


    event Paused(address account);

    


    event Unpaused(address account);

    bool private _paused;

    


    constructor () internal {
        _paused = false;
    }

    


    function paused() public view returns (bool) {
        return _paused;
    }

    






    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    






    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    






    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    






    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}





pragma solidity >=0.6.0 <0.8.0;

contract PausableMock is Pausable {
    bool public drasticMeasureTaken;
    uint256 public count;

    constructor () public {
        drasticMeasureTaken = false;
        count = 0;
    }

    function normalProcess() external whenNotPaused {
        count++;
    }

    function drasticMeasure() external whenPaused {
        drasticMeasureTaken = true;
    }

    function pause() external {
        _pause();
    }

    function unpause() external {
        _unpause();
    }
}