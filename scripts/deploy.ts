import { ethers } from "hardhat";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

async function main() {
  const signers: SignerWithAddress[] = await ethers.getSigners();
  const Flashloan = await ethers.getContractFactory("Flashloan");
  const flashloan = await Flashloan.connect(signers[0]).deploy(signers[0].address);

  await flashloan.deployed();

  console.log("Flashloan contract deployed to:", flashloan.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
