# MY STARKNET DAPP - Proof of Concept

<br>

## Introduction

This project aims to build a very basic backend prototype for a decentralized application where users can purchase tickets (NFTs) to get access and participate to a daily lottery, and try to win prizes in crypto.

The app will be deployed on Starknet to leverage its validity rollup technology to provide our users the safety of the Ethereum network, but with cheap transactions fees.

The main objective is to have a functionnal PoC in order to be able to publicly communicate about this project.

<br>
<br>

## PoC Specifications

The concept is to sell our users lottery tickets, and to deposit the liquidity that is received as payment into a yield-generating pool from any Starknet DEX.

Each lottery ticket will be represented by a NFT (sent to the ticket owner when purchased), having a unique ID.

Each day, one ticket will be randomly selected among the list of all tickets in circulation and its owner will earn the 'prize of the day' (giving them the right to withdraw from the protocol the amount equalling to the prize they won).

The prize of the day amounts to the total yield generated during the last 24hours.

At any time, ticket owners should be able to burn their ticket and retrieve 80% of its cost.

<br>
<br>

## Architecture

### Backend Protocol

(in cairo-0, using existing templates/ressources as much as possible)

-> A **"Tickets" contract**, to manage the issuance of tickets and keep track of each ticket's owner.

-> A **"Lottery" contract**, executing the lottery draws and distributing the rewards to the winners.

_-> A **"Protocol_Account"** contract, managing the funds on the protocol?_

<hr>

### Frontend Application

#### Next.js:

to schedule calls to initiate the Lottery draw each 24hours.

_This will only be the case for this Proof of Concept, because this is not a decentralized solution, but there is no oracle providing automation/cron-jobs on Starknet yet, unfortunately._

_Another solution might be to have automation from Gelato or Chainlink on Ethereum L1 and use L1->L2 messaging to interact with my L2 contracts?_

**_(I should investigate further this possibility!)_**

<br>

#### React app using Starknet.React:

to build a nice browser application for users to easily interact with the protocol.

<br>
<br>

## Project Initialization

- The backend contract is currently in cairo-0 but will be upgraded to Cairo-1 and using latest syntax in future iterations.  
  (= an MVP version including more features and efforts on UI/UX, then the Production version to be deployed on mainnet).

<br>

In order to quickstart this project and build a Proof of Concept ASAP,
I am using the OpenZeppelin 'ERC721EnumerableMintableBurnable' preset contract (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo) as a base for my'Tickets' contract.

Also I'm adding to it the 'upgrade()' function from 'ERC20Upgradable' preset library (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc20/presets/ERC20Upgradeable.cairo) which is probably going to be useful as I develop the project and implement new features.

<br>
<hr>
<br>

## Building the "Tickets" contract

<br>
<hr>
<br>

## Building the "Lottery" contract

<br>
<hr>
<br>

## Notes about Cairo-0 contract Compilation, Declaration and Deployment

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

Note that with last versions of the compiler supporting cairo-0, converting every hex into felt/decimal representation for bash commands is not mandatory anymore.

<br>
<hr>
<br>

## Contract is Live on Testnet!

my PoC contract is deployed on testnet:  
-> contract address: 0x074ba6bd39ac4ca2b388f63a48aa31f72e1c26a54dce6aaad9f86c76a4e41f37

## the above address needs to be updated with the final contract address!

<br>
<br>

## About TokenURI

Note that your 'tokenURI' must be <= 31 characters long.  
-> use https://uri.to/ to shorten an URI.  
-> use https://codebeautify.org/string-hex-converter to convert into hex your shortened URI string (then, you will only need to add '0x' as prefix to make the felt representation of your string).  
:wink:

<br>
<hr>
<br>

# NEXT STEPS ARE:

- Finish implementating the Lottery contract;

- Build the Scheduler in Next.js to automatize the lottery draw each 24h.

- Use _upgrade()_ to change the deployed contract's class_hass to new version of the contract + Take notes in Notion about 'how to upgrade a cairo-0 contract';

- burning ticket = getting money back;

- get in touch with DeFi protocols to know their testnet contract addresses;

- manage interactions with other DeFi protocol's liquidity pools;

- **TO BE CONTINUED**

<br>
<br>
<br>
