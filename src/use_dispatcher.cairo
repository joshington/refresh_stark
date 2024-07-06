

use starknet::{ContractAddress};

trait IERC20DispatcherTrait<T> {
    fn name(self: T) -> felt252;
    fn transfer(self:T, recipient:ContractAddress, amount:u256);
}

#[derive(Copy, Drop, starknet::Store, Serde)]
struct  IERC20Dispatcher {
    contract_address:ContractAddress,
}

impl IERC20DispatcherImpl of IERC20DispatcherTrait>IERC20Dispatcher> {
    fn name(self:IERC20Dispatcher) -> felt252 {
    }
    fn transfer(
        self:IERC20Dispatcher, recipient:ContractAddress, amount:u256
    ) {
    
    }
}

//calling  using tokenwrapper====
#[starknet::contract]
mod TokenWrapper {
    use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
    use super::ITokenWrapper;
    use starknet::ContractAddress;


    #[storage]
    struct Storage {}

    impl TokenWrapper of ITokenWrapper<ContractState> {
        fn token_name(self: @ContractState, contract_address: ContractAddress) -> felt252 {
            IERC20Dispatcher { contract_address }.name()
        }
        fn transfer_token(
            ref self: ContractState,
            contract_address:ContractAddress,
            recipient:ContractAddress,
            amount: u256
        ) -> bool {
            IERC20Dispatch {contract_address}.transfer(recipient, amount)
        }
    }
}

//how 
#[starknet::interface]
trait ITokenWrapper<TContractState> {
    fn transfer_token(
        ref self: TContractState,
        address: ContractAddress,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) -> bool;
}


#[starknet::contract]
mod TokenWrapper {
    use super::ITokenWrapper;
    use core::serde::Serde;
    use starknet::{SyscallResultTrait, ContractAddress, syscalls};

    #[storage]
    struct Storage {}
    impl TokenWrapper of ITokenWrapper<ContractState> {
        fn transfer_token(
            ref self:ContractState,
            address:ContractAddress,
            sender:ContractAddress,
            recipient:ContractAddress, amount:u256
        ) -> bool {
            let mut call_data:Array<felt252> = ArrayTrait::new();
            Serde::serialize(@sender, ref call_data);
            Serde::serialize(@recipient, ref call_data);
            Serde::serialize(@amount, ref call_data);

            let mut res = syscalls::call_contract_syscall(
                address, selector!("transferFrom"), call_data.span()
            )
                .unwrap_syscall();
        }
    }
}