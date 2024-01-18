# Protocol Overview

The protocol, as defined by the contract, encompasses the following key functionalities:

## Contract Initialization
The contract is initialized with an owner, who is set as the contract's owner through the OpenZeppelin Ownable contract. This owner possesses special privileges, including the ability to register voters, add candidates, and end the voting process.

## Candidate Management
The owner can add candidates to the election by calling the `addCandidate` function, which takes a name and an Ethereum address for each candidate. Each candidate is stored in an array and has a vote count initialized to zero.

## Voter Registration
The owner can register voters by calling the `registerVoter` function with the voter's name. Each voter is identified by their Ethereum address, and their voting status is tracked to ensure they can only vote once.

## Voting Process
Registered voters can cast their vote for a candidate by calling the `vote` function with the candidate's ID. The contract checks if the voter has already voted and if the candidate ID is valid before incrementing the candidate's vote count and marking the voter as having voted.

## Voting End
The owner can end the voting process by calling the `endVoting` function. Once the voting has ended, no more votes can be cast or voters registered.

## Results and Winner
Anyone can query the results of the election by calling the `getResults` function, which returns an array of vote counts for each candidate. The `electionWinner` function can be called to determine the candidate with the highest number of votes.

## Modifiers and Errors
The contract uses a custom modifier `isVotingOngoing` to restrict certain actions to the period before voting has ended. Custom errors are defined to handle specific conditions such as already registered voters, zero address candidates, voters who have already voted, and out-of-bounds candidate IDs.

## Events
The contract emits events when voters are registered and candidates are added, providing valuable information for front-end applications to track changes on the blockchain.

# How to run
1.  **Install Foundry**

First, run the command below to get Foundryup, the Foundry toolchain installer:

``` bash
curl -L https://foundry.paradigm.xyz | bash
```

Then, in a new terminal session or after reloading your PATH, run it to get the latest forge and cast binaries:

``` console
foundryup
```

2. **Clone This Repo and install dependencies**
``` 
git clone https://github.com/anjanayraina/Assignment2
cd Assigment1
forge install

```

3. **Run the Tests**



``` 
forge test
```

# Design Choices

Several important design choices are evident in the provided decentralized voting system smart contract:

## Use of Structs
The contract uses two structs, `Candidate` and `Voter`, to represent the data models for candidates and voters. This encapsulates related data and makes the code more organized and easier to understand.

## Owner Privileges
The contract inherits from OpenZeppelin's `Ownable` contract, providing a secure way to handle ownership and privileged actions. Only the owner can register voters, add candidates, and end the voting process, centralizing certain control aspects to prevent unauthorized modifications.

## Voting Integrity
The contract ensures that each voter can only vote once by tracking the `hasVoted` boolean in the `Voter` struct. This is crucial for maintaining the integrity of the voting process.

## Dynamic Array for Candidates
Candidates are stored in a dynamic array, allowing for an arbitrary number of candidates to be added. This provides flexibility in the number of participants in the election.

## Mapping for Voters
Voters are stored in a mapping keyed by their Ethereum address, providing an efficient way to look up and verify voter registration and voting status.

## Custom Modifiers and Errors
The contract uses a custom modifier `isVotingOngoing` to restrict certain actions to the active voting period. Custom errors are used instead of string revert messages for common failure cases, which is a gas-efficient way to handle errors.

## Events for State Changes
The contract emits events for significant state changes, such as when a voter is registered or a candidate is added. This allows external observers, such as user interfaces, to react to changes in the contract state.

## Public Visibility and Views
The contract provides public getter functions and marks certain state variables as public, which automatically generates getters. This transparency allows anyone to verify the current state of the contract, including candidate details and voting results.

## End of Voting Control
The contract allows the owner to end the voting process, providing a clear cutoff for when votes can be cast. This is important for determining the final results of the election.

## Result Calculation
The contract includes functions to calculate the election results and determine the winner. This on-chain computation ensures that the results are transparent and verifiable by all participants.

# Security Considerations 

The contract incorporates several security considerations to ensure the integrity and fairness of the voting process:

## Ownership and Access Control
The contract uses OpenZeppelin's `Ownable` contract to restrict certain actions, such as adding candidates and ending the voting, to the owner of the contract. This helps prevent unauthorized users from performing administrative actions.

## Modifiers for State Restrictions
The `isVotingOngoing` modifier is used to prevent certain actions (like registering voters and adding candidates) after the voting has ended. This ensures that the state of the election cannot be altered once the voting period is closed.

## Input Validation
The contract checks for invalid inputs, such as a zero address for candidates, and reverts with custom errors. This prevents the registration of invalid or malicious entries that could disrupt the voting process.

## One Vote Per Voter
The contract enforces that each registered voter can only vote once by using the `hasVoted` boolean in the `Voter` struct. This is crucial to prevent double voting and ensure each voter has an equal impact on the election outcome.

## Revert with Custom Errors
Instead of using generic `require` statements with string messages, the contract uses custom errors. This not only saves gas but also provides clearer reasons for transaction reversion, which can help with debugging and user feedback.

## Bounds Checking
The contract checks that the candidate ID provided in the `vote` function is within the bounds of the candidates array. This prevents out-of-bounds access that could lead to undefined behavior or contract crashes.

## Immutable Voting Record
Once a vote is cast, it is recorded on the blockchain and cannot be changed. This immutability is inherent to blockchain technology and ensures the permanence and transparency of the voting records.

## Events for Transparency
The contract emits events for key actions such as voter registration and candidate addition. These events provide a transparent and auditable trail of all significant state changes, which can be monitored by external observers.

## Visibility of State Variables
The contract makes state variables like the list of candidates and the mapping of voters public, allowing anyone to inspect the current state of the contract. This transparency helps ensure that the contract's behavior can be verified against its intended functionality.

## No External Calls
The contract does not make any external calls to other contracts, which eliminates risks associated with reentrancy attacks and dependencies on external contract behavior.
