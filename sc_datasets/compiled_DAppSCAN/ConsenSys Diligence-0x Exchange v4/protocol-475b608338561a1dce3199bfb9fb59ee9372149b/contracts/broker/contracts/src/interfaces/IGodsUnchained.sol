// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-0x Exchange v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/broker/contracts/src/interfaces/IGodsUnchained.sol

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
pragma experimental ABIEncoderV2;


interface IGodsUnchained {

    /// @dev Returns the proto and quality for a particular card given its token id
    /// @param tokenId The id of the card to query.
    /// @return proto The proto of the given card.
    /// @return quality The quality of the given card
    function getDetails(uint256 tokenId)
        external
        view
        returns (uint16 proto, uint8 quality);
}
