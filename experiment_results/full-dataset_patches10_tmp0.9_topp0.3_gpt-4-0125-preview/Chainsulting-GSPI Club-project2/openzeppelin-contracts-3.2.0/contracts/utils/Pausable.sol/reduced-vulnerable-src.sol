



pragma solidity ^0.6.0;











abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}





pragma solidity ^0.6.0;










contract Pausable is Context {
    


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