// File: ../sc_datasets/DAppSCAN/consensys-Skale_Network/skale-manager-cf4a07a5198b387fd128e1863a26bbfc789856c4/contracts/interfaces/delegation/ILocker.sol

// SPDX-License-Identifier: AGPL-3.0-only

/*
    ILocker.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity 0.6.10;

/**
 * @dev Interface of the Locker functions.
 */
interface ILocker {
    /**
     * @dev Returns and updates the total amount of locked tokens of a given 
     * `holder`.
     */
    function getAndUpdateLockedAmount(address wallet) external returns (uint);

    /**
     * @dev Returns and updates the total non-transferrable and un-delegatable
     * amount of a given `holder`.
     */
    function getAndUpdateForbiddenForDelegationAmount(address wallet) external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/consensys-Skale_Network/skale-manager-cf4a07a5198b387fd128e1863a26bbfc789856c4/contracts/test/LockerMock.sol

// SPDX-License-Identifier: AGPL-3.0-only

/*
    LockerMock.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity 0.6.10;

contract LockerMock is ILocker {
    function getAndUpdateLockedAmount(address) external override returns (uint) {
        return 13;
    }
    
    function getAndUpdateForbiddenForDelegationAmount(address) external override returns (uint) {
        return 13;
    }
}
