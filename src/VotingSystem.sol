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

    /**
     * @notice Array of candidates.
     */
    Candidate[] public candidates;
    /**
     * @notice Map of registered voters.
     */

    mapping(address => Voter) public voters;

    error VoterAlreadyRegistered(address);
    error ZeroAddressNotAllowed();
    /**
     * @notice Event emitted when a voter registers.
     */

    event VoterRegistered(address voter);

    /**
     * @notice Event emitted when a candidate is added.
     */
    event CandidateAdded(string candidate);

    /**
     * @notice Function to register a voter. Only the owner can call this function.
     */
    function registerVoter(string calldata _name) public {
        address _voter = msg.sender;
        if (voters[_voter].voterAddress != address(0)) {
            revert VoterAlreadyRegistered(_voter);
        }
        voters[_voter] = Voter(_name, _voter, false);
        emit VoterRegistered(_voter);
    }

    /**
     * @notice Function to add a candidate. Only the owner can call this function.
     * @param _name The name of the candidate to add.
     */
    function addCandidate(string calldata _name, address _candidateAddress) public onlyOwner {
        if (_candidateAddress == address(0)) {
            revert ZeroAddressNotAllowed();
        }
        candidates.push(Candidate(_name, _candidateAddress, 0));
        emit CandidateAdded(_name);
    }

    constructor(address _owner) Ownable(_owner) {}
}
