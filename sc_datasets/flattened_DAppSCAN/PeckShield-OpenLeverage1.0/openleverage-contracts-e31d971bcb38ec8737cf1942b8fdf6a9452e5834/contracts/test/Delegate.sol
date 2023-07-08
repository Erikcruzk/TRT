// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/test/Storage.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.4.22 <0.8.0;

contract Storage {
    address public owner;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/test/Interface.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.4.22 <0.8.0;

abstract contract  Interface is Storage {
    function changeOwner(address newOwner) external virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OpenLeverage1.0/openleverage-contracts-e31d971bcb38ec8737cf1942b8fdf6a9452e5834/contracts/test/Delegate.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.4.22 <0.8.0;

contract Delegate is Interface {
    uint public delegatePrivate;

    uint public delegatePrivateParam=100;

    uint constant public delegatePrivateConstant=1;

    function initialize(address newOwner) public {
        owner = newOwner;
    }
    function setDelegatePrivateParam(uint delegatePrivateParam_) external  {
        delegatePrivateParam = delegatePrivateParam_;
    }
    function changeOwner(address newOwner) external override {
        owner = newOwner;
    }

}
