#[starknet::interface]
pub trait IKillSwitch<T> {
    fn is_active(self: @T) -> bool;
    fn set_switch(ref self: T, is_on: bool);
}

#[starknet::contract]
mod KillSwitch {
    #[storage]
    struct Storage {
        is_active: bool
    }

    #[constructure]
    fn constructor(ref self: ContractAddress, is_active: bool) {
        self.is_active.write(is_active)
    }

    #[abi(embed_v0)]
    impl KillSwitchImpl of IKillSwitch<ContractState> {
        fn is_active(self: ContractState){
            self.is_active.read()
        }

        fn set_switch(ref self: ContractState, is_on: bool){
            self.is_active.write(is_on)
        }
    }

}