# CAIRO LOTO Backend Protocol - Proof of Concept

<br>

## WORK IN PROGRESS!

<br>

## Main Goals

- Validating the technical feasibility of implementing a fully on-chain and automated zero-loss lottery dApp using Starknet and Cairo.
- Showing that building on Starknet comes with all lot of awesome tools and that the network offers great performances.
- Measure the interest of the community for such an application

<br>

## Architecture

-> A **"Tickets Handler" contract**, to manage the issuance of tickets and keep track of each ticket's owner.

-> A **"Lottery Engine" contract**, _in-progress,_  
to manage the execution of lottery draws.

-> A **"Book Keeper contract"**, _yet to be implemented,_  
to produce yield generation with the assets deposited on Cairo Loto and manage reward claim by the lottery winners.

<br>
<br>
<hr>
<br>
<br>

## Contracts currently Live on Testnet!

current `Tickets Handler contract` is deployed on testnet:  
-> contract address: 0x074ba6bd39ac4ca2b388f63a48aa31f72e1c26a54dce6aaad9f86c76a4e41f37

**<span style="color:red">Addresses will be updated as I progress (unless I forget!)</span>**

<br>
<hr>
<br>

## Step-by-step Project Development

This section provides an overview of the development process for building the **CAIRO LOTO** project.

<br>

<details>
  <summary><b>Notes:</b></summary>

1. The backend contracts are currently written in cairo-0 but will be upgraded to latest Cairo version and syntax in future iterations.  
   (= an MVP version including more features and efforts on UI/UX, then the Production version to be deployed on mainnet).

2. In order to kickstart this project and build a Proof of Concept ASAP,
   I am using [OpenZeppelin's 'ERC721EnumerableMintableBurnable' preset contract](https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo) as a base for the 'Tickets' contract.

3. Also I'm adding the 'upgrade()' function from [the 'ERC20Upgradable' preset library](https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc20/presets/ERC20Upgradeable.cairo) in each contract.  
   It can be used to upgrade the contracts to the latest versions/syntax of Cairo, but is probably also going to be useful as I develop the project and implement new features (advantage = keeping the same contract address as I implement new features).

</details>

<br>
<br>

## 1 - Building the "Tickets" contract

[x] TokenURI

Note that your 'tokenURI' must be <= 31 characters long.  
-> use https://uri.to/ to shorten an URI.  
-> use the `str_to_felt()` function from `/utils.py` or just go on https://codebeautify.org/string-hex-converter to convert into a felt your shortened URI string (just add '0x' as prefix if using codebeautify).  
:wink:

<br>
<hr>
<br>

## 2 - Implementation of the "BookKeeper" contract

<br>
<hr>
<br>

## 3 - Implementation of the "Lottery" contract

<br>
<br>
<br>
<hr>
<br>
<br>
<br>

## Cairo-0 contract Compilation, Declaration and Deployment

1. Follow my [Guide to setup your environment for Cairo-0](https://0xkubi.notion.site/How-to-compile-declare-and-deploy-a-Cairo-0-contract-on-Starknet-since-we-moved-to-Cairo-1-and-com-80fe006412ac49bd8c78d6951361ce71?pvs=4).

2. compile `ozERC721MintBurnEnumUpgradable.cairo`:

```
starknet-compile-deprecated contracts/OZ_Preset/ozERC721MintBurnEnumUpgradable.cairo --output compiled_contracts/ozERC721MintBurnEnumUpgradable_comp.json
```

1. declare contract:

```
starknet declare --contract compiled_contracts/ozERC721MintBurnEnumUpgradable_comp.json --deprecated
```

1. deploy contract:

```
starknet deploy --class_hash 0x590624cb14c82ec9cfa19124fe1a26e4b7b1132ba0e845925734975754b1327 --inputs 0x4c6f7474657279204d5650 0x544b54 0x044bdc0da3aebf62380588ebc75cd404a6bab6581bc01133554a873137a963bc
```

Note that with last versions of the compiler supporting cairo-0, converting every hex into felt/decimal representation for bash commands is not mandatory anymore.

<br>
<hr>
<br>

<br>
<br>

<br>
<hr>
<br>

## Security Considerations

WARNING: This project is a work in progress.  
Contracts may be deployed but haven't been audited.

USE AT YOUR OWN RISK

(although it's on testnet so...  
WHO CARES? JUST HAVE FUN!)

<br>
<hr>
<br>
