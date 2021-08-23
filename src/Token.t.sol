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
        assertEq(zxx.balanceOf(address(this)), zxx.totalSupply());
    }

    function test_transfer() public {
        uint256 amount = 1 ether;
        zxx.transfer(address(0x1), 1 ether);
        assertEq(zxx.balanceOf(address(this)), zxx.totalSupply() - amount);
        assertEq(zxx.balanceOf(address(0x1)), amount);
    }

}
