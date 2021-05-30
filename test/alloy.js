import Web3 from 'web3';

const web3 = new Web3(window.ethereum);
// await window.ethereum.enable();

//TODO (truffle compile) get file from build/contracts/Alloy.json then get object property named abi
//const jsonInterface =

const address = "0x0483592f36D61E0B9a156faDF630B7db7404ACFd"

const contract = new web3.eth.Contract(jsonInterface, address);

async function getRequirements(tokenId) {
    let ids = await contract.methods.getRequirements(tokenId).call()

    return ids
}

async function isAlloy(tokenId) {
    let bool = await contract.methods.isComposition(tokenId).call()

    return bool
}

async function mintOre(cid) {
    let tx = await contract.methods.mintOre(`ipfs://${cid.to_string()}`).send()

    return tx
}

async function mintAlloy(tokenIds, cid) {
    let tx = await contract.methods.mintAlloy(tokenIds, `ipfs://${cid.to_string()}`).send()

    return tx
}

async function fuse(tokenId) {
    let tx = await contract.methods.fuse(tokenId).send()

    return tx
}

async function transferToken(from, to, tokenId) {
    let tx = await contract.methods.safeTransferFrom(from, to, tokenId).send()

    return tx
}

async function getTokenIds(owner) {
    //call balanceOf(owner) returns # of tokens
    //https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#IERC721-balanceOf-address-
    let balance = await contract.methods.balanceOf(owner).call()

    //TODO allocate list of X tokens

    //https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#IERC721Enumerable-tokenOfOwnerByIndex-address-uint256-
    //TODO fill list with all token ids returned by tokenOfOwnerByIndex(owner, 0..X)

    //TODO return list

    //TODO get image from IPFS
}

