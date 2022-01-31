const { ethers, upgrades } = require('hardhat');

async function main () {
  const OkiDokiLandBuilding = await ethers.getContractFactory('OkiDokiLandBuilding');
  console.log('Deploying OkiDokiLandBuilding...');
  const okiDokiLandBuilding = await upgrades.deployProxy(OkiDokiLandBuilding, { initializer: 'initialize' });
  await okiDokiLandBuilding.deployed();
  console.log('OkiDokiBuilding deployed! Address:', okiDokiLandBuilding.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })