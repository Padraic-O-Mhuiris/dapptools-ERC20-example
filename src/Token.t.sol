// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Token.sol";

contract User {
    function doApprove(ZXX zxx, address to, uint256 amount) external returns (bool) {
        return zxx.approve(to, amount);
    }
    function doTransfer(ZXX zxx, address to, uint256 amount) external returns (bool) {
        return zxx.transfer(to, amount);
    }
    function doTransferFrom(ZXX zxx, address from, address to, uint256 amount) external returns (bool) {
        return zxx.transferFrom(from, to, amount);
    }

}

contract ZxxTest is DSTest {
    ZXX zxx;
    User u1;
    User u2;

    function setUp() public {
        zxx = new ZXX();
        u1 = new User();
        u2 = new User();
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

    function test_transfer_from() public {
        zxx.transfer(address(u1), 1 ether);
        assertEq(zxx.balanceOf(address(u1)), 1 ether);

        u1.doApprove(zxx, address(u2), 0.5 ether);
        assertEq(zxx.allowance(address(u1), address(u2)), 0.5 ether);

        u2.doTransferFrom(zxx, address(u1), address(u2), 0.5 ether);

        assertEq(zxx.allowance(address(u1), address(u2)), 0 ether);
        assertEq(zxx.balanceOf(address(u1)), 0.5 ether);
        assertEq(zxx.balanceOf(address(u2)), 0.5 ether);

    }

    function testFail_transfer_from() public {
        zxx.transfer(address(u1), 1 ether);
        assertEq(zxx.balanceOf(address(u1)), 1 ether);

        u1.doApprove(zxx, address(u2), 0.5 ether);
        assertEq(zxx.allowance(address(u1), address(u2)), 0.5 ether);

        u2.doTransferFrom(zxx, address(u1), address(u2), 0.6 ether);
    }

}
