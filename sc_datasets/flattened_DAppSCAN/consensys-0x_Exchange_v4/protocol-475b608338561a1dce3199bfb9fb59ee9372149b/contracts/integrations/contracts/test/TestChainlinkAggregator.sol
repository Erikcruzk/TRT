// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/integrations/contracts/src/interfaces/IChainlinkAggregator.sol

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


// A subset of https://github.com/smartcontractkit/chainlink/blob/master/evm/contracts/interfaces/AggregatorInterface.sol
interface IChainlinkAggregator {

    /// @dev Returns the latest data value recorded by the contract.
    /// @return answer The latest data value recorded. For a price oracle aggregator, this will be
    ///         the price of the given asset in USD, multipled by 10^8
    function latestAnswer() external view returns (int256 answer);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/integrations/contracts/test/TestChainlinkAggregator.sol

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

contract TestChainlinkAggregator is
    IChainlinkAggregator
{
    int256 internal _price;

    function setPrice(int256 price_)
        external
    {
        _price = price_;
    }

    function latestAnswer()
        external
        view
        returns (int256)
    {
        return _price;
    }
}