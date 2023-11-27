// SPDX-License-Identifier: CAL
pragma solidity ^0.8.19;

/// @title LibWillOverflow
/// @notice A library for checking if mathematical operations will overflow.
library LibWillOverflow {
    /// Returns true if `a * b` will overflow.
    function mulWillOverflow(uint256 a, uint256 b) internal pure returns (bool) {
        unchecked {
            if (a == 0) { return false; }
            uint256 c = a * b;
            return c / a != b;
        }
    }

    /// Returns true if `a + b` will overflow.
    function addWillOverflow(uint256 a, uint256 b) internal pure returns (bool) {
        unchecked {
            return a + b < a;
        }
    }
}