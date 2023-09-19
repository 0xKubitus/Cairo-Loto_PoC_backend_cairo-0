// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.6.1 
// (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.upgrades.library import Proxy
from openzeppelin.security.safemath.library import SafeUint256

from contracts.ERC721_Metadata_base import (
    ERC721_Metadata_tokenURI,
    ERC721_Metadata_setBaseTokenURI,
)
from contracts.interfaces.IERC20 import IERC20



    //
    // Storage
    //

@storage_var
func total_tickets_sold() -> (total_sold: Uint256) {
}

// @storage_var
// func ETH_contract_addrs() -> (eth_address: felt) {
// }
@storage_var
func USDC_contract_addrs() -> (usdc_address: felt) {
}



// namespace ERC721_Tickets {

    //
    // Constructor
    //

    @constructor
    func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        name: felt, 
        symbol: felt, 
        owner: felt, 
        base_token_uri_len: felt,
        base_token_uri: felt*,
        // eth_address: felt,
        usdc_address: felt,
    ) {
        ERC721.initializer(name, symbol);
        ERC721Enumerable.initializer();
        Ownable.initializer(owner);

        ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri);
        
        let sold_tickets = Uint256(0, 0);
        total_tickets_sold.write(sold_tickets);
        // ETH_contract_addrs.write(eth_address);
        USDC_contract_addrs.write(usdc_address);

        Proxy.initializer(owner);
        return ();
    }



    //
    // Getters
    //

    @view
    func totalSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
        totalSupply: Uint256
    ) {
        let (totalSupply: Uint256) = ERC721Enumerable.total_supply();
        return (totalSupply=totalSupply);
    }

    @view
    func totalTicketsSold{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
        soldTickets: Uint256
    ) {
        let (soldTickets: Uint256) = total_tickets_sold.read();
        return (soldTickets=soldTickets);
    }

    @view
    func tokenByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        index: Uint256
    ) -> (tokenId: Uint256) {
        let (tokenId: Uint256) = ERC721Enumerable.token_by_index(index);
        return (tokenId=tokenId);
    }

    @view
    func tokenOfOwnerByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        owner: felt, index: Uint256
    ) -> (tokenId: Uint256) {
        let (tokenId: Uint256) = ERC721Enumerable.token_of_owner_by_index(owner, index);
        return (tokenId=tokenId);
    }

    @view
    func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        interfaceId: felt
    ) -> (success: felt) {
        return ERC165.supports_interface(interfaceId);
    }

    @view
    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        return ERC721.name();
    }

    @view
    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
        return ERC721.symbol();
    }

    @view
    func ticketPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (price: Uint256) {
        // let unit_price = Uint256(1000000000000000, 0); // this is 0,001 ETH (18 decimals)
        let unit_price = Uint256(10000000, 0); // this is 10 USDC (6 decimals)
        return (price=unit_price);
    }

    @view
    func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
        balance: Uint256
    ) {
        return ERC721.balance_of(owner);
    }

    @view
    func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
        owner: felt
    ) {
        return ERC721.owner_of(tokenId);
    }

    @view
    func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (token_uri_len: felt, token_uri: felt*) {
        let (token_uri_len, token_uri) = ERC721_Metadata_tokenURI(token_id);
        return (token_uri_len=token_uri_len, token_uri=token_uri);
    }

    @view
    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        return Ownable.owner();
    }



    //
    // Externals
    //

    @external
    func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {


        return ();
    }
// #############################################################################
    // @external
    // func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
    //     // let (eth_address) = ETH_contract_addrs.read();
    //     let (usdc_address) = USDC_contract_addrs.read();
    //     let (user_adrs) = get_caller_address();
    //     let (ticketsHandlerAdrs) = get_contract_address();
    //     let (BookKeeper) = owner();
    //     let (price: Uint256) = ticketPrice();
    //     with_attr error_message("Couldn't check asset allowance") {
    //         let (allowed_amount: Uint256) = IERC20.allowance(contract_address=usdc_address, owner=user_adrs, spender=ticketsHandlerAdrs);
    //     }
    //     with_attr error_message("incorrect allowance") {
    //         assert allowed_amount = price;
    //     }
    //     // If all the above is successful, then we can proceed to the next steps

    //     // Getting paid
    //     let (success) = IERC20.transferFrom(
    //         contract_address=usdc_address,
    //         sender=user_adrs,
    //         recipient=ticketsHandlerAdrs, // unless I am mistaken, it is impossible to have another recipient that "get_contract_address()" because of the ERC20 standard implementation of "transferFrom()" (=> https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc20/library.cairo#L122 -> _spend_allowance() takes the caller as recipient)
    //         // I am most likely mistaken, though!! just need to think this through! :P
    //         amount=price
    //     );
    //     with_attr error_message("unable to charge the user") {
    //         assert success = 1;
    //     }

    //     // Get the next TokenId
    //     let (last_token_id: Uint256) = total_tickets_sold.read();
    //     let (newTokenId: Uint256) = SafeUint256.add(last_token_id, Uint256(1, 0));
    //     total_tickets_sold.write(newTokenId);

    //     // Minting NFT to user
    //     ERC721Enumerable._mint(user_adrs, newTokenId);

    //     return ();
    // }
// #############################################################################

    @external
    func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
        ERC721.assert_only_token_owner(tokenId);

        ERC721Enumerable._burn(tokenId);

        let (user_adrs) = get_caller_address();
        let (initial_deposit) = ticketPrice();
        // let (eth_address) = ETH_contract_addrs.read();
        let (usdc_address) = USDC_contract_addrs.read();
        let (success) = IERC20.transfer(contract_address=usdc_address, recipient=user_adrs, amount=initial_deposit);
        with_attr error_message("deposit retrieval failed") {
            assert success = 1;
        }

        return ();
    }


    @external
    func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        base_token_uri_len: felt, base_token_uri: felt*
    ) {
        Ownable.assert_only_owner();
        ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri);
        return ();
    }

    @external
    func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        newOwner: felt
    ) {
        Ownable.transfer_ownership(newOwner);
        return ();
    }







    // #############################################################################
    @external
    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_implementation: felt
    ) -> () {
        Proxy.assert_only_admin();
        Proxy._set_implementation_hash(new_implementation);
        return ();
    }

            // I TRIED TO 'UPGRADE' WITH A NEW CAIRO-0 CONTRACT CLASS-HASH BUT IT DID NOT WORK :(
            // => perhaps because I kept '@constructor' in my new contract ??? 
            // see https://docs.openzeppelin.com/contracts-cairo/0.6.1/proxies#implementation_contract

    // #############################################################################



// } // end of namespace