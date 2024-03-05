

pragma solidity ^0.4.24;





contract TwoKeyConversionStates {
    enum ConversionState {PENDING_APPROVAL, APPROVED, EXECUTED, REJECTED, CANCELLED_BY_CONVERTER}
}