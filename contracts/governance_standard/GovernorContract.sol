// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract GovernorContract is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    uint256 public s_votingDelay;
    uint256 public s_votingPeriod;

    constructor(
        ERC20Votes _token,
        TimelockController _timelock,
        uint256 _quorumPercentage,
        uint256 _votingPeriod,
        uint256 _votingDelay
    )
        Governor("GovernorContract")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(_quorumPercentage)
        GovernorTimelockControl(_timelock)
    {
        s_votingDelay = _votingDelay;
        s_votingPeriod = _votingPeriod;
    }

    function votingDelay() public view override returns (uint256) {
        return s_votingDelay; // 1 = 1 block
    }

    function votingPeriod() public view override returns (uint256) {
        return s_votingPeriod; // 45818 = 1 week
    }

    // The following functions are overrides required by Solidity.

    function quorum(
        uint256 blockNumber
    )
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(
        address account,
        uint256 blockNumber
    )
        public
        view
        override(
            IGovernor,
            Governor // Correct the override list to include "Governor" and "IGovernor"
        )
        returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    function state(
        uint256 proposalId
    )
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor, IGovernor) returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(Governor, GovernorTimelockControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

// // Compatible with OpenZeppelin Contracts ^5.0.0
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/governance/Governor.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

// contract MyGovernor is
//     Governor,
//     GovernorSettings,
//     GovernorCountingSimple,
//     GovernorVotes,
//     GovernorVotesQuorumFraction,
//     GovernorTimelockControl
// {
//     constructor(
//         IVotes _token,
//         TimelockController _timelock,
//         uint256 _votingDelay,
//         uint256 _votingPeriod
//     )
//         Governor("MyGovernor")
//         GovernorSettings(
//             _votingDelay /* 1 day */,
//             _votingPeriod /* 45818 = ~1 week */,
//             0
//         )
//         GovernorVotes(_token)
//         GovernorVotesQuorumFraction(4)
//         GovernorTimelockControl(_timelock)
//     {}

//     // The following functions are overrides required by Solidity.

//     function votingDelay()
//         public
//         view
//         override(Governor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.votingDelay();
//     }

//     function votingPeriod()
//         public
//         view
//         override(Governor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.votingPeriod();
//     }

//     function quorum(
//         uint256 blockNumber
//     )
//         public
//         view
//         override(Governor, GovernorVotesQuorumFraction)
//         returns (uint256)
//     {
//         return super.quorum(blockNumber);
//     }

//     function state(
//         uint256 proposalId
//     )
//         public
//         view
//         override(Governor, GovernorTimelockControl)
//         returns (ProposalState)
//     {
//         return super.state(proposalId);
//     }

//     function proposalNeedsQueuing(
//         uint256 proposalId
//     ) public view override(Governor, GovernorTimelockControl) returns (bool) {
//         return super.proposalNeedsQueuing(proposalId);
//     }

//     function proposalThreshold()
//         public
//         view
//         override(Governor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.proposalThreshold();
//     }

//     function _queueOperations(
//         uint256 proposalId,
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         bytes32 descriptionHash
//     ) internal override(Governor, GovernorTimelockControl) returns (uint48) {
//         return
//             super._queueOperations(
//                 proposalId,
//                 targets,
//                 values,
//                 calldatas,
//                 descriptionHash
//             );
//     }

//     function _executeOperations(
//         uint256 proposalId,
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         bytes32 descriptionHash
//     ) internal override(Governor, GovernorTimelockControl) {
//         super._executeOperations(
//             proposalId,
//             targets,
//             values,
//             calldatas,
//             descriptionHash
//         );
//     }

//     function _cancel(
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         bytes32 descriptionHash
//     ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
//         return super._cancel(targets, values, calldatas, descriptionHash);
//     }

//     function _executor()
//         internal
//         view
//         override(Governor, GovernorTimelockControl)
//         returns (address)
//     {
//         return super._executor();
//     }
// }
