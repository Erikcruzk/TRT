// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/interfaces/IOneSwapToken.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IOneSwapBlackList {
    event OwnerChanged(address);
    event AddedBlackLists(address[]);
    event RemovedBlackLists(address[]);

    function owner()external view returns (address);
    function isBlackListed(address)external view returns (bool);

    function changeOwner(address newOwner) external;
    function addBlackLists(address[] calldata  accounts)external;
    function removeBlackLists(address[] calldata  accounts)external;
}

interface IOneSwapToken is IERC20, IOneSwapBlackList{
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    function multiTransfer(uint256[] calldata mixedAddrVal) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/OneSwapBlackList.sol

// SPDX-License-Identifier: GPL
pragma solidity ^0.6.6;

abstract contract OneSwapBlackList is IOneSwapBlackList {
    address private _owner;
    mapping(address => bool) private _isBlackListed;

    constructor() public {
        _owner = msg.sender;
    }

    function owner() public view override returns (address) {
        return _owner;
    }
    function isBlackListed(address user) public view override returns (bool) {
        return _isBlackListed[user];
    }
    modifier onlyOwner() {
        require(msg.sender == _owner, "msg.sender is not owner");
        _;
    }

    function changeOwner(address newOwner) public override onlyOwner {
        _setOwner(newOwner);
    }

    function addBlackLists(address[] calldata _evilUser) public override onlyOwner {
        for (uint i = 0; i < _evilUser.length; i++) {
            _isBlackListed[_evilUser[i]] = true;
        }
        emit AddedBlackLists(_evilUser);
    }

    function removeBlackLists(address[] calldata _clearedUser) public override onlyOwner {
        for (uint i = 0; i < _clearedUser.length; i++) {
            delete _isBlackListed[_clearedUser[i]];
        }
        emit RemovedBlackLists(_clearedUser);
    }

    function _setOwner(address newOwner) internal {
        if (newOwner != address(0)) {
            _owner = newOwner;
            emit OwnerChanged(newOwner);
        }
    }
}
