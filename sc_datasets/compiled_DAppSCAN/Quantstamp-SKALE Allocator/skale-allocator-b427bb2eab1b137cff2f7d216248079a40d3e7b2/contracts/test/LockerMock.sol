// File: ../sc_datasets/DAppSCAN/Quantstamp-SKALE Allocator/skale-allocator-b427bb2eab1b137cff2f7d216248079a40d3e7b2/contracts/interfaces/delegation/ILocker.sol

// SPDX-License-Identifier: AGPL-3.0-only

/*
    ILocker.sol - SKALE SAFT Core
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE SAFT Core is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE SAFT Core is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE SAFT Core.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity 0.6.10;

/**
 * @dev Interface of Locker functions of the {TokenState} contract.
 *
 * The SKALE Network has three types of locked tokens:
 *
 * - Tokens that are transferrable but are currently locked into delegation with
 * a validator. See {DelegationController};
 *
 * - Tokens that are not transferable from one address to another, but may be
 * delegated to a validator {getAndUpdateLockedAmount}. This lock enforces
 * Proof-of-Use requirements. See {TokenLaunchLocker}; and,
 *
 * - Tokens that are neither transferable nor delegatable
 * {getAndUpdateForbiddenForDelegationAmount}. This lock enforces slashing.
 * See {Punisher}.
 */
interface ILocker {
    /**
     * @dev Returns the locked amount of untransferable tokens of a given `wallet`
     */
    function getAndUpdateLockedAmount(address wallet) external returns (uint);

    /**
     * @dev Returns the locked amount of untransferable and un-delegatable tokens of a given `wallet`.
     */
    function getAndUpdateForbiddenForDelegationAmount(address wallet) external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-SKALE Allocator/skale-allocator-b427bb2eab1b137cff2f7d216248079a40d3e7b2/contracts/test/LockerMock.sol

// SPDX-License-Identifier: AGPL-3.0-only

/*
    LockerMock.sol - SKALE SAFT Core
    Copyright (C) 2018-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE SAFT Core is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE SAFT Core is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE SAFT Core.  If not, see <https://www.gnu.org/licenses/>.
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