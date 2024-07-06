
#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn set(ref self:TContractState, x:u128);
    fn get(self: @TContractState) -> u128;
}

#[starknet::contract]
mod SimpleStorage {
    #[storage]
    struct Storage {
        stored_data:u128 
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set(ref self:ContractState, x:u128) {
            self.stored_data.write(x);
        }
        fn get() -> u128 {
            self.stored_data.read()
        }
        //writing on a mapping takes2 args, the key and the value to be written
    }
}