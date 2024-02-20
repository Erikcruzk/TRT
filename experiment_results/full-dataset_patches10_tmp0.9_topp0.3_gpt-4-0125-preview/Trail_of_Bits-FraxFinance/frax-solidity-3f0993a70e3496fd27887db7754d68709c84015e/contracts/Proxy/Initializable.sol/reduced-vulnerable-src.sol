




pragma solidity >=0.6.0 <0.9.0;













abstract contract Initializable {

    


    bool private _initialized;

    


    bool private _initializing;

    


    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}