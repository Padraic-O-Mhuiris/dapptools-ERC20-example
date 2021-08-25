// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./IExtendedERC20.sol";

contract ZXX2 is IExtendedERC20 {
    string constant public name = "Enzo Nicolas Perez Token";
    string constant public symbol = "ENP";
    uint8 constant public decimals = 18;

    uint256 public override totalSupply = 100_000_000e18;

    mapping (address => uint256) public override balanceOf;
    mapping (address => mapping(address => uint256)) public override allowance;

    address public owner;

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        uint256 balance = balanceOf[msg.sender];
        require(balance >= amount, "insufficient balance");
        balanceOf[msg.sender] = balance - amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        uint256 allowanceAmnt = allowance[from][msg.sender];
        require(allowanceAmnt >= amount, "insufficient allowance");
        allowance[from][msg.sender] = allowanceAmnt - amount;

        uint256 balance = balanceOf[from];
        require(balance >= amount, "insufficient balance");
        balanceOf[from] = balance - amount;

        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) external override returns (bool) {
        require(msg.sender == owner, "mint not authorized");
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(uint256 amount) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
}
