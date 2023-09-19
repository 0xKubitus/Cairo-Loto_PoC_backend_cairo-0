\*\*\*\*# Index of my contract's versions:

v0.0 - OpenZeppelin presets, not modified.

v0.1 - Unnecessary presets features commented out (transfer-related functions).

v0.2.1 - Anyone can mint for free.

- [deployed contract v0.2.1](https://testnet.starkscan.co/contract/0x00d8f75edfed347830a637898b5110cdd2f287761660d572360f29f3548cdae9)

v0.2.2 - Each ticket/NFT minted gets its Metadata/tokenUri setup while being minted (for now, all NFTs have the same image metadata).

- [deployed contract v0.2.2](https://testnet.starkscan.co/contract/0x06f38318b7c32b3fd6e8614f8a3214b5bff0de75a9c2480838f2922970ad5fe9)

v0.2.3 - Changing Metadata/tokenURI functions (taking inspiration from [starknet-edu's erc721 workshop](https://david-barreto.com/starknet-erc721-workshop-exercise-7/)).

- [deployed contract v0.2.3](https://testnet.starkscan.co/contract/0x012e72b05501bb500c452482760535e69dd42b9e53ab2d0cdb736e54a7f4eaf4)

v0.3 - Each new ticket/NFT gets by itself its tokenId => No need to pass 'tokenId' arg anymore to 'mint()' ("total_tickets_sold: Uint256" added in Storage)

- [deployed contract v0.3](https://testnet.starkscan.co/contract/0x06b69b2e55b2327728bb21ec3f8f5203bf68ff129a2c64d4a8a119e6ccd43dc7)

v0.3.1 - Adding payment condition for minting => Sneaky users who haven't paid should have no way to mint a ticket for free.

- [deployed contract v0.3.1](https://testnet.starkscan.co/contract/0x014c435bf94da8de2babce6bed227327a7879c517268507ca2961f7bd7c0060e)

v0.3.2 - Sending user funds to an account_contract, not the Tickets Manager contract (because Ticket Manager can't sign transactions, so can't do anything once a payment is received).

- [deployed contract v0.3.2](https://testnet.starkscan.co/contract/0x049d1721d7111f21dfcec3b5cef592d96cf9e98281bd3db4139116f8f4f70c2e)
- commands to compile, declare and deploy:

```
starknet-compile-deprecated contracts/v0.3.2.cairo \
--output compiled_contracts/v0.3.2_comp.json \
--abi abis/abi_v0.3.2.json
```

```
starknet declare --contract compiled_contracts/v0.3.2_comp.json --deprecated
```

```
starknet deploy --class_hash 0x3caed0fb1be988597e27481634442941e81b9cdbd373dc6c986ba384cfb94b3 \
--inputs 0x4c6f7474657279204d5650 0x544b54 1092614720383141198393700753811412438499788575996344362760598390946193035325 3 184555836509371486644298270517380613565396767415278678887948391494588524912 181013377130043935071660785332390857023363930029582306395061962390309589352 7334557041162323372692093093001635651741008 2087021424722619777119509474943472645767659996348769578120564519014510906823
```

v0.4 - Creation of "LOTTERY.cairo" contract + Clean-up & Refacto for better readability of the repo.

- [deployed contract v0.4](https://testnet.starkscan.co/contract/0x025654448400d6078a4b9e09f6e90816bc63325996232aa1a69661c267354cab)

v0.4.1 - Burn() function in TicketsHandler now also sends back the user's deposit to their account address.

- [deployed contract v0.4.1](https://testnet.starkscan.co/contract/0x0x00a17ebcab44933a62ebc110edfa00c452f55b442a7c30fb4378ac6284570b09)

v0.4.2 - Mint() now requires 10 USDC instead of 0.001 ETH.

- [deployed contract v0.4.2](https://testnet.starkscan.co/contract/0x07c4e99af60f7466b03347dbe1faa4f788776bf5e934c8ab5a911a45ca64d566/)

- v0.5 - xxx

- [deployed contract v0.5](https://testnet.starkscan.co/contract/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

</br>
<hr>
</br>

## Next steps

-> Implémenter le remboursement du ticket en cas de 'burn'.

-> Trouver comment 'upgrade()' mon contrat (de cairo-0 à cairo-0 pour le moment), et prendre des notes.

-> Travailler sur le systeme de tirage au sort.

-> Contacter des projets DeFi avec Pools de Liquidités pour demander s'ils ont des contrats sur le testnet avec lesquels je pourrais interagir et tester mon projet.
