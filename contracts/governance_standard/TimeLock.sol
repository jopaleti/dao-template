// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimeLock is TimelockController {
    // minDelay: How long you have to wait before executing
    // proposers: is the list of addresses that can propose
    // executors: Who can execute when a proposal pass
    // admin: The address that will have admin rights over the timelock (can be set to `address(0)` or the deployer)
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController (minDelay, proposers, executors, admin) {}
}