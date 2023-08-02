// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.6.1 
// (https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.6.1/src/openzeppelin/token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
// from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.upgrades.library import Proxy

from contracts.ERC721_Metadata_base import (
    // ERC721_Metadata_initializer,
    ERC721_Metadata_tokenURI,
    ERC721_Metadata_setBaseTokenURI,
)




//
// Storage
//

// @storage_var
// func ERC721_image_uri() -> (image_uri: felt) {
// }


// @storage_var
// func ETH_contract_addrs() -> (address: felt) {
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
    // eth_address: felt
) {
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);

    // ERC721_Metadata_initializer(); // no need -> it's already being initialized by ERC721_initializer
    // ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri, token_uri_suffix);
    ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri);


    // Proxy.initializer(owner);
    // ETH_contract_addrs.write(eth_address);
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

// @view
// func ticketPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (price: Uint256) {
//     let unit_price = Uint256(5000000000000000, 0);
//     return (price=unit_price);
// }

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
    // to: felt
    to: felt, tokenId: Uint256
) {
    // Ownable.assert_only_owner();
    
    // let tokenId: Uint256 = last_token_id + 1;
    ERC721Enumerable._mint(to, tokenId);
 
    // let (tokenURI: felt) = imageURI();
    // setTokenURI(tokenId, tokenURI);
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