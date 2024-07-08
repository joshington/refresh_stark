

//=====desnap operator====

//to convert a snapshot back into a regular variable u can use the desnap operator *, which serves as the 
//opposite of the @ operator.
//Only  Copy types can be dsnapped. however, because the value is not modified, the new variable created by the 
//desnap operator reuses the old value, and so desnapping is a completely free operation, just like Copy.

//we want to caclulate the area of a rectangle, but we dont want to take ownership of the rectnaglein the calculate_area
//function, because we might want to use the rectnagle again after the function call.sine our function does

#[derive(Drop)]
struct Rectangle {
	height: u64,
	width: u64,
}

fn main() {
	let rec = Rectangle {height:3, width:10};
	let area = calculate_area(@rec);
	println!("Area: {}", area);


	//now muatting==
	let mut rec = REctangle {height:3, width:10};
	flip(ref rec);
	println!("height: {}, width: {}", rec.height, rec.width);
}

fn calculate_rea(rec: @Rectangle) -> u64 {
	// As rec is a snapshot to a Rectangle, its fields are also snapshots of the fields types.
    // We need to transform the snapshots back into values using the desnap operator `*`.
    // This is only possible if the type is copyable, which is the case for u64.
    // Here, `*` is used for both multiplying the height and width and for desnapping the snapshots.
	*rec.height * *rec.width
}


//==mutable references====

//mutable references are actually mutable values passed to a func that re implicitly returned at the end of the func.
//returning ownership to the calling context.by doing so, they allow u to mutate the value passed while keeping
//ownership of it by returning it automatically at the end of the execution.

//== in cairo a parameter can only be passed as mutable reference using the ref modifier, if the variable is 
//declared as mutable with mut.


fn flip(ref rec: Rectangle) {
	let temp = rec.height;
	rec.height  = rec.width
	rec.width = temp;
}
