// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedEscrow {
    // State variables
    address payable public buyer;
    address payable public seller;
    address[] public arbiters;
    uint public depositTime;
    uint public disputeEndTime;
    mapping(address => bool) public arbiterVotes;
    uint public approvalCount;
    bool public isDispute;
    uint public immutable disputeDuration = 3 days;  // Dispute resolution duration

    // Events
    event Deposited(address indexed buyer, uint amount);
    event Approved(address indexed arbiter);
    event Refunded(address indexed arbiter);
    event DisputeResolved(bool approved);

    // Constructor
    constructor(address payable _seller, address payable _buyer, address[] memory _arbiters) {
        seller = _seller;
        buyer = _buyer;
        arbiters = _arbiters;
    }

    // Modifier to check if caller is an arbiter
    modifier onlyArbiter() {
        require(isArbiter(msg.sender), "Caller is not an arbiter");
        _;
    }

    // Check if address is in the list of arbiters
    function isArbiter(address _address) public view returns (bool) {
        for (uint i = 0; i < arbiters.length; i++) {
            if (arbiters[i] == _address) {
                return true;
            }
        }
        return false;
    }

    // Deposit funds into escrow
    function deposit() external payable {
        require(msg.sender == buyer, "Only buyer can deposit funds");
        require(address(this).balance == 0, "Escrow already funded");
        depositTime = block.timestamp;
        emit Deposited(msg.sender, msg.value);
    }

    // Start a dispute by the buyer
    function initiateDispute() external {
        require(msg.sender == buyer, "Only buyer can initiate a dispute");
        isDispute = true;
        disputeEndTime = block.timestamp + disputeDuration;
    }

    // Arbiter approves the transaction
    function approve() external onlyArbiter {
        require(!arbiterVotes[msg.sender], "Already voted");
        arbiterVotes[msg.sender] = true;
        approvalCount++;

        if (approvalCount > arbiters.length / 2) {  // Majority approval
            emit DisputeResolved(true);
            seller.transfer(address(this).balance);
        }
        emit Approved(msg.sender);
    }

    // Arbiter refunds the buyer
    function refund() external onlyArbiter {
        require(!arbiterVotes[msg.sender], "Already voted");
        arbiterVotes[msg.sender] = true;
        approvalCount++;

        if (approvalCount > arbiters.length / 2) {  // Majority refund
            emit DisputeResolved(false);
            buyer.transfer(address(this).balance);
        }
        emit Refunded(msg.sender);
    }

    // Automatic refund if dispute is not resolved within the time limit
    function autoRefund() external {
        require(isDispute && (block.timestamp > disputeEndTime), "Dispute not ended or no dispute");
        buyer.transfer(address(this).balance);
    }

    // Get contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
