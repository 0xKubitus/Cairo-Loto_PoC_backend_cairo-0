# Index of my contract's versions:

v0.0 - OpenZeppelin presets, not modified.

v0.1 - Unnecessary presets features commented out (transfer-related functions).

v0.2.1 - Anyone can mint for free.

- [deployed contract v0.2.1](https://testnet.starkscan.co/contract/0x00d8f75edfed347830a637898b5110cdd2f287761660d572360f29f3548cdae9)

v0.2.2 - Each ticket/NFT minted gets its Metadata/tokenUri setup while being minted (for now, all NFTs have the same image metadata).

v0.3 - Adding payment condition for minting => Now, sneaky users who haven't paid shouldn't be able to mint.

v0.4 - Each new ticket/NFT gets by itself its tokenId => No need to pass 'tokenId' arg anymore to 'mint()' ("total_tickets_sold: Uint256" added in Storage)
