%lang starknet

//
// Libraries to import
//
from starkware.starknet.common.syscalls import (
    get_block_number,
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.cairo.common.cairo_builtins import HashBuiltin

from openzeppelin.upgrades.library import Proxy

from contracts.utils.UintToFelt import uint256_to_felt



//
// Interface(s)
//

// To interact with the Pragma Oracle VRF contract
// (https://testnet.starkscan.co/contract/0x0681a206bfb74aa7436b3c5c20d7c9242bc41bc6471365ca9404e738ca8f1f3b)
@contract_interface
namespace IRandomness {
    func request_random(seed, callback_address, callback_gas_limit, publish_delay, num_words) -> (
        request_id: felt
    ) {
    }
}



//
// Constants
//
const ORACLE_ADDRESS = 0x681a206bfb74aa7436b3c5c20d7c9242bc41bc6471365ca9404e738ca8f1f3b;



//
// Storage
//
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

// Define a storage variable to hold the minimum block number for randomness publication.
@storage_var
func min_block_number_storage() -> (min_block_number: felt) {
}

// Define a storage variable to hold the last generated random number.
@storage_var
func last_random_storage() -> (res: felt) {
}

// @storage_var
// func xxx(xxx: xxx) -> (xxx: xxx) {
// }



// namespace Lottery {

    @constructor
    func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        lottery_init_state: felt
    ) {
        let lottery_id = Uint256(1, 0);
        drawId.write(lottery_id);

        // initial lotoStatus must be: "CLOSED"
        lotoStatus.write(lottery_init_state); 

        let (currentBlock) = get_block_number();
        min_block_number_storage.write(currentBlock);

        return ();
    }


//
// Internal functions
//
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
        // alloc_locals;
        // local (winning_ticket_id) = drawedNumber.read(draw_id);
        let (winning_ticket_id) = drawedNumber.read(draw_id);
        let (ticket_id_felt) = uint256_to_felt(winning_ticket_id);
        with_attr error_message("tiketID cannot be zero") {
            assert_not_zero(ticket_id_felt);
        }
        // let (winning_ticket_id) = drawedNumber.read(draw_id);
        // with_attr error_message("tiketID cannot be zero") {
        //     assert_not_zero(uint256_to_felt(winning_ticket_id));
        // }

        let (winning_ticket_id) = drawedNumber.read(draw_id);
        return (winning_ticket_id=winning_ticket_id);
    }

    // Define a view function to retrieve the last generated random number.
    @view
    func get_last_random{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        last_random: felt
    ) {
        let (last_random) = last_random_storage.read();
        return (last_random=last_random);
    }



//
// External functions
//
    // Créer une fonction externe qui lance un nouveau tirage
    @external
    func runLotteryDraw{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        // seed, callback_address, callback_gas_limit, publish_delay, num_words
    ) 
    // -> (request_id: felt)
    {
        let (thisDraw) = currentDrawId();
        let (seed) = uint256_to_felt(thisDraw); // il faudra modifier la seed, OBJECTIF => avoir une seed inprévisible et qui doit etre a chaque fois une nouvelle

        // let seed = hash(request_address, hash(nonce, block_timestamp)); // I NEED TO ASK PRAGMA TEAM EXACTLY WHICH NONCE AM I SUPPOSED TO PROVIDE HERE,
        // AS WELL AS HOW TO USE 'hash' FUNCTION BECAUSE I CAN ONLY FIND A 'hash2' FUNCTION IN THE STARKNET LIBRARY NAMED 'hash.cairo'.
        let (callback_address) = get_contract_address();
        let callback_gas_limit = 99999999999999;
        let publish_delay = 1;
        let num_words = 1;
        let (request_id) = requestRandomNumber(seed, callback_address, callback_gas_limit, publish_delay, num_words);

        lotoStatus.write(1330660686);

        return ();
        // return (request_id=request_id);
    }



    // Créer une fonction interne pour obtenir un nbre aléatoire via Pragma Oracle VRF(https://docs.pragmaoracle.com/docs/starknet/randomness/randomness#sample-code)
        // => Le nombre généré doit être inférieur au nombre total de tickets en circulation (du contrat "Tickets.cairo" déployé)
    @external
    func requestRandomNumber{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        seed, callback_address, callback_gas_limit, publish_delay, num_words
    ) 
        // -> (request_id: felt) 
    {
        // Make sure the caller is the contract owner or an authorized entity to add a layer of security.

        // Request a random number from the Pragma Oracle VRF contract.
        let (request_id) = IRandomness.request_random(
            ORACLE_ADDRESS, seed, callback_address, callback_gas_limit, publish_delay, num_words
        );

        // Get the current block number and calculate the minimum block number for randomness publication.
        let (current_block_number) = get_block_number();
        min_block_number_storage.write(current_block_number + publish_delay);

        // TODO: Write in Storage the request_id (probably bad practice but it seems it can't be returned - at least not from this function)
            // *First I need to create a new Storage*

        // return (request_id=request_id); // does not return anything... I assume external/invoke functions can't return stuff?
        // Maybe I should publish an event with the request_id???

        return ();
    }


    // Define an external function to receive random numbers from the oracle.
    @external
    func receive_random_words{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        requestor_address, request_id, random_words_len, random_words: felt*
    ) {
        // Ensure that the caller is the Pragma Oracle VRF contract.
        let (caller_address) = get_caller_address();
        assert ORACLE_ADDRESS = caller_address;

        // -> and that the current block is within publish_delay of the request block
        let (current_block_number) = get_block_number();
        let (min_block_number) = min_block_number_storage.read();
        assert_le(min_block_number, current_block_number);

        // -> and that the requestor_address is what we expect it to be (can be self
        // or another contract address), checking for self in this case.
        let (contract_address) = get_contract_address();
        assert requestor_address = contract_address;

        // Optionally: Can also make sure that request_id is what you expect it to be,
        // and that random_words_len==num_words

        // Your code using randomness!
        let random_word = random_words[0];

        // Store the generated random word in storage for future use.
        last_random_storage.write(random_word);

        lotoStatus.write(1499838177848169747448773747777945406404318291);

        return ();
    }

    // Vérifier que le nbre aléatoire obtenu corresponde à la fois :
        // -> à un tokenId existant (dans le contrat 'Tickets.cairo' déployé);
        // -> à un tokenId dont le 'ownerOf' =/= 0;



    // Ecrire dans le storage le n° du ticket gagnant
    // Ecrire dans le storage l'adresse de l'owner du ticket gagnant



    // Calculer les gains (à implémenter dans un second temps)



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



// } // end of namespace 'Lottery' (I think I have no use of a namespace for the Lottery).



