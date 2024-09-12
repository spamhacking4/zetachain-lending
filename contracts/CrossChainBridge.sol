// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CollateralManager.sol";
import "./BorrowManager.sol";

contract CrossChainBridge {
    address public owner;
    CollateralManager public collateralManager;
    BorrowManager public borrowManager;

    event CrossChainDeposit(address indexed user, address indexed token, uint256 amount);
    event CrossChainBorrow(address indexed user, address indexed token, uint256 amount);

    constructor(address _collateralManager, address _borrowManager) {
        owner = msg.sender;
        collateralManager = CollateralManager(_collateralManager);
        borrowManager = BorrowManager(_borrowManager);
    }

    function depositAndBorrow(address token, uint256 collateralAmount, uint256 borrowAmount) external {
        collateralManager.depositCollateral(token, collateralAmount);
        emit CrossChainDeposit(msg.sender, token, collateralAmount);

        // Simulate cross-chain message
        borrowManager.borrowAsset(token, borrowAmount);
        emit CrossChainBorrow(msg.sender, token, borrowAmount);
    }
}