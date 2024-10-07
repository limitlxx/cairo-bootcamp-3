pub mod Errors {
    pub const NOT_ZERO: felt252 = 'Values cannot be zero';
}


#[starknet::interface]
pub trait ICounterV2<TContractState> {
    fn get_count(self: @TContractState) -> usize;
    fn set_count(ref self: TContractState, value: usize);
    fn increase_count_by_1(ref self: TContractState);
    fn decrease_count_by_1(ref self: TContractState);
}

#[starknet::contract]
pub mod CounterV2 {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::Errors;

    #[storage]
    struct Storage {
        // Counter variable
        pub counter: usize,
    }


    #[abi(embed_v0)]
    impl CounterV2 of super::ICounterV2<ContractState> {
        fn get_count(self: @ContractState) -> usize {
            self.counter.read()
        }

        fn set_count(ref self: ContractState, value: usize){
            assert(value > 0, Errors::NOT_ZERO);
            let current_count: u128 = self.get_count();
            self.counter.write(current_count + value)
        }

        fn increase_count_by_1(ref self: ContractState) {
            // Store counter value + 1
            let counter = self.counter.read() + 1;
            self.counter.write(counter)
        }

        fn decrease_count_by_1(ref self: ContractState) {
            // Store counter value - 1
            let counter = self.counter.read() - 1;
            self.counter.write(counter)
        }
    }
}
