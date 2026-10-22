
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReentryDemo {
    uint256 public entered;

    event Entered(uint256 depth);

    function demonstrate(address target) external {
        entered += 1;
        emit Entered(entered);

        if (entered == 1) {
            ICallback(target).callback();
        }
    }
}

interface ICallback {
    function callback() external;
}

contract ReentryCaller {
    ReentryDemo public demo;

    constructor(address demoAddress) {
        demo = ReentryDemo(demoAddress);
    }

    function start() external {
        demo.demonstrate(address(this));
    }

    function callback() external {
        require(msg.sender == address(demo));
        demo.demonstrate(address(this));
    }
}
