
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    event HelloCalled(
        address indexed caller,
        string message
    );

    function hello()
        public
        pure
        returns (string memory)
    {
        return "Hello, world!";
    }

    function sendHello()
        public
        returns (string memory)
    {
        emit HelloCalled(
            msg.sender,
            "Hello, world!"
        );

        return "Hello, world!";
    }
}
