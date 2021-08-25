// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

interface IExtendedERC20 is IERC20 {
    function mint(address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external returns (bool);
}
