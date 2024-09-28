import { ethers, network } from "hardhat";
import {
  developmentChains,
  VOTING_DELAY,
  proposalsFile,
  FUNC,
  PROPOSAL_DESCRIPTION,
  NEW_STORE_VALUE,
} from "../helper-hardhat-config";
import * as fs from "fs";
import { moveBlocks } from "../utils/move-blocks";