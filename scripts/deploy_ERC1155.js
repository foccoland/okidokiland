const { ethers, upgrades } = require('hardhat');

async function main () {
  const OkiDokiWorld = await ethers.getContractFactory('OkiDokiWorld');
  console.log('Deploying OkiDokiWorld...');
  const okiDokiWorld = await upgrades.deployProxy(OkiDokiWorld, { initializer: 'initialize' });
  await okiDokiWorld.deployed();
  console.log('OkiDokiWorld deployed! Address:', okiDokiWorld.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })