// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-0x v3 Staking/0x-monorepo-b8e01d7be535196a3145a431291183ecfbb333c6/contracts/extensions/contracts/src/BalanceThresholdFilter/interfaces/IThresholdAsset.sol

/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;


contract IThresholdAsset {

    /// @param _owner The address from which the balance will be retrieved
    /// @return Balance of owner
    function balanceOf(address _owner)
        external
        view
        returns (uint256);

}
