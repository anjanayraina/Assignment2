pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../.././src/VotingSystem.sol";

contract VotingSystemFuzzTest is Test {
    VotingSystem public votingSystem;
    address public owner;

    function setUp() public {
        owner = address(this);
        votingSystem = new VotingSystem(owner);
    }

    function testRegisterVoter() public {
        vm.startPrank(address(0x123));
        votingSystem.registerVoter("Voter1");
        assertEq(votingSystem.getVoter(address(0x123)).voterAddress, address(0x123));
        assertEq(votingSystem.getVoter(address(0x123)).name, "Voter1");
        vm.stopPrank();
    }

    function testAddCandidate() public {
        vm.startPrank(address(this));
        address candidate = address(0x456);
        votingSystem.addCandidate("Candidate1", candidate);
        assertEq(votingSystem.getCandidate(0).candidateAddress, candidate);
        assertEq(votingSystem.getCandidate(0).name, "Candidate1");
        vm.stopPrank();
    }

    function testVote() public {
        vm.startPrank(address(this));
        address candidate = address(0x456);
        votingSystem.addCandidate("Candidate1", candidate);
        address voter = address(0x123);
        vm.stopPrank();
        vm.startPrank(voter);
        votingSystem.registerVoter("Voter1");
        votingSystem.vote(0);
        assertEq(votingSystem.getCandidate(0).votesReceived, 1, "Vote was not counted");
        vm.stopPrank();
    }

    function testGetResults() public {
        vm.startPrank(address(this));
        address candidate1 = address(0x456);
        votingSystem.addCandidate("Candidate1", candidate1);
        address candidate2 = address(0x789);
        votingSystem.addCandidate("Candidate2", candidate2);
        vm.stopPrank();
        address voter = address(0x123);
        vm.startPrank(voter);
        votingSystem.registerVoter("Voter1");
        votingSystem.vote(0);
        uint256[] memory results = votingSystem.getResults();
        assertEq(results[0], 1, "Vote count is incorrect");
        assertEq(results[1], 0, "Vote count is incorrect");

        vm.stopPrank();
    }

    function test_ElectionWinner() public {
        vm.startPrank(address(this));
        address candidate1 = address(0x456);
        votingSystem.addCandidate("Candidate1", candidate1);
        address candidate2 = address(0x789);
        votingSystem.addCandidate("Candidate2", candidate2);
        vm.stopPrank();
        vm.startPrank(address(0));
        votingSystem.registerVoter("Voter0");
        votingSystem.vote(0);
        vm.stopPrank();
        vm.startPrank(address(5));
        votingSystem.registerVoter("Voter5");
        votingSystem.vote(1);
        vm.stopPrank();
        address voter = address(0x123);
        vm.startPrank(voter);
        votingSystem.registerVoter("Voter1");
        votingSystem.vote(0);
        uint256[] memory results = votingSystem.getResults();
        assertEq(results[0], 2, "Vote count is incorrect");
        assertEq(results[1], 1, "Vote count is incorrect");
        assertEq(votingSystem.electionWinner().votesReceived, 2);
        vm.stopPrank();
    }

    function testFail_VotingNotAllowedAfterElecitonEnd() public {
        vm.startPrank(address(this));
        address candidate1 = address(0x456);
        votingSystem.addCandidate("Candidate1", candidate1);
        address candidate2 = address(0x789);
        votingSystem.addCandidate("Candidate2", candidate2);
        vm.stopPrank();
        vm.startPrank(address(0));
        votingSystem.registerVoter("Voter0");
        votingSystem.vote(0);
        vm.stopPrank();
        vm.startPrank(address(5));
        votingSystem.registerVoter("Voter5");
        votingSystem.vote(1);
        vm.stopPrank();
        address voter = address(0x123);
        vm.startPrank(voter);
        votingSystem.registerVoter("Voter1");
        votingSystem.vote(0);
        uint256[] memory results = votingSystem.getResults();
        assertEq(results[0], 2, "Vote count is incorrect");
        assertEq(results[1], 1, "Vote count is incorrect");
        assertEq(votingSystem.electionWinner().votesReceived, 2);
        vm.stopPrank();
        vm.startPrank(address(this));
        votingSystem.endVoting();
        vm.stopPrank();
        vm.startPrank(address(3));
        votingSystem.registerVoter("Voter3");
        votingSystem.vote(0);
        vm.stopPrank();
    }
}
