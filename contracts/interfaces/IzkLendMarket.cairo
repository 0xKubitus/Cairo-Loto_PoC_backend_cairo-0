%lang starknet

@contract_interface
namespace IzkLendMarket {
    // func deposit(token:felt, amount: felt) -> (xxx:???) {} 
        // I do not know what this function is supposed to return, 
        // but using an interface that doesn't expect any return works just fine:
    func deposit(token:felt, amount: felt) {
    }

    func withdraw(token:felt, amount: felt) {
    }

}

