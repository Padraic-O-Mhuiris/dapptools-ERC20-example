// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Token.sol";

contract ZxxTest is DSTest {
    ZXX zxx;

    function setUp() public {
        zxx = new ZXX();
    }

    function test_total_supply() public {
        assertEq(zxx.totalSupply(), 100_000_000e18);
    }
}
