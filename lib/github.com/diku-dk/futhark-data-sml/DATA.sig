signature DATA = sig

(* The shape of a Futhark value.  Scalars have an empty shape. *)
type shape = int list

(* The element type of a Futhark value. *)
datatype elem_type = i8 | i16 | i32 | i64 | u8 | u16 | u32 | u64 | bool | f32 | f64

(* A Futhark value. *)
type value

(* Retrieve the raw bytes corresponding to the elements of the Futhark
value.  You're on your own for converting the bytes to more useful SML
types. *)
val valueBytes : value -> Word8Vector.vector

(* Retrieve the shape of a Futhark value. *)
val valueShape : value -> shape

(* Retrieve the element type of a Futhark value. *)
val valueElemType : value -> elem_type

(* Read a Futhark value in the binary data format from an open file. *)
val readValue : BinIO.instream -> value

(* Write a Futhark value in the binary data format to an open file. *)
val writeValue : value -> BinIO.outstream -> unit

end
