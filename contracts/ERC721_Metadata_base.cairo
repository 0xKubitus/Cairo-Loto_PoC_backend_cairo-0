%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc721.library import ERC721

from openzeppelin.introspection.erc165.library import ERC165

from contracts.utils.ShortString import uint256_to_ss
from contracts.utils.Array import concat_arr

//
// Storage
//

@storage_var
func ERC721_base_token_uri_len() -> (res: felt) {
}

@storage_var
func ERC721_base_token_uri(index: felt) -> (res: felt) {
}

// @storage_var
// func ERC721_base_token_uri_suffix() -> (res: felt) {
// }

//
// Constructor
//

// func ERC721_Metadata_initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     ) {
//     // register IERC721_Metadata
//     ERC165.register_interface(0x5b5e139f);
//     return ();
// }

func ERC721_Metadata_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (token_uri_len: felt, token_uri: felt*) {
// Allocate space for local variables
    alloc_locals;

    // Check if the ERC721 token with the given ID exists
    let exists = ERC721._exists(token_id);
    assert exists = 1;

    // Allocate memory for storing the base token URI and retrieve its length
    let (local base_token_uri_len) = ERC721_base_token_uri_len.read();
    let (local base_token_uri) = alloc();

    _ERC721_Metadata_baseTokenURI(base_token_uri_len, base_token_uri);

// ####################################################
// removed for proof of concept because I am not using suffix (each NFT having the same tokenURI)

    // // Transform 'token_id' into a shortstring and assign it to a variable
    // let (token_id_ss_len, token_id_ss) = uint256_to_ss(token_id);
    // // Concatenates 'token_uri_len', 'token_uri', and the shortstring created just before into a single array
    // let (token_uri_temp, token_uri_len_temp) = concat_arr(
    //     base_token_uri_len, base_token_uri, token_id_ss_len, token_id_ss
    // );
    // // assign 'token_uri_suffix' to a variable
    // let (ERC721_base_token_uri_suffix_local) = ERC721_base_token_uri_suffix.read();
    // // Allocate memory for 'suffix'
    // let (local suffix) = alloc();
    // // Read the value of 'ERC721_base_token_uri_suffix_local' and store it in 'suffix'
    // [suffix] = ERC721_base_token_uri_suffix_local;
    // // Concatenate 'token_uri_temp', 'token_uri_len_temp', and 'suffix' into the final 'token_uri' array
    // let (token_uri, token_uri_len) = concat_arr(token_uri_len_temp, token_uri_temp, 1, suffix);
// ####################################################

    return (token_uri_len=base_token_uri_len, token_uri=base_token_uri);
}

func _ERC721_Metadata_baseTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_token_uri_len: felt, base_token_uri: felt*
) {
    if (base_token_uri_len == 0) {
        return ();
    }

    let (base) = ERC721_base_token_uri.read(base_token_uri_len);
    assert [base_token_uri] = base;

    _ERC721_Metadata_baseTokenURI(
        base_token_uri_len=base_token_uri_len - 1, base_token_uri=base_token_uri + 1
    );
    return ();
}

func ERC721_Metadata_setBaseTokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
// }(token_uri_len: felt, token_uri: felt*, token_uri_suffix: felt) {
}(token_uri_len: felt, token_uri: felt*) {
    _ERC721_Metadata_setBaseTokenURI(token_uri_len, token_uri);
    ERC721_base_token_uri_len.write(token_uri_len);
    // ERC721_base_token_uri_suffix.write(token_uri_suffix);
    return ();
}

func _ERC721_Metadata_setBaseTokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(token_uri_len: felt, token_uri: felt*) {
    if (token_uri_len == 0) {
        return ();
    }
    ERC721_base_token_uri.write(index=token_uri_len, value=[token_uri]);
    _ERC721_Metadata_setBaseTokenURI(token_uri_len=token_uri_len - 1, token_uri=token_uri + 1);
    return ();
}
