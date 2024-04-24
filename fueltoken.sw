script;

use std::storage::cell::Cell;
use std::storage::collections::HashMap as Map;
use std::prelude::*;

abi Token {
    fn init_supply();
    fn transfer(to: address, amount: u64);
    fn get_balance(account: address) -> u64;
}

contract;

storage {
    total_supply: Cell<u64>,
    balances: Map<address, u64>,
}

impl Token for Contract {
    fn init_supply() {
        let initial_supply = 1000000; // 初始供应量
        self.total_supply.set(initial_supply);
        self.balances.insert(caller(), initial_supply);
    }

    fn transfer(to: address, amount: u64) {
        let caller_balance = self.balances.get(&caller()).unwrap_or_default();
        assert!(caller_balance >= amount, "Insufficient balance.");

        let to_balance = self.balances.get(&to).unwrap_or_default();
        self.balances.insert(caller(), caller_balance - amount);
        self.balances.insert(to, to_balance + amount);
    }

    fn get_balance(account: address) -> u64 {
        self.balances.get(&account).unwrap_or_default()
    }
}
