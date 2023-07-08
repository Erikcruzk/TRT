// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/IOwned.sol

pragma solidity ^0.4.10;

/**@dev Simple interface to Owned base class */
contract IOwned {
    function owner() public constant returns (address) {}
    function transferOwnership(address _newOwner) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Owned.sol

pragma solidity ^0.4.10;

contract Owned is IOwned {
    address public owner;        

    function Owned() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    /**@dev allows transferring the contract ownership. */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Manageable.sol

pragma solidity ^0.4.10;

///A token that have an owner and a list of managers that can perform some operations
///Owner is always a manager too
contract Manageable is Owned {

    event ManagerSet(address manager, bool state);

    mapping (address => bool) public managers;

    function Manageable() public Owned() {
        managers[owner] = true;
    }

    /**@dev Allows execution by managers only */
    modifier managerOnly {
        require(managers[msg.sender]);
        _;
    }

    function transferOwnership(address _newOwner) public ownerOnly {
        super.transferOwnership(_newOwner);

        managers[_newOwner] = true;
        managers[msg.sender] = false;
    }

    function setManager(address manager, bool state) public ownerOnly {
        managers[manager] = state;
        ManagerSet(manager, state);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/crowdsale/IInvestRestrictions.sol

pragma solidity ^0.4.10;

/** @dev Restrictions on investment */
contract IInvestRestrictions is Manageable {
    /**@dev Returns true if investmet is allowed */
    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
        investor; amount; result; tokensLeft;
    }

    /**@dev Called when investment was made */
    function investHappened(address investor, uint amount) managerOnly {}    
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/crowdsale/FloorInvestRestrictions.sol

pragma solidity ^0.4.10;

/**@dev Allows only investments with large enough amount only  */
contract FloorInvestRestrictions is IInvestRestrictions {

    /**@dev The smallest acceptible ether amount */
    uint256 public floor;

    /**@dev True if address already invested */
    mapping (address => bool) public investors;


    function FloorInvestRestrictions(uint256 _floor) {
        floor = _floor;
    }

    /**@dev IInvestRestrictions implementation */
    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
        
        //allow investment if it isn't the first one 
        if (investors[investor]) {
            result = true;
        } else {
            //otherwise check the floor
            result = (amount >= floor);
        }
    }

    /**@dev IInvestRestrictions implementation */
    function investHappened(address investor, uint amount) managerOnly {
        investors[investor] = true;
    }

    /**@dev Changes investment low cap */
    function changeFloor(uint256 newFloor) managerOnly {
        floor = newFloor;
    }
}
