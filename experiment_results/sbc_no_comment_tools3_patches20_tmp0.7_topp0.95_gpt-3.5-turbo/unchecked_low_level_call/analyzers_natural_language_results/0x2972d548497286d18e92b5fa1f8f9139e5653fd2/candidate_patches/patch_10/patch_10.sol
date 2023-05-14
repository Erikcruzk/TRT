pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address _from,
        address _token,
        address[] _tos,
        uint[] _values
    ) public returns (bool) {
        require(_tos.length > 0 && _tos.length == _values.length);

        for (uint i = 0; i < _tos.length; i++) {
            require(_tos[i] != address(0));
            require(_values[i] > 0);

            require(ERC20(_token).transferFrom(_from, _tos[i], _values[i]));
        }

        return true;
    }
}

interface ERC20 {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}