signature DATA = sig

type shape = int list

datatype value
  = u8Value of shape * Word8Array.array
  | u16Value of shape * Word16Array.array
  | u32Value of shape * Word32Array.array
  | u64Value of shape * Word64Array.array
  | i8Value of shape * Int8Array.array
  | i16Value of shape * Int16Array.array
  | i32Value of shape * Int32Array.array
  | i64Value of shape * Int64Array.array
  | boolValue of shape * BoolArray.array
  | f32Value of shape * Real32Array.array
  | f64Value of shape * Real64Array.array

val readValue : BinIO.instream -> value

end
