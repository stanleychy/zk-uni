// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

/**
 * @title Ballot
 * @dev Voting with delegation.
 */
contract Ballot {
    struct Voter {
        uint256 weight; // weight is accumulated by delegation
        bool voted; // if true, that person already voted
        address delegate; // person delegated to
        uint256 vote; // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name; // short name (up to 32 bytes)
        uint256 voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /**
     * @dev Create Proposals
     * @param proposalNames Proposals name to create
     */
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    /**
     * @dev Only chairperson can call. Give a voter the right to vote on this ballot.
     * @param voter Address of voter to send right
     */
    function giveRightToVoteSingle(address voter) external {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /**
     * Changelog: Takes list of voter address instead of single address to support batching
     * @dev Only chairperson can call. Give a list of voters
     * the right to vote on this ballot.
     * @param voterAddresses Addresses of voters to send right
     */
    function giveRightToVote(address[] memory voterAddresses) external {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        for (uint256 i = 0; i < voterAddresses.length; i++) {
            require(
                !voters[voterAddresses[i]].voted,
                "The voter already voted."
            );
            require(
                voters[voterAddresses[i]].weight == 0,
                "The voter already delegated"
            );

            voters[voterAddresses[i]].weight = 1;
        }
    }

    /**
     * @dev Delegate vote to the voter `to`.
     * @param to Addresse of voter to delegate voting right
     */
    function delegate(address to) external {
        // Call by reference
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /**
     * @dev Give your vote (including votes delegated to you)
     * to proposal `proposals[proposal].name`.
     * @param proposal index of proposal to vote
     */
    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        require(proposal < proposals.length, "Proposal out of range");

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    /**
     * @dev Computes the winning proposal taking all
     * previous votes into account.
     */
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /**
     * @dev Calls winningProposal() function to get the index
     * of the winner contained in the proposals array and then
     * returns the name of the winner
     */
    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
