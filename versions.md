# Index of my contract's versions:

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

<hr>

## Next steps

->
