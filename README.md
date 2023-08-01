# MY STARKNET DAPP - Proof of Concept

## Introduction

This project aims to build a very basic backend prototype for a decentralized application where users can purchase tickets to participate to a daily lottery and try to win prizes in crypto.

The app will be deployed on Starknet to leverage its validity rollup technology to provide our users the safety of the Ethereum network, but with cheap transactions fees.

The main objective is to have a functionnal PoC in order to be able to publicly communicate about this project.

## Project Initialization

In order to quickstart this project and build a Proof of Concept ASAP,
I am using the OpenZeppelin 'ERC721EnumerableMintableBurnable' preset contract (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo).

I simply added to it the 'upgrade()' function from 'ERC20Upgradable' preset (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc20/presets/ERC20Upgradeable.cairo).

The concept is to provide players with an NFT for each ticket that will be purchased.

- The backend contract is currently in cairo-0 but will be upgraded to Cairo-1 and using latest syntax in future versions.
- For the frontend app, I'll use Starknet React to build a browser application.

## Cairo-0 contract Compilation, declaration and deployment (initial contract version)

1. Follow my [Guide to setup your environment for Cairo-0](https://0xkubi.notion.site/How-to-compile-declare-and-deploy-a-Cairo-0-contract-on-Starknet-since-we-moved-to-Cairo-1-and-com-80fe006412ac49bd8c78d6951361ce71?pvs=4).

2. compile `ozERC721MintBurnEnumUpgradable.cairo`:

```
starknet-compile-deprecated contracts/OZ_Preset/ozERC721MintBurnEnumUpgradable.cairo --output compiled_contracts/ozERC721MintBurnEnumUpgradable_comp.json
```

3. declare contract:

```
starknet declare --contract compiled_contracts/ozERC721MintBurnEnumUpgradable_comp.json --deprecated
```

4. deploy contract:

```
starknet deploy --class_hash 0x590624cb14c82ec9cfa19124fe1a26e4b7b1132ba0e845925734975754b1327 --inputs 0x4c6f7474657279204d5650 0x544b54 0x044bdc0da3aebf62380588ebc75cd404a6bab6581bc01133554a873137a963bc

```

## Contract is Live on Testnet!

my PoC contract is deployed on testnet:
-> contract address: 0x074ba6bd39ac4ca2b388f63a48aa31f72e1c26a54dce6aaad9f86c76a4e41f37

<br >

# NEXT STEPS ARE:

- Turn into comments all 'transfer' functionnalities,  
  then use _upgrade()_ to change the deployed contract's class_hass to new version of the contract;

- Take notes in Notion about 'how to upgrade a cairo-0 contract';

- Implement "permission_to_mint" logic and modify 'mint()' modify 'mint()' process  
  => when user makes multicall for payment, they should not be able to mint a ticket straight away, but they get "allowed_to_mint".  
  Then, only once allowed, the user will be able to mint from frontend;

- Test 'mint()' and 'burn()' functions;

- Adding metadata to all tokens (no need for each token to have its own unique jpeg for now);

- connecting backend with frontend => try mint from frontend app + try multicall;

- burning ticket = getting money back;

- get in touch with DeFi protocols to know their testnet contract addresses;

- manage sending users funds into liquidity pools;

- implement a lottery system;

- TO BE CONTINUED

<br>
<br>
<br>

NOTE THAT 'tokenURI' MUST BE <= 31 CHARACTERS...  
-> USE https://uri.to/ TO SHORTEN AN URI.  
-> USE https://codebeautify.org/string-hex-converter TO CONVERT INTO HEX YOUR SHORTENED URI STRING.  
:wink:
