// SPDX-License-Identifier: CAL
pragma solidity =0.8.19;

import {Test, stdError} from "forge-std/Test.sol";
import {LibWillOverflow} from "src/lib/LibWillOverflow.sol";

/// @title LibWillOverflowMulTest
/// @notice A contract to test LibWillOverflow mul.
contract LibWillOverflowMulTest is Test {
    /// Expose mul externally so we can use it with `vm.expectRevert`.
    function externalMul(uint256 a, uint256 b) external pure returns (uint256) {
        return a * b;
    }

    /// `mulWillOverflow` must never itself overflow.
    function testWillOverflowMul(uint256 a, uint256 b) public pure {
        LibWillOverflow.mulWillOverflow(a, b);
    }

    /// When `mulWillOverflow` returns false, the multiplication must not
    /// overflow.
    function testWillOverflowMulFalse(uint256 a, uint256 b) public pure {
        vm.assume(!LibWillOverflow.mulWillOverflow(a, b));
        a * b;
    }

    /// When `mulWillOverflow` returns true, the multiplication must overflow.
    function testWillOverflowMulTrue(uint256 a, uint256 b) public {
        vm.assume(LibWillOverflow.mulWillOverflow(a, b));
        vm.expectRevert(stdError.arithmeticError);
        LibWillOverflowMulTest(address(this)).externalMul(a, b);
    }
}
