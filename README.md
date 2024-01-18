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
