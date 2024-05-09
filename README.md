## Smart-Escrow
# A solidity smart contract for Escrow management


## Contract Explanation:

Initial Setup: The contract constructor initializes the contract with addresses of the buyer, seller, and an arbiter (who can be a neutral third party to resolve disputes).

Deposit Funds: The buyer deposits funds into the escrow. This transaction needs to be initiated by the buyer.

Approve Transaction: The buyer or the arbiter can approve the release of funds to the seller if they are satisfied with the transaction.

Refund Transaction: The buyer or the arbiter can also refund the funds back to the buyer in case of a dispute that is resolved in the buyer's favor.

Get Balance: Anyone can check the balance stored in the escrow.

Time Lock for Disputes: If a dispute is initiated by the buyer, there's a fixed duration (e.g., 3 days) to resolve it. 
If the dispute is not resolved within this time frame, the funds are automatically refunded to the buyer.

Multiple Arbiters: The contract now involves multiple arbiters. 
Decisions require a majority vote from the arbiters to either approve the payment to the seller or refund to the buyer. Each arbiter can only vote once per transaction.

Dispute Mechanism: The buyer can initiate a dispute if they are not satisfied. 
Once a dispute is initiated, arbiters have a limited time to cast their vote.

Event Logging: Events are logged for significant actions like deposits, approvals, and refunds, which aid in transparency and tracking.


#

## How to Use:

Deploy the Contract: Set the addresses for the buyer, seller, and arbiter.

Deposit: Buyer sends funds to the contract.

Approve/Refund: Depending on the transaction satisfaction, either approve or refund can be called.



