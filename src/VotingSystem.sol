import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title Decentralized Voting System
 * @author Anjanay Raina 
 * @notice This contract allows users to register and vote for candidates.
 */
pragma solidity ^0.8.23;

contract VotingSystem is Ownable {
 /**
 * @notice Address of the owner of the contract.
 */
constructor(address _owner) Ownable(_owner){
    
}
}
