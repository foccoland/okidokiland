require("dotenv").config()

const API_URL = "https://eth-ropsten.alchemyapi.io/v2/Ae3eopiMy9U7IDXxLbb_uyFTCQQp1xv_"
const PRIVATE_KEY = process.env.PRIVATE_KEY
const PUBLIC_KEY = process.env.PUBLIC_KEY

const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(API_URL)

const erc721LandContract = require("../artifacts/contracts/OkiDokiLand.sol/OkiDokiLand.json")
const erc721LandBuildingContract = require("../artifacts/contracts/OkiDokiLandBuilding.sol/OkiDokiLandBuilding.json")
const erc1155Contract = require("../artifacts/contracts/OkiDokiWorld.sol/OkiDokiWorld.json")

// console.log(JSON.stringify(erc721LandContract.abi))
// console.log(JSON.stringify(erc721LandBuildingContract.abi))
console.log(JSON.stringify(erc1155Contract.abi))

const erc721LandContractAddress = "0x26802f17bd92780A652736320fA7AD28142af233"
const erc721LandBuildingContractAddress = "0xa7f34AfFc92c8ED7697C0E899A7Ec1505800bDD4"
const erc1155ContractAddress = "0xD0390bE06D2E975D0C0F11613AE85f3B46D95AC8"

const erc721LandAbiBridgeContract = new web3.eth.Contract(erc721LandContract.abi, erc721LandContractAddress)
const erc721LandBuildingAbiBridgeContract = new web3.eth.Contract(erc721LandBuildingContract.abi, erc721LandBuildingContractAddress)
const erc1155AbiBridgeContract = new web3.eth.Contract(erc1155Contract.abi, erc1155ContractAddress)

async function erc1155BatchMintLandAndBuilding(ids, quantities, amounts) {
  const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce

    //the transaction
  const mintTx = {
    'from': PUBLIC_KEY,
    'to': erc1155ContractAddress,
    'nonce': nonce,
    'gas': 500000,
    'value': amounts[0] * quantities[0] + amounts[1] * quantities[1],
    'data': erc1155AbiBridgeContract.methods.mintBatch(ids, quantities).encodeABI()
  };

  const signPromise = web3.eth.accounts.signTransaction(mintTx, PRIVATE_KEY);

  signPromise.then((signedTx) => {
    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
      if (!err) {
        console.log("The hash of your t ransaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
      } else {
        console.log("Something went wrong when submitting your transaction:", err)
      }
    });
  }).catch((err) => {
    console.log("Promise failed:", err);
  });
}

async function erc721MintLand(tokenURI) {
  const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce

    //the transaction
  const mintTx = {
    'from': PUBLIC_KEY,
    'to': erc721LandContractAddress,
    'nonce': nonce,
    'gas': 500000,
    'data': erc721LandAbiBridgeContract.methods.mintLand(PUBLIC_KEY, tokenURI).encodeABI()
  };

  const signPromise = web3.eth.accounts.signTransaction(mintTx, PRIVATE_KEY);

  signPromise.then((signedTx) => {
    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
      if (!err) {
        console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
      } else {
        console.log("Something went wrong when submitting your transaction:", err)
      }
    });
  }).catch((err) => {
    console.log("Promise failed:", err);
  });
}

async function erc721MintLandBuilding(tokenURI) {
  const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce

    //the transaction
  const mintTx = {
    'from': PUBLIC_KEY,
    'to': erc721LandBuildingContractAddress,
    'nonce': nonce,
    'gas': 500000,
    'data': erc721LandBuildingAbiBridgeContract.methods.mintBuilding(PUBLIC_KEY, tokenURI).encodeABI()
  };

  const signPromise = web3.eth.accounts.signTransaction(mintTx, PRIVATE_KEY);

  signPromise.then((signedTx) => {
    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
      if (!err) {
        console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
      } else {
        console.log("Something went wrong when submitting your transaction:", err)
      }
    });
  }).catch((err) => {
    console.log("Promise failed:", err);
  });
}

async function erc1155BatchTransfer(ids, quantities) {
  const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce

  //the transaction
  const sellTx = {
    'from': PUBLIC_KEY,
    'nonce': nonce,
    'gas': 5000000,
    'data': erc1155AbiBridgeContract.methods.mySafeBatchTransferFrom(0x6Cb1F1B7e5D2E6f3D6E57e0f8F544143D26e90F0, ids, quantities).encodeABI()
  };

  const signPromise = web3.eth.accounts.signTransaction(sellTx, PRIVATE_KEY);

  signPromise.then((signedTx) => {
    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
      if (!err) {
        console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
      } else {
        console.log("Something went wrong when submitting your transaction:", err)
      }
    });
  }).catch((err) => {
    console.log("Promise failed:", err);
  });
}

/** 
 * 
 * decommentare funzione che si intende eseguire
 * 
*/
// ERC1155
erc1155BatchMintLandAndBuilding([0,1], [1,1], [web3.utils.toBN("5000000000000000"), web3.utils.toBN("3000000000000000")])

// ERC721
// erc721MintLand("https://gateway.pinata.cloud/ipfs/QmTLQ7NKRWVScCPAPMy72QQ86pQ46CUTDAWthbfSotcUvN")
// erc721MintLandBuilding("https://gateway.pinata.cloud/ipfs/QmYvRmR7apjr174ne8sqAAuynugd7K2i1hzRj8hfxVzfhL")

/**
 * Elenco address transazioni:
 * 1: deploy OkiDokiLand (ERC721) -> 0x26802f17bd92780A652736320fA7AD28142af233
 * 2: deploy OkiDokiLandBuilding (ERC721) -> 0xa7f34AfFc92c8ED7697C0E899A7Ec1505800bDD4
 * 3: deploy OkiDokiWorld (ERC1155) -> 0xD0390bE06D2E975D0C0F11613AE85f3B46D95AC8
 * 4: mint land OkiDokiLand (ERC721) -> 0xbe7be1e89171f010be2d4969de59f80c41ec02939743912497ba7c9182891d23
 * 5: mint building OkiDokiBuilding (ERC721) -> 0x78d76f50ebc87bd107cfbd8402f1b413cd6abdaabe438ef37d641be9ac033f98
 * 6: mint land OkiDokiWorld (ERC721) -> 0x9d992d926ea66d24a3f63e41fadbcb101526ed7614874a0029b2e3061f6541de
 */
