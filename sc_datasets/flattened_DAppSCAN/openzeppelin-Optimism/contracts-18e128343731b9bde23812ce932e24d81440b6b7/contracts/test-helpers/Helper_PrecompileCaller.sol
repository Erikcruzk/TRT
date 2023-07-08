// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/test-helpers/Helper_SimpleProxy.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

contract Helper_SimpleProxy {
    address internal owner;
    address internal target;

    constructor()
    {
        owner = msg.sender;
    }

    fallback()
        external
    {
        makeExternalCall(target, msg.data);
    }

    function setTarget(
        address _target
    )
        public
    {
        if (msg.sender == owner) {
            target = _target;
        } else {
            makeExternalCall(target, msg.data);
        }
    }

    function makeExternalCall(
        address _target,
        bytes memory _calldata
    )
        internal
    {
        (bool success, bytes memory returndata) = _target.call(_calldata);

        if (success) {
            assembly {
                return(add(returndata, 0x20), mload(returndata))
            }
        } else {
            assembly {
                revert(add(returndata, 0x20), mload(returndata))
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/test-helpers/Helper_PrecompileCaller.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

contract Helper_PrecompileCaller is Helper_SimpleProxy {
    function callPrecompile(
        address _precompile,
        bytes memory _data
    )
        public
    {
        if (msg.sender == owner) {
            makeExternalCall(_precompile, _data);
        } else {
            makeExternalCall(target, msg.data);
        }
    }

    function callPrecompileAbi(
        address _precompile,
        bytes memory _data
    )
        public
        returns (
            bytes memory
        )
    {

        bool success;
        bytes memory returndata;
        if (msg.sender == owner) {
            (success, returndata) = _precompile.call(_data);
        } else {
            (success, returndata) = target.call(msg.data);
        }
        require(success, "Precompile call reverted");
        return returndata;
    }

    function getL1MessageSender(
        address _precompile,
        bytes memory _data
    )
        public
        returns (
            address
        )
    {
        callPrecompile(_precompile, _data);
        return address(0); // unused: silence compiler
    }
}
