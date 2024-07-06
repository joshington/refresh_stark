use starknet::ContractAddress;

#[starknet::interface]
pub trait INameRegistry<TContractState> {
    fn store_name(
        ref self: TContractState, name: felt252, registration_type: NameRegistry::RegistrationType
    );
    fn get_name(self: @TContractState, address: ContractAddress) -> felt252;
    fn get_owner(self: @TContractState) -> NameRegistry::Person;
}

#[starknet::contract]
mod NameRegistry  {
    use starknet::{ContractAddress, get_caller_address, storage_access::StorageBaseAddress};

    #[storage]
    struct Storage {
        names: LegacyMap::<ContractAddress, felt252>,
        owner:Person,
        registration_type:LegacyMap::<ContractAddress, RegistrationType>,
        total_names:u128,
        allowances:LegacyMap::<(ContractAddress, ContractAddress), u256>
    }
    //allos us to define storage mappings using the dedicated LegacyMap type.
    //variables tored in the Storage struct are not stored contiguosly but in diff locaftions in the contract's storage
    //the storage address of a particular variable is determined bythe variable's name, and the eventual keys of the variable
    //if it is a mapping.

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {StoredName: StoredName,}
    #[derive(Drop, starknet::Event)]
    struct StoredName {
        #[key] //indexing events fields allows for more efficient queries and filtering of events.to index a field as a key
        //of an event, simply annotate it with the [#key] attribute .by doing so any indexed field will allow queries of events
        //that contain a given value for that field with O(log(n))time complexity 
        user:ContractAddress,
        name:felt252,
    }

    //on emitting events, state modification  capabilities are rqd, it is not possible to emit events in view funcs.

    #[derive(Drop, Serde, starknet::Store)]
    pub struct Person {
        address:ContractAddress,
        name:felt252,
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub enum RegistrationType {
        finite: u64,
        infinite
    }

    #[constructor]
    fn constructor(ref self:ContractState, owner:Person) {
        self.names.write(owner.address,owner.name);
        self.total_names.write(1);
        self.owner.write(owner);
    }

    //public functions inside an impl block
    //public funcs might also be defined independently under the #[external_v0] attribute.
    //the #[abi(embed_v0)] attribute means that all funcs embedded inside it are implementations of the starknet 
    //interface of the contract and therefore potential entry pts. 
    #[abi(embed_v0)]
    impl NameRegistry of super::INameRegistry<ContractState> {
        fn store_name(ref self:ContractState, name:felt252, registration_type:RegistrationType) {
            let caller = get_caller_address();
            self._store_name(caller, name, registration_type);
        }

        fn get_name(self: @ContractState, address:ContractAddress) -> felt252 {
            self.names.read(address);
        }

        fn get_owner(self:@ContractState) -> Person {
            self.owner.read()
        }
    }

    //standalone public func
    #[external(v0)]
    fn get_contract_name(self:@ContractState) -> felt252 {
        'Name Registry'
    }

    //could be a group of funcs about a same topic
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn _store_name (
            ref self:ContractState, user:ContractAddress, name:felt252,
            registration_type:RegistrationType
        ) {
            let total_names = self.total_names.read();
            self.names.write(user, name);
            self.registration_type.write(user, registration_type);
            self.total_names.write(total_names + 1);
            self.emit(StoredName {user: user, name:name})
        }
    }

    //free function
    fn get_owner_storage_address(self:@ContractState) -> StorageBaseAddress {
        self.owner.address()
    }
    //access the address of a storage variable by calling the address function on the variable.
    //which returns a StorageBaseAddress

    //===to declare a mapping use the LegacyMap type enclosed in angle brackets, specifying the key and value types
}

#[starknet::contract]
mod AbiAttribute {
    #[storage]
    struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl SomeImpl of SomeTrait {
        #[constructor]
        //constructor func
        fn constructor(ref self:ContractState) {}

        #[external(v0]
        //this is a public 
        fn external_function(ref self:ContractState, arg1:felt252) {}

         #[l1_handler]
        // this is a l1_handler function
        fn handle_message(ref self: ContractState, from_address: felt252, arg: felt252) {}

        // this is an internal function
        fn internal_function(self: @ContractState) {}
    }
}

//==adding event
trait Event<T> {
    fn append_keys_and_data(self:T, ref keys: Array<felt252>, ref data:Array<felt252>);
    fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
}

 #[event]
#[derive(Drop, starknet::Event)]
enum Event {
    StoredName: StoredName,
}