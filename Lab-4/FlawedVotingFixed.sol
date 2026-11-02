pragma solidity >=0.5.1 <0.6.0;

contract FlawedVotingFixed {
    mapping(address => uint256) public remainingVotes;
    uint256[] public candidates;
    address payable public owner;
    bool public hasEnded = false;

    modifier notEnded() {
        require(!hasEnded, "Voting has ended");
        _;
    }

    constructor(uint256 amountOfCandidates) public {
        require(amountOfCandidates > 0, "Candidates required");
        candidates.length = amountOfCandidates;
        owner = msg.sender;
    }

    function buyVotes() public payable notEnded {
        require(msg.value >= 1 ether, "Minimum one ETH");
        remainingVotes[msg.sender] += msg.value / 1 ether;
        msg.sender.transfer(msg.value % 1 ether);
    }

    function vote(uint256 candidateID, uint256 amountOfVotes) public notEnded {
        require(candidateID < candidates.length, "Invalid candidate");
        require(remainingVotes[msg.sender] >= amountOfVotes, "Not enough votes");
        remainingVotes[msg.sender] -= amountOfVotes;
        candidates[candidateID] += amountOfVotes;
    }

    function payoutVotes(uint256 amount) public notEnded {
        require(remainingVotes[msg.sender] >= amount, "Not enough votes");
        remainingVotes[msg.sender] -= amount; // Effects before interaction
        msg.sender.transfer(amount * 1 ether);
    }

    function endVoting() public notEnded {
        require(msg.sender == owner, "Only owner");
        hasEnded = true;
        owner.transfer(address(this).balance);
    }

    function displayBalanceInEther() public view returns (uint256) {
        return address(this).balance / 1 ether;
    }
    function candidateVotes(uint256 candidateID) public view returns (uint256) {
        require(candidateID < candidates.length, "Invalid candidate");
        return candidates[candidateID];
    }
}
