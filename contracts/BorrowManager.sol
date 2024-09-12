// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BorrowManager {
    address public owner;
    mapping(address => mapping(address => uint256)) public borrowed;

    event AssetBorrowed(address indexed user, address indexed token, uint256 amount);
    event AssetRepaid(address indexed user, address indexed token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function borrowAsset(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        IERC20(token).transfer(msg.sender, amount);
        borrowed[msg.sender][token] += amount;
        emit AssetBorrowed(msg.sender, token, amount);
    }

    function repayAsset(address token, uint256 amount) external {
        require(borrowed[msg.sender][token] >= amount, "Insufficient borrowed amount");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        borrowed[msg.sender][token] -= amount;
        emit AssetRepaid(msg.sender, token, amount);
    }

    function getBorrowed(address user, address token) external view returns (uint256) {
        return borrowed[user][token];
    }
}