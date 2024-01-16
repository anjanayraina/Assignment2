pragma solidity ^0.8.23;
import "forge-std/Test.sol";
import "../.././src/VotingSystem.sol";
contract VotingSystemTest is Test {
   VotingSystem public votingSystem;
   address public owner;

   function setUp() public {
       owner = address(this);
       votingSystem = new VotingSystem(owner);
   }

   function testRegisterVoter() public {
   vm.startPrank(address(0x123));
   votingSystem.registerVoter("Voter1");
   assertEq(votingSystem.getVoter(address(0x123)).voterAddress , address(0x123));
   assertEq(votingSystem.getVoter(address(0x123)).name, "Voter1");
   vm.stopPrank();
}
function testAddCandidate() public {
   vm.startPrank(address(this));
   address candidate = address(0x456);
   votingSystem.addCandidate("Candidate1", candidate);
   assertEq(votingSystem.getCandidate(0).candidateAddress ,candidate);
   assertEq(votingSystem.getCandidate(0).name, "Candidate1");
   vm.stopPrank();
}



}