signature DATA = sig

type shape = int list

datatype elem_type = i8 | i16 | i32 | i64 | u8 | u16 | u32 | u64 | bool | f32 | f64

type value

val valueBytes : value -> Word8Vector.vector
val valueShape : value -> shape
val valueElemType : value -> elem_type

val readValue : BinIO.instream -> value
val writeValue : value -> BinIO.outstream -> unit

end
