// File: ../sc_datasets/DAppSCAN/Coinbae-Deus_Finance_DEAStaking/0x-monorepo-abd479dc68fa75719647db261130418725fd40d5/packages/abi-gen/test-cli/fixtures/contracts/LibDummy.sol

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

pragma solidity ^0.5.5;


library LibDummy {

    using LibDummy for uint256;
    uint256 constant internal SOME_CONSTANT = 1234;

    function addOne (uint256 x)
        internal
        pure
        returns (uint256 sum)
    {
        return x + 1;
    }

    function addConstant (uint256 x)
        internal
        pure
        returns (uint256 someConstant)
    {
        return x + SOME_CONSTANT;
    }
}