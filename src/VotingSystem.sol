import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title Decentralized Voting System
 * @author Anjanay Raina
 * @notice This contract allows users to register and vote for candidates.
 */

pragma solidity 0.8.23;

contract VotingSystem is Ownable {
    /**
     * @notice Struct to store candidate information.
     */
    struct Candidate {
        string name;
        address candidateAddress;
        uint256 votesReceived;
    }

    /**
     * @notice Struct to store voter information.
     */
    struct Voter {
        string name;
        address voterAddress;
        bool hasVoted;
    }

    bool public votingEnded;
    /**
     * @notice Event emitted when a vote is cast.
     */

    event VoteCast(address voter, uint256 candidateID);

    /**
     * @notice Event emitted when the voting ends.
     */
    event VotingEnded();

    modifier ensureVotingIsOngoing() {
        require(!votingEnded, "The voting has ended");
        _;
    }

    /**
     * @notice Array of candidates.
     */
    Candidate[] candidates;
    /**
     * @notice Map of registered voters.
     */
    mapping(address => Voter) voters;

    error VoterAlreadyRegistered();
    error ZeroAddressNotAllowed();
    error AlreadyVoted();
    error OutOfBoundsIndex();
    /**
     * @notice Event emitted when a voter registers.
     */

    event VoterRegistered(address voter);

    /**
     * @notice Event emitted when a candidate is added.
     */
    event CandidateAdded(address indexed candidateAddress);

    constructor(address owner) Ownable(owner) {}

    // Public Functions
    /**
     * @notice returns the candidate associated with the index
     * @param index index of the candidate in the array
     */

    function getCandidate(uint256 index) public view returns (Candidate memory) {
        return candidates[index];
    }
    /**
     * @notice returns the voter associated with the address
     * @param voterAddress the address of the voter
     */

    function getVoter(address voterAddress) public view returns (Voter memory) {
        return voters[voterAddress];
    }

    /**
     * @notice Function to get the winner of the election.
     * @return An array of votes received by each candidate.
     */

    function electionWinner() public view returns (Candidate memory) {
        uint256 highestVotesSoFar;
        uint256 candidateIndex;
        uint256 i;
        uint256 n = candidates.length;
        for (; i < n;) {
            uint256 votes = candidates[i].votesReceived;
            if (votes > highestVotesSoFar) {
                highestVotesSoFar = votes;
                candidateIndex = i;
            }
            unchecked {
                ++i;
            }
        }
        return getCandidate(candidateIndex);
    }
    // External Functions
    /**
     * @notice Function to end the election.
     */

    function endVoting() external onlyOwner {
        votingEnded = true;
        emit VotingEnded();
    }
    /**
     * @notice Function to register a voter. Only the owner can call this function.
     * @param name The name of the voter to add.
     */

    function registerVoter(string calldata name) external ensureVotingIsOngoing {
        address voter = msg.sender;
        if (voters[voter].voterAddress != address(0)) {
            revert VoterAlreadyRegistered();
        }
        voters[voter] = Voter(name, voter, false);
        emit VoterRegistered(voter);
    }

    /**
     * @notice Function to add a candidate. Only the owner can call this function.
     * @param _name The name of the candidate to add.
     * $param _candidateAddress The address of the candidate
     */
    function addCandidate(string calldata _name, address _candidateAddress) external ensureVotingIsOngoing onlyOwner {
        bytes4 revertHash = ZeroAddressNotAllowed.selector;
        assembly {
            if eq(_candidateAddress, 0) {
                mstore(0, revertHash)
                revert(0, 4)
            }
        }
        candidates.push(Candidate(_name, _candidateAddress, 0));
        emit CandidateAdded(_candidateAddress);
    }

    /**
     * @notice Function to cast a vote. Only registered voters can call this function.
     * @param candidateID The ID of the candidate to vote for.
     */
    function vote(uint256 candidateID) external ensureVotingIsOngoing {
        address voter = msg.sender;
        if (voters[voter].hasVoted) {
            revert AlreadyVoted();
        }
        if (candidateID >= candidates.length) {
            revert OutOfBoundsIndex();
        }
        unchecked {
            candidates[candidateID].votesReceived += 1;
        }
        voters[voter].hasVoted = true;
        emit VoteCast(voter, candidateID);
    }

    /**
     * @notice Function to get the results of the voting.
     * @return An array of votes received by each candidate.
     */
    function getResults() external view returns (uint256[] memory) {
        uint256 n = candidates.length;
        uint256[] memory result = new uint[](n);
        uint256 i;

        for (; i < n;) {
            result[i] = candidates[i].votesReceived;
            unchecked {
                ++i;
            }
        }
        return result;
    }
}
