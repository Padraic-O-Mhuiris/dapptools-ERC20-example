// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract ZXX {

    string constant public name = "Z--- --- ---";
    string constant public symbol = "ZXX";
    uint8 constant public decimals = 18;

    uint256 constant public totalSupply = 100_000_000e18;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);

    }

    // external always(?) cheaper
    // test transferFrom external or public
    // have transfer call transferFrom or not
    function transfer(address to, uint256 amount) external returns (bool) {

        // memoize balanceOf[msg.sender] ???? or will optimizer do it for us?
        uint256 sender = balanceOf[msg.sender];
        require(sender >= amount, "insufficient amount");

        // solc 0.8.0 has automatic over/underflow checks?
        // does the order matter?
        balanceOf[to] += amount;
        sender -= amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // approve
    // approveEvent
    // transferFrom
    // mint
    // burn
}
