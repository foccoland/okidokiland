const { ethers, upgrades } = require('hardhat');

async function main () {
  const OkiDokiLand = await ethers.getContractFactory('OkiDokiLand');
  console.log('Deploying OkiDokiLand...');
  const okiDokiLand = await upgrades.deployProxy(OkiDokiLand, { initializer: 'initialize' });
  await okiDokiLand.deployed();
  console.log('OkiDokiLand deployed! Address:', okiDokiLand.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })