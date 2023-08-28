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
from starkware.cairo.common.hash import hash2

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
// Declaration of Constants
//
const ORACLE_ADDRESS = 0x681a206bfb74aa7436b3c5c20d7c9242bc41bc6471365ca9404e738ca8f1f3b;



//
// Storage variables
//
@storage_var
func drawId() -> (draw_ID: Uint256) {
}

@storage_var
func drawedNumber(draw_ID: Uint256) -> (winning_ticket_id: Uint256) {
}

// @storage_var
// func lotoStatus(draw_ID: Uint256) -> (lottery_status: felt) {
// }
@storage_var
func lotoStatus() -> (current_lottery_status: felt) {
}

@storage_var
func min_block_number_storage() -> (min_block_number: felt) {
}

@storage_var
func last_random_storage() -> (res: felt) {
}

@storage_var
func last_request_id_storage() -> (request_id: felt) {
}

// @storage_var
// func xxx(xxx: xxx) -> (xxx: xxx) {
// }



//
// Events
//

@event
func RandomRequestSent(request_id: felt) {
}



//
// Constructor function
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    lottery_init_state: felt
) {
    // Initialize the first lottery_id as: 1
    let lottery_id = Uint256(1, 0);
    drawId.write(lottery_id);

    // initial lotoStatus must be: "CLOSED"
    lotoStatus.write(lottery_init_state); 

    return ();
}


//
// View functions
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
    let (winning_ticket_id) = drawedNumber.read(draw_id);
    // alloc_locals; 
    // local (winning_ticket_id) = drawedNumber.read(draw_id);
        // => instead of re-declaring 'winning_ticket_id' later,
        // I should normally be using 'alloc locals'... but redeclaring it also works apparently
        // (probably bad practice, though)
        
    let (ticket_id_felt) = uint256_to_felt(winning_ticket_id);
    with_attr error_message("tiketID cannot be zero") {
        assert_not_zero(ticket_id_felt);
    }
    
    let (winning_ticket_id) = drawedNumber.read(draw_id);
    return (winning_ticket_id=winning_ticket_id);
}

@view
func get_last_random{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    last_random: felt
) {
    let (last_random) = last_random_storage.read();
    return (last_random=last_random);
}

@view
func get_last_request_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    last_request_id: felt
) {
    return last_request_id_storage.read();
}



//
// External functions
//
@external
func runLotteryDraw{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
    // let (thisDraw) = currentDrawId();
    // let (seed) = uint256_to_felt(thisDraw); 
    // PERHAPS THE ISSUE COMES FROM THE FACT THAT I'M NOT USING A HASH AS A SEED?

    let (thisDraw) = currentDrawId();

    let (request_address) = get_contract_address();
    let (nonce) = uint256_to_felt(thisDraw);
    let (block_timestamp) = get_block_timestamp();

    let (seed) = hash2(request_address, hash2(nonce, block_timestamp));
    let (callback_address) = get_contract_address();
    let callback_gas_limit = 99999999999999;
    let publish_delay = 1;
    let num_words = 1;

    let (request_id) = requestRandomNumber(seed, callback_address, callback_gas_limit, publish_delay, num_words);

    lotoStatus.write(1330660686);

    return ();
    // return (request_id=request_id);
}



@external
func requestRandomNumber{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    seed, callback_address, callback_gas_limit, publish_delay, num_words
) {
    // Make sure the caller is the contract owner or an authorized entity to add a layer of security.
        // (to implement later) 

    // Request a random number from the Pragma Oracle VRF contract.
    let (request_id) = IRandomness.request_random(
        ORACLE_ADDRESS, seed, callback_address, callback_gas_limit, publish_delay, num_words
    );

    // Write in Storage the request_id (probably bad practice but it seems it can't be returned from an invoke/external function)
    last_request_id_storage.write(request_id);

    // Maybe I should publish an event with the request_id?
    RandomRequestSent.emit(request_id: felt);

    // Get the current block number and calculate the minimum block number for randomness publication.
    let (current_block_number) = get_block_number();
    min_block_number_storage.write(current_block_number + publish_delay);

    
    // return (request_id=request_id); // does not return anything... I assume external/invoke functions can't return stuff?
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

    // Verify that the obtained random number corresponds to both:
        // -> an existing tokenId (in the deployed 'Tickets.cairo' contract);
        // -> a tokenId for which 'ownerOf' =/= 0;
    
    // Make sure that the received number is < to the total number of tickets in circulation (from "Tickets.cairo" latest deployed contract)

    // Write the winning ticket number to storage

    // Call 'distribute_rewards()'

    // Change lottery status to 'FINISHED'
    
    return ();
}

// Calculates the gains and distributes the rewards
fn distribute_rewards() {
    // to be implemented 
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




