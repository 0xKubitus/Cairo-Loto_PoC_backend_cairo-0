%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256



@storage_var
func drawId() -> (draw_ID: Uint256) {
}

@storage_var
func drawedNumber(draw_ID: Uint256) -> (winning_ticket_id: Uint256) {
}

// @storage_var
// func lotoStatus(draw_ID: Uint256) -> (current_lottery_status: felt) {
// }
@storage_var
func lotoStatus() -> (current_lottery_status: felt) {
}

// @storage_var
// func xxx(xxx: xxx) -> (xxx: xxx) {
// }



// namespace Lottery {

    @constructor
    func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        lottery_init_state: felt,
    ) {
        let lottery_id = Uint256(1, 0);
        drawId.write(lottery_id);

        // initial lotoStatus must be: "CLOSED"
        lotoStatus.write(lottery_init_state); 

        return ();
    }



    @view
    func currentDrawId{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
        current_draw_id: Uint256
    ) {
        let (current_draw_id: Uint256) = drawId.read();
        return (current_draw_id=current_draw_id);
    }

    @view
    func currentDrawStatus{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
        current_draw_status: felt
    ) {
        let (current_draw_status: felt) = lotoStatus.read();
        return (current_draw_status=current_draw_status);
    }

    @view
    func winningTicketId{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(draw_id: Uint256) -> (
        winning_ticket_id: Uint256
    ) {
        let (winning_ticket_id) = drawedNumber.read(draw_id);
        with_attr error_message("tiketID cannot be zero") {
            assert_not_zero(winning_ticket_id);
        }

        return (winning_ticket_id=winning_ticket_id);
    }



    // Créer une fonction externe qui lance un nouveau tirage



    // Récupérer un nbre aléatoire via Pragma Oracle VRF(https://docs.pragmaoracle.com/docs/starknet/randomness/randomness#sample-code)
        // => Le nombre généré doit être inférieur au nombre total de tickets en circulation (du contrat "Tickets.cairo" déployé)
    @external
    func xxx{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        xxx: xxx, xxx: xxx
    ) {
        xxxxxxxxxxxxxxxxxxxxx;
        return ();
    }


    // Vérifier que le nbre aléatoire obtenu corresponde à la fois :
        // -> à un tokenId existant (dans le contrat 'Tickets.cairo' déployé);
        // -> à un tokenId dont le 'ownerOf' =/= 0;



    // Ecrire dans le storage le n° du ticket gagnant
    // Ecrire dans le storage l'adresse de l'owner du ticket gagnant



    // Calculer les gains (à implémenter dans un second temps)



// } // end of namespace

////////////////////////////////////////////////////////////////////////////////



// %lang starknet

// from starkware.starknet.common.syscalls import (
//     get_block_number,
//     get_caller_address,
//     get_contract_address,
// )

// from starkware.cairo.common.math import assert_le
// from starkware.cairo.common.cairo_builtins import HashBuiltin

// const ORACLE_ADDRESS = 0x681a206bfb74aa7436b3c5c20d7c9242bc41bc6471365ca9404e738ca8f1f3b;

// @storage_var
// func min_block_number_storage() -> (min_block_number: felt) {
// }

// @storage_var
// func last_random_storage() -> (res: felt) {
// }

// @contract_interface
// namespace IRandomness {
//     func request_random(seed, callback_address, callback_gas_limit, publish_delay, num_words) -> (
//         request_id: felt
//     ) {
//     }
// }

// @view
// func get_last_random{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
//     last_random: felt
// ) {
//     let (last_random) = last_random_storage.read();
//     return (last_random=last_random);
// }

// @external
// func request_my_randomness{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     seed, callback_address, callback_gas_limit, publish_delay, num_words
// ) {
//     let (request_id) = IRandomness.request_random(
//         ORACLE_ADDRESS, seed, callback_address, callback_gas_limit, publish_delay, num_words
//     );

//     let (current_block_number) = get_block_number();
//     min_block_number_storage.write(current_block_number + publish_delay);

//     return ();
// }

// @external
// func receive_random_words{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     requestor_address, request_id, random_words_len, random_words: felt*
// ) {
//     // Have to make sure that the caller is the Empiric Randomness Oracle contract
//     let (caller_address) = get_caller_address();
//     assert ORACLE_ADDRESS = caller_address;

//     // and that the current block is within publish_delay of the request block
//     let (current_block_number) = get_block_number();
//     let (min_block_number) = min_block_number_storage.read();
//     assert_le(min_block_number, current_block_number);

//     // and that the requestor_address is what we expect it to be (can be self
//     // or another contract address), checking for self in this case
//     let (contract_address) = get_contract_address();
//     assert requestor_address = contract_address;

//     // Optionally: Can also make sure that request_id is what you expect it to be,
//     // and that random_words_len==num_words

//     // Your code using randomness!
//     let random_word = random_words[0];

//     last_random_storage.write(random_word);

//     return ();
// }