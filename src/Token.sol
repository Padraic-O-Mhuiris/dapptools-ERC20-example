// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

// optimized vs non-optimized
// solc memoizing variables
// how many SLOADs
// external always(?) cheaper
// automatic over/under flows
// test transferFrom external or public
// have transfer call transferFrom or not
// mint
// burn
contract ZXX {

    string constant public name = "Z--- --- ---";
    string constant public symbol = "ZXX";
    uint8 constant public decimals = 18;

    uint256 constant public totalSupply = 100_000_000e18;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);


    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);

    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }


    function transfer(address to, uint256 amount) external returns (bool) {
        uint256 balance = balanceOf[msg.sender];
        require(balance >= amount, "insufficient balance");
        balanceOf[msg.sender] = balance - amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
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
}
