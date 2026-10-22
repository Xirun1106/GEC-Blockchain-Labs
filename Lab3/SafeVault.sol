
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeVault {
    mapping(address => uint256) public deposits;

    function depositMoney() external payable {
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        // Step 1: Checks
        require(
            deposits[msg.sender] >= amount,
            "Insufficient balance"
        );

        // Step 2: Effects
        deposits[msg.sender] -= amount;

        // Step 3: Interactions
        (bool success, ) = payable(msg.sender).call{
            value: amount
        }("");

        require(success, "Transfer failed");
    }
}
