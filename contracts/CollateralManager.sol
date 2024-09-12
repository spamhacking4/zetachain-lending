// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CollateralManager {
    address public owner;
    mapping(address => mapping(address => uint256)) public collateral;

    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);
    event CollateralWithdrawn(address indexed user, address indexed token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function depositCollateral(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        collateral[msg.sender][token] += amount;
        emit CollateralDeposited(msg.sender, token, amount);
    }

    function withdrawCollateral(address token, uint256 amount) external {
        require(collateral[msg.sender][token] >= amount, "Insufficient collateral");
        collateral[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
        emit CollateralWithdrawn(msg.sender, token, amount);
    }

    function getCollateral(address user, address token) external view returns (uint256) {
        return collateral[user][token];
    }
}