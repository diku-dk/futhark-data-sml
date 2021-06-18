structure Data : DATA = struct

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

fun readByte s =
    case BinIO.input1 s of
        NONE => raise Fail "Unexpected EOF"
      | SOME b => b

fun readBools n s =
    let val vec = BinIO.inputN (s,n*1)
    in BoolArray.tabulate(n, fn i => (Word8Vector.sub(vec,i)) <> 0w0) end

fun readI8s n s =
    let val vec = BinIO.inputN (s,n*1)
    in Int8Array.tabulate(n, fn i => Int8.fromLarge (Word8.toLargeInt (Word8Vector.sub(vec,i)))) end

fun readI16s n s =
    let val vec = BinIO.inputN (s,n*2)
    in Int16Array.tabulate(n, fn i => Int16.fromLarge (LargeWord.toLargeInt (PackWord16Little.subVec(vec,i)))) end

fun readI32s n s =
    let val vec = BinIO.inputN (s,n*4)
    in Int32Array.tabulate(n, fn i => Int32.fromLarge (LargeWord.toLargeInt (PackWord32Little.subVec(vec,i)))) end

fun readI64s n s =
    let val vec = BinIO.inputN (s,n*8)
    in Int64Array.tabulate(n, fn i => Int64.fromLarge (LargeWord.toLargeInt (PackWord64Little.subVec(vec,i)))) end

fun readU8s n s =
    let val vec = BinIO.inputN (s,n*1)
    in Word8Array.tabulate(n, fn i => Word8Vector.sub(vec,i)) end

fun readU16s n s =
    let val vec = BinIO.inputN (s,n*2)
    in Word16Array.tabulate(n, fn i => Word16.fromLargeWord (PackWord16Little.subVec(vec,i))) end

fun readU32s n s =
    let val vec = BinIO.inputN (s,n*4)
    in Word32Array.tabulate(n, fn i => Word32.fromLargeWord (PackWord32Little.subVec(vec,i))) end

fun readU64s n s =
    let val vec = BinIO.inputN (s,n*4)
    in Word64Array.tabulate(n, fn i => Word64.fromLargeWord (PackWord64Little.subVec(vec,i))) end

fun readF32s n s =
    let val vec = BinIO.inputN (s,n*4)
    in Real32Array.tabulate(n, fn i => PackReal32Little.subVec(vec,i)) end

fun readF64s n s =
    let val vec = BinIO.inputN (s,n*8)
    in Real64Array.tabulate(n, fn i => PackReal64Little.subVec(vec,i)) end

fun readShape r s =
    let val arr = readI64s r s
    in List.tabulate (r, fn i => Int64.toInt(Int64Array.sub(arr,i))) end

val shapeElems = foldl op+ 0

val vecstr = Word8Vector.fromList o map (Word8.fromInt o ord)
fun strvec v =
    implode (List.tabulate (Word8Vector.length v,
                            fn i => chr (Word8.toInt (Word8Vector.sub(v,i)))))

fun readValueHelper elem_reader constructor r s =
    let val shape = readShape r s
        val vs = elem_reader (shapeElems shape) s
    in constructor (shape, vs) end

val binaryFormatMagic = Word8.fromInt (ord #"b")
val binaryFormatVersion = 2

fun readValue s =
    let val b = readByte s
        val v = readByte s
        val r = Word8.toInt (readByte s)
        val t = BinIO.inputN (s,4)
    in if (b,v) <> (binaryFormatMagic, Word8.fromInt binaryFormatVersion)
       then raise Fail "Invalid header"
       else case strvec t of
                " f32" => readValueHelper readF32s  f32Value  r s
              | " f64" => readValueHelper readF64s  f64Value  r s
              | "  u8" => readValueHelper readU8s   u8Value   r s
              | " u16" => readValueHelper readU16s  u16Value  r s
              | " u32" => readValueHelper readU32s  u32Value  r s
              | " u64" => readValueHelper readU64s  u64Value  r s
              | "  i8" => readValueHelper readI8s   i8Value   r s
              | " i16" => readValueHelper readI16s  i16Value  r s
              | " i32" => readValueHelper readI32s  i32Value  r s
              | " i64" => readValueHelper readI64s  i64Value  r s
              | "bool" => readValueHelper readBools boolValue r s
              | t' => raise Fail ("Unknown element type: \"" ^ t' ^ "\"")
    end
end
