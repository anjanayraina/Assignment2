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
    error AlreadyVoted(address);
    error OutOfBoundsIndex();
    error VotingReset();
    /**
     * @notice Event emitted when a voter registers.
     */

    event VoterRegistered(address voter);

    /**
     * @notice Event emitted when a candidate is added.
     */
    event CandidateAdded(address indexed candidateAddress);

    function getCandidate(uint256 index) public view returns (Candidate memory) {
        return candidates[index];
    }

    function getVoter(address voterAddress) public view returns (Voter memory) {
        return voters[voterAddress];
    }
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
     * $param _candidateAddress The address of the candidate
     */
    function addCandidate(string calldata _name, address _candidateAddress) public onlyOwner {
        if (_candidateAddress == address(0)) {
            revert ZeroAddressNotAllowed();
        }
        candidates.push(Candidate(_name, _candidateAddress, 0));
        emit CandidateAdded(_candidateAddress);
    }

    /**
     * @notice Function to cast a vote. Only registered voters can call this function.
     * @param _candidateId The ID of the candidate to vote for.
     */
    function vote(uint256 _candidateId) public {
        address voter = msg.sender;
        if (voters[voter].hasVoted) {
            revert AlreadyVoted(voter);
        }
        if (_candidateId >= candidates.length) {
            revert OutOfBoundsIndex();
        }
        candidates[_candidateId].votesReceived += 1;
        voters[voter].hasVoted = true;
    }

    /**
     * @notice Function to get the results of the voting.
     * @return An array of votes received by each candidate.
     */
    function getResults() public view returns (uint256[] memory) {
        uint256[] memory result = new uint[](candidates.length);
        for (uint256 i = 0; i < candidates.length; i++) {
            result[i] = candidates[i].votesReceived;
        }
        return result;
    }

    function electionWinner() public view returns (Candidate memory) {
        uint256 highestVotesSoFar;
        uint256 candidateIndex;
        for (uint256 i = 0; i < candidates.length; i++) {
            uint256 votes = candidates[i].votesReceived;
            if (votes > highestVotesSoFar) {
                highestVotesSoFar = votes;
                candidateIndex = i;
            }
        }
        return getCandidate(candidateIndex);
    }

    constructor(address _owner) Ownable(_owner) {}
}
