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
    // ERC721_Metadata_initializer,
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

@storage_var
func ETH_contract_addrs() -> (eth_address: felt) {
}

// @storage_var
// func PoC_account_addrs() -> (PoC_account: felt) {
// }


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
    // token_uri_suffix: felt,
    eth_address: felt,
    // poc_address: felt
) {
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);

    // ERC721_Metadata_initializer(); // no need -> it's already being initialized by ERC721_initializer
    // ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri, token_uri_suffix);
    ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri);
    
    let sold_tickets = Uint256(0, 0);
    total_tickets_sold.write(sold_tickets);
    ETH_contract_addrs.write(eth_address);
    // PoC_account_addrs.write(owner); // in fact this is useless, because I already have the 'owner' in the contract's Storage !!!

    // Proxy.initializer(owner);
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
    let unit_price = Uint256(1000000000000000, 0);
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

// @view
// func AccountOfPoC{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (PoC_account: felt) {
//     return PoC_account_addrs.read();
// }

// @view
// func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     tokenId: Uint256
// ) -> (approved: felt) {
//     return ERC721.get_approved(tokenId);
// }

// @view
// func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     owner: felt, operator: felt
// ) -> (approved: felt) {
//     return ERC721.is_approved_for_all(owner, operator);
// }

// @view
// func imageURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (image_uri: felt) {
//     return _imageURI();
// }



//
// Externals
//

@external
func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    // to: felt, tokenId: Uint256
    // to: felt
) {
    // Ownable.assert_only_owner();

    let (eth_address) = ETH_contract_addrs.read();
    let (user_adrs) = get_caller_address();
    let (PoC_contract) = get_contract_address();
    let (price: Uint256) = ticketPrice();
    with_attr error_message("Couldn't check ETH allowance") {
        let (allowed_amount: Uint256) = IERC20.allowance(contract_address=eth_address, owner=user_adrs, spender=PoC_contract);
    }
    with_attr error_message("incorrect ETH allowance") {
        assert allowed_amount = price;
    }
    // // If all the above is successful, then we can process the next steps

        // NOTES FOR SELF:
    // -> the ERC20 standard function 'transferFrom(sender, recipient, amount)' from the ETH contract will make a call 
    // to the ERC20 standard function '_spend_allowance(owner, spender, amount).

    // ATTENTION: Because '_spend_allowance()' requires that the caller == recipient of payment,
    // NOTE THAT IT IS IMPOSSIBLE TO SET ANOTHER ADDRESS THAN THE TICKET MANAGER AS RECEIVER OF THE PAYMENT!
    // (= I can not manage the users funds that I will receive as payments in a separate account contract)
    
    // https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc20/library.cairo#L118
    // https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc20/library.cairo#L284

    // // Getting paid
    let (success) = IERC20.transferFrom(
        contract_address=eth_address,
        sender=user_adrs,
        recipient=PoC_contract,
        amount=price
    );
    with_attr error_message("unable to charge the user") {
        assert success = 1;
    }

    // Get the next TokenId
    let (last_token_id: Uint256) = total_tickets_sold.read();
    let (newTokenId: Uint256) = SafeUint256.add(last_token_id, Uint256(1, 0));
    total_tickets_sold.write(newTokenId);

    // Minting NFT to user
    ERC721Enumerable._mint(user_adrs, newTokenId);

    // Send the user's funds to an account-contract (the 'owner' of this contract)
    let (PoC_owner) = owner();
    let (eth_address) = ETH_contract_addrs.read();
    let (user_adrs) = get_caller_address();
    let (price: Uint256) = ticketPrice();
    // there must be a way not to have to declare again those variables,
    // but if I don't I get an error: Reference 'xxx' was revoked.
    IERC20.transfer(contract_address=eth_address, recipient=PoC_owner, amount=price);

    return ();
}

@external
func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
    ERC721.assert_only_token_owner(tokenId);
    ERC721Enumerable._burn(tokenId);
    return ();
}


@external
func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    // base_token_uri_len: felt, base_token_uri: felt*, token_uri_suffix: felt
    base_token_uri_len: felt, base_token_uri: felt*
) {
    Ownable.assert_only_owner();
    ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri);
    // ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri, token_uri_suffix);
    return ();
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @external
// func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     Ownable.renounce_ownership();
//     return ();
// }

// @external
// func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
//     to: felt, tokenId: Uint256
// ) {
//     ERC721.approve(to, tokenId);
//     return ();
// }

// @external
// func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     operator: felt, approved: felt
// ) {
//     ERC721.set_approval_for_all(operator, approved);
//     return ();
// }

// @external
// func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
//     from_: felt, to: felt, tokenId: Uint256
// ) {
//     ERC721Enumerable.transfer_from(from_, to, tokenId);
//     return ();
// }

// @external
// func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
//     from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
// ) {
//     ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
//     return ();
// }

// @external
// func setImageURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
//     URI: felt
// ) {
//     Ownable.assert_only_owner();
//     ERC721_image_uri.write(URI);
//     return ();
// }

    //
    // Internals
    //

// func _imageURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (image_uri: felt) {
//     return ERC721_image_uri.read();
// }









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