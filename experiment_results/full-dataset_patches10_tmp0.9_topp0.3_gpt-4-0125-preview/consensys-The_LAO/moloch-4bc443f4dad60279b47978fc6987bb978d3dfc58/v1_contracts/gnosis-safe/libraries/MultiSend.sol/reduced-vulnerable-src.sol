

pragma solidity ^0.5.0;






contract MultiSend {

    
    
    
    
    
    function multiSend(bytes memory transactions)
        public
    {
        
        assembly {
            let length := mload(transactions)
            let i := 0x20
            for { } lt(i, length) { } {
                let operation := mload(add(transactions, i))
                let to := mload(add(transactions, add(i, 0x20)))
                let value := mload(add(transactions, add(i, 0x40)))
                let dataLength := mload(add(transactions, add(i, 0x80)))
                let data := add(transactions, add(i, 0xa0))
                let success := 0
                switch operation 
                case 0 { success := call(gas, to, value, data, dataLength, 0, 0) }
                case 1 { success := delegatecall(gas, to, data, dataLength, 0, 0) }
                if eq(success, 0) { revert(0, 0) }
                i := add(i, add(0xa0, mul(div(add(dataLength, 0x1f), 0x20), 0x20)))
            }
        }
    }
}