const {ethers}=require('hardhat');
const hre = require("hardhat");

async function main() {

const [owner, addr1] = await ethers.getSigners();
const Contracts = await hre.ethers.getContractFactory("Web3Gram");
   const contract = await Contracts.deploy();
    await contract.deployed();
   console.log("Contract deployed to:",contract.address)

 const tx1= await contract.postPin("post","Caption2",true,"hash1","hash2")
 const t=await contract.showmypins()
 console.log(t)

 }



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
