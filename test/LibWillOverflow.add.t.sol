// SPDX-License-Identifier: CAL
pragma solidity =0.8.19;

import {Test, stdError} from "forge-std/Test.sol";
import {LibWillOverflow} from "src/lib/LibWillOverflow.sol";

/// @title LibWillOverflowAddTest
/// @notice A contract to test LibWillOverflow add.
contract LibWillOverflowAddTest is Test {
    /// Expose add externally so we can use it with `vm.expectRevert`.
    function externalAdd(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }

    /// `addWillOverflow` must never itself overflow.
    function testWillOverflowAdd(uint256 a, uint256 b) public pure {
        LibWillOverflow.addWillOverflow(a, b);
    }

    /// When `addWillOverflow` returns false, the addition must not overflow.
    function testWillOverflowAddFalse(uint256 a, uint256 b) public pure {
        vm.assume(!LibWillOverflow.addWillOverflow(a, b));
        a + b;
    }

    /// When `addWillOverflow` returns true, the addition must overflow.
    function testWillOverflowAddTrue(uint256 a, uint256 b) public {
        vm.assume(LibWillOverflow.addWillOverflow(a, b));
        vm.expectRevert(stdError.arithmeticError);
        LibWillOverflowAddTest(address(this)).externalAdd(a, b);
    }
}
