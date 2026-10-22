# GEC Academy — Assignment / Lab #3

## 1. Project Overview

This lab explores Ethereum smart contract development using Solidity, with a focus on blockchain storage, gas consumption, smart contract deployment, and security vulnerabilities.

The experiments were conducted using Remix IDE, Ethereum Sepolia Testnet, and MetaMask.

## 2. Project Files

| File | Description |
|---|---|
| `StorageTest.sol` | Stores 1 KiB of data on Ethereum and measures gas consumption. |
| `HelloWorld.sol` | Implements and deploys a Hello World smart contract. |
| `ReentryDemo.sol` | Demonstrates reentrant execution using two interacting contracts. |
| `SafeVault.sol` | Demonstrates reentrancy prevention using the Checks-Effects-Interactions pattern. |
| `generate_input.js` | Generates 32 bytes32 values for the storage experiment. |

## 3. Experiment 1 — Ethereum Storage and Gas

The `StorageTest` contract uses a dynamic array of 32 `bytes32` elements to store 1 KiB of data.

The theoretical storage cost is estimated as:

32 × 20,000 = 640,000 gas

The actual transaction gas consumption is measured using Remix VM.

**Measured Transaction Gas: 758364

The difference between theoretical and actual gas consumption is caused by transaction overhead, calldata processing, storage access, and additional EVM operations.

## 4. Experiment 2 — Hello World Smart Contract

The `HelloWorld` contract was compiled and deployed to the Ethereum Sepolia test network.

The contract implements two functions:

- `hello()` returns the string "Hello, world!".
- `sendHello()` emits a `HelloCalled` event.

**Development Environment**

- Solidity Compiler: 0.8.20
- Optimization: Enabled
- Optimization Runs: 200
- IDE: Remix
- Network: Ethereum Sepolia
- Wallet: MetaMask

**Deployment Information**

- Contract Address: 0x82A1780508594d3613e80dF2Da3791a90912de56
- Deployment Transaction Hash: 0x8fe2e08f8af33127fb1ed013c00e8c790e2947d481d3ab6d7c03a8cae31115ad
- Function Transaction Hash:
0x70c71cace2e7e87a1d3e1d2e4f8954aa4fd54ad8904c9318fea1a1b1c3513ac2

The contract interactions can be verified through Sepolia Etherscan.

## 5. Experiment 3 — Reentrancy Demonstration

The `ReentryDemo` and `ReentryCaller` contracts were deployed in Remix VM to demonstrate reentrant execution.

After calling `start()`, the transaction completed successfully and generated two event logs.

The `entered` variable reached 2, confirming that a function was re-entered before its original execution had completed.

This experiment demonstrates the reentrancy mechanism, rather than a complete Ether-withdrawal exploit.

## 6. Experiment 4 — Reentrancy Prevention

The `SafeVault` contract implements the Checks-Effects-Interactions security pattern.

The withdrawal process follows three steps:

1. Check whether the user has sufficient balance.
2. Update the user's recorded balance.
3. Transfer Ether to the user.

**Experimental Results**

- Initial deposit: 1 ETH
- Successful withdrawal: 0.5 ETH
- Remaining contract balance: 0.5 ETH
- Remaining recorded deposit: 0.5 ETH
- Withdrawal exceeding the available balance: Rejected

These results verify basic deposit, withdrawal, and balance-checking behavior. The security improvement comes from updating the contract state before the external transfer.

## 7. Tools and Technologies

- Solidity
- Remix IDE
- Ethereum Sepolia Testnet
- MetaMask
- Sepolia Etherscan
- JavaScript

## 8. Conclusion

This lab provided practical experience with Solidity smart contracts, Ethereum storage, gas measurement, testnet deployment, and reentrancy security.

The experiments demonstrated the importance of efficient blockchain storage, correct contract interaction, and secure ordering of state updates and external calls.

All security demonstrations were performed in an isolated testing environment using simulated funds.
