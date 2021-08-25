// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Token.sol";

contract User {
    function doApprove(IExtendedERC20 zxx, address to, uint256 amount) external returns (bool) {
        return zxx.approve(to, amount);
    }

    function doTransfer(IExtendedERC20 zxx, address to, uint256 amount) external returns (bool) {
        return zxx.transfer(to, amount);
    }

    function doTransferFrom(IExtendedERC20 zxx, address from, address to, uint256 amount) external returns (bool) {
        return zxx.transferFrom(from, to, amount);
    }

    function doMint(IExtendedERC20 zxx, address to, uint256 amount) external returns (bool) {
        return zxx.mint(to, amount);
    }
}

contract ZxxTest is DSTest {
    ZXX zxx;
    User u1;
    User u2;
    User u3;
    User u4;

    function setUp() public {
        zxx = new ZXX();
        u1 = new User();
        u2 = new User();
        u3 = new User();
        u4 = new User();
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

    function test_mint() public {
        uint256 totalSupply = zxx.totalSupply();
        zxx.mint(address(0x2), 1 ether);
        assertEq(zxx.balanceOf(address(0x2)), 1 ether);
        assertEq(zxx.totalSupply(), totalSupply + 1 ether);
    }

    function testFail_unauthorized_mint() public {
        u1.doMint(zxx, address(u1), 1 ether);
    }

    function test_burn() public {
        uint256 totalSupply = zxx.totalSupply();
        zxx.burn(1 ether);
        assertEq(zxx.balanceOf(address(this)), totalSupply - 1 ether);
        assertEq(zxx.totalSupply(), totalSupply - 1 ether);
    }

    function test_transfer_gas_usage() public {
        uint256 gas = gasleft();
        zxx.transfer(address(0x1), 1 ether);
        emit log_named_uint("ZXX", gas - gasleft());
    }

    function test_transfer_from_gas_usage() public {
        zxx.transfer(address(u1), 1 ether);
        assertEq(zxx.balanceOf(address(u1)), 1 ether);

        u1.doApprove(zxx, address(u2), 0.5 ether);
        assertEq(zxx.allowance(address(u1), address(u2)), 0.5 ether);

        uint256 gas = gasleft();
        u2.doTransferFrom(zxx, address(u1), address(u2), 0.5 ether);
        emit log_named_uint("ZXX", gas - gasleft());

        assertEq(zxx.allowance(address(u1), address(u2)), 0 ether);
        assertEq(zxx.balanceOf(address(u1)), 0.5 ether);
        assertEq(zxx.balanceOf(address(u2)), 0.5 ether);
    }

    function prove_transfer(uint supply, address usr, uint amt) public {
        zxx.burn(zxx.totalSupply());

        if (amt > supply) return; // no underflow

        zxx.mint(address(this), supply);

        uint prebal = zxx.balanceOf(usr);
        zxx.transfer(usr, amt);
        uint postbal = zxx.balanceOf(usr);

        uint expected = usr == address(this)
                        ? 0    // self transfer is a noop
                        : amt; // otherwise `amt` has been transfered to `usr`
        assertEq(expected, postbal - prebal);
    }

    function prove_balance(address usr, uint amt) public {
        zxx.burn(zxx.totalSupply());

        assertEq(0, zxx.balanceOf(usr));
        zxx.mint(usr, amt);
        assertEq(amt, zxx.balanceOf(usr));
    }

    function prove_supply(uint supply) public {
        zxx.burn(zxx.totalSupply());
        zxx.mint(address(0x1), supply);
        uint actual = zxx.totalSupply();
        assertEq(supply, actual);
    }


}
