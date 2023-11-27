// SPDX-License-Identifier: CAL
pragma solidity =0.8.19;

import {Test, stdError} from "forge-std/Test.sol";
import {LibWillOverflow} from "src/lib/LibWillOverflow.sol";

/// @title LibWillOverflowSubTest
/// @notice A contract to test LibWillOverflow sub.
contract LibWillOverflowSubTest is Test {
    /// Expose sub externally so we can use it with `vm.expectRevert`.
    function externalSub(uint256 a, uint256 b) external pure returns (uint256) {
        return a - b;
    }

    /// `subWillOverflow` must never itself overflow.
    function testWillOverflowSub(uint256 a, uint256 b) public pure {
        LibWillOverflow.subWillOverflow(a, b);
    }

    /// When `subWillOverflow` returns false, the subtraction must not
    /// overflow.
    function testWillOverflowSubFalse(uint256 a, uint256 b) public pure {
        vm.assume(!LibWillOverflow.subWillOverflow(a, b));
        a - b;
    }

    /// When `subWillOverflow` returns true, the subtraction must overflow.
    function testWillOverflowSubTrue(uint256 a, uint256 b) public {
        vm.assume(LibWillOverflow.subWillOverflow(a, b));
        vm.expectRevert(stdError.arithmeticError);
        LibWillOverflowSubTest(address(this)).externalSub(a, b);
    }
}
