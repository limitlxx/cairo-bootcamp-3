use starknet::ContractAddress;

#[starknet::interface]
pub trait IAggregator<T> {
    // references Ownable methods
    fn get_ownable_owner(self: @T) -> ContractAddress;
    fn set_ownable_owner(ref self: T, new_owner: ContractAddress);

    // references Counter methods
    fn get_counter_count(self: @T) -> u32;
    fn set_counter_count(ref self: T, amount: u32);


    // references Counter functions
    fn get_aggr_owner(self: @T) -> ContractAddress;
    
    // references KillSwitch methods
    fn set_killswitch(ref self: ContractState, is_on: bool);
}

#[starknet::contract]
mod Aggregator {
    use cairo_bootcamp_3::{
        counter::{ICounsterDispatcher, ICounterDispatcherTrait},
        ownable::{IOwnableDispatcher, IOwnableDispatcherTrait},
        killswitch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait},
    };
    use super::{IAggregator};
    use starknet::{ContractAddress};

    
    #[storage]
    struct Storage {
        aggr_count: u32,
        aggr_owner: ContractAddress,
        ownable_addr: ContractAddress,
        counter_addr: ContractAddress, 
        is_on: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner_addr: ContractAddress, ownable_addr: ContractAddress, counter_addr: ContractAddress) {
        self.aggr_owner.write(owner_addr);
        self.ownable_addr.write(ownable_addr);
        self.counter_addr.write(counter_addr);
        self.is_on.write(false);
    }

    #[abi(embed_v0)]
    impl AggrImpl of IAggregator<ContractState> {
        // references Ownable contract methods
        // returns the address of the ownable contract
        fn get_ownable_owner(
            self: @ContractState, 
        ) -> ContractAddress {
            IOwnableDispatcher { contract_address: self.ownable_addr.read()}.get_owner()
        }

        fn set_ownable_owner(
            ref self: ContractState, new_owner: ContractAddress
        ) {
            IOwnableDispatcher { contract_address: self.ownable_addr.read()}.set_owner(new_owner);
        }

        // references Counter contract methods
        fn get_counter_count(self: @ContractState) -> u32 {
            ICounterDispatcher { contract_address: self.counter_addr.read()}.get_count()
        }

        fn set_counter_count(
            ref self: ContractState, amount: u32
        ) {
            let mut is_on = self.is_on.read();
            assert(is_on == true, "Is_on is set false");
            ICounterDispatcher { contract_address: self.counter_addr.read()}.set_count(amount);
        }

        fn set_killswitch(ref self: ContractState, is_on: bool){
            IKillSwitchDispatcher { contract_address: self.is_on.read()}.set_switch(is_on)
        }

        fn get_aggr_owner(self: @ContractState) -> ContractAddress {
            self.aggr_owner.read()
        }
    }
}
 
// 0x1dd6e81d875e3451d14d418af0f42464bbaec19127465e700fb07cb403eb4cc - ca



