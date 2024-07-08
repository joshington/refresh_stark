

use core::dict::Felt252DictEntryTrait;

fn custom_get<T, +Felt252DictValue<T>, +Drop<T>, +Copy<T>>(
    ref dict: Felt252Dict<T>, key: felt252
) -> T {
    // Get the new entry and the previous value held at `key`
    let (entry, prev_value) = dict.entry(key);

    // Store the value to return
    let return_value = prev_value;

    // Update the entry with `prev_value` and get back ownership of the dictionary
    dict = entry.finalize(prev_value);

    // Return the read value
    return_value
}

fn custom_insert<T, +Felt252DictValue<T>, +Destruct<T>, +Drop<T>>()

use core::nullable::{NullableTrait, match_nullable, FromNullableResult};

fn main(){
    //create thed dict
    let mut d: Felt252Dict<Nullable<Span<felt252>>> = Default::default();
    //create the array to insert
    let a = array![8,9,10];
    //insert it as a Span
    d.insert(0, NullableTrait::new(a.span()));

    //get value back
    let val = d.get(0);

    let span = match match_nullable(val) {
        FromNullableResult::Null => panic!("No value found"),
        FromNullableResult::NotNull(val) => val.unbox(), 
    };

    //verify we are having the right values
    assert!(*span.at(0) == 8, "Expecting 8");
    assert!(*span.at(1) == 9, "Expecting 8");
    assert!(*span.at(2) == 10, "Expecting 8");

    let arr = array![20, 19, 26];
    let mut dict: Felt252Dict<Nullable<Array<u8>>> = Default::default();
    dict.insert(0, NullableTrait::new(arr));
    println!("Array inserted successfully");
    //attempting to read an array from the dict using the get mthd will result 
    //get tries to copy the 
}
//to corectly read an array from the dict, we need to use dict entries.this allows us to get a reference to the array
//value without copying it.
fn get_array_entry(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252) -> Span<u8> {
    let (entry, _arr) = dict.entry(index);
    let mut arr = _arr.deref_or(array![]);
    let span = arr.span();
    dict = entry.finalize(NullableTrait::new(arr));
    span
}

fn main(){
	let arr = array![20,19,26];
	let mut dict: Felt252Dict<Nullable<Array<u8>>> = Default::default();
	dict.insert(0, NullableTrait::new(arr));
	println!("Before insertion: {:?}", get_array_entry(ref dict, 0));

	append_value(ref dict, 0, 30);
	println!("After insertion: {:?}", get_array_entry(ref dict, 0));
 }

//=== the Copy Trait=====
//while arrays and dict cant be copied, custom types that dont contain either of them can be.
//You can implement the Copy trait on your type by adding the #[derive(Copy)] annotation to your
//type defn. Cairo wont allow a type to be annotated with Copy if the type itself or any of its cpts doesnt implement the
//Copy trait.

#[derive(Copy, Drop)]
struct Point {
	x:u128,
	y:u128,
}

fn main() {
	let p1 = Point {x:5, y:10};
	foo(p1);
	foo(p1);
}

fn foo(p: Point) {
	
}

//in the above, we can pass p1 twice to the foo function because the Point type implements the Copy trait.
//this means that when we pass p1 to foo, were actually passing a copy of p1, so p1 remains valid.
//in ownership this means that the ownership of p1 remains with the main func.
//if u remove the Copy trait derivation  from the Point type.hence a compile time error



//===No-op Destruction: the Drop Trait
//you may have noticed that the Point type in the

#[derive(Drop)]
struct A {}

fn main() {
	A {}; //error:variable not dropped
	A {dict: Default::default()};
}

//==can aswell use the Destruct trait to squash the dict

#[derive(Destruct)]
struct A {
	dict: Felt252Dict<u128>
}
//types that implement the Drop trait are automatically  destroyed when going out of scope.
