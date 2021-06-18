structure Data : DATA = struct

type shape = int list

datatype elem_type
  = i8 | i16 | i32 | i64 | u8 | u16 | u32 | u64 | bool | f32 | f64

datatype value_type = value_type of shape * elem_type

datatype value = value of value_type * Word8Vector.vector

fun valueBytes (value (_, bs)) = bs

fun valueShape (value (value_type (shape, _), _)) = shape

fun valueElemType (value (value_type (_, t), _)) = t

(* In bytes. *)
fun elemTypeSize i8 = 1
  | elemTypeSize i16 = 2
  | elemTypeSize i32 = 4
  | elemTypeSize i64 = 8
  | elemTypeSize u8 = 1
  | elemTypeSize u16 = 2
  | elemTypeSize u32 = 4
  | elemTypeSize u64 = 8
  | elemTypeSize f32 = 4
  | elemTypeSize f64 = 8
  | elemTypeSize bool = 1


val binaryFormatMagic = Word8.fromInt (ord #"b")
val binaryFormatVersion = 2

val vecstr = Word8Vector.fromList o map (Word8.fromInt o ord)
fun strvec v =
    implode (List.tabulate (Word8Vector.length v,
                            fn i => chr (Word8.toInt (Word8Vector.sub(v,i)))))

fun readByte s =
    case BinIO.input1 s of
        NONE => raise Fail "Unexpected EOF"
      | SOME b => b

fun readI64 s =
    let val vec = BinIO.inputN (s,8)
        fun byte i = Int64.fromLarge (LargeWord.toLargeInt (LargeWord.<< (Word8.toLarge (Word8Vector.sub(vec,i)), Word.fromInt i*0w8)))
    in byte 0 end

fun readShape 0 s = []
  | readShape i s = Int64.toInt (readI64 s) :: readShape (i-1) s

fun writeI64 s x =
    let val x = Word64.fromInt x
        fun byte i =
            Word8.fromLarge (Word64.toLarge (Word64.andb(Word64.>>(x,Word.fromInt(8*i)), 0w255)))
    in BinIO.output1(s,byte 0);
       BinIO.output1(s,byte 1);
       BinIO.output1(s,byte 2);
       BinIO.output1(s,byte 3);
       BinIO.output1(s,byte 4);
       BinIO.output1(s,byte 5);
       BinIO.output1(s,byte 6);
       BinIO.output1(s,byte 7)
    end

fun writeShape [] _ = ()
  | writeShape (d::ds) s = writeI64 s d before writeShape ds s

fun strToType "bool" = bool
  | strToType "  u8" = u8
  | strToType " u16" = u16
  | strToType " u32" = u32
  | strToType " u64" = u64
  | strToType "  i8" = i8
  | strToType " i16" = i16
  | strToType " i32" = i32
  | strToType " i64" = i64
  | strToType " f32" = f32
  | strToType " f64" = f64
  | strToType s = raise Fail ("Unknown element type: " ^ s)

fun typeToStr bool = "bool"
  | typeToStr u8 = "  u8"
  | typeToStr u16 = " u16"
  | typeToStr u32 = " u32"
  | typeToStr u64 = " u64"
  | typeToStr i8 = "  i8"
  | typeToStr i16 = " i16"
  | typeToStr i32 = " i32"
  | typeToStr i64 = " i64"
  | typeToStr f32 = " f32"
  | typeToStr f64 = " f64"

val shapeElems = foldl op* 1

fun readValue s =
    let val b = readByte s
        val v = readByte s
        val r = Word8.toInt (readByte s)
        val t = BinIO.inputN (s,4)
    in if (b,v) <> (binaryFormatMagic, Word8.fromInt binaryFormatVersion)
       then raise Fail "Invalid header"
       else let val t' = strToType(strvec t)
                val shape = readShape r s
                val bytes = BinIO.inputN(s,shapeElems shape * elemTypeSize t')
            in value (value_type (shape, t'), bytes) end
    end

fun writeValue v s =
    (BinIO.output1(s, binaryFormatMagic);
     BinIO.output1(s, Word8.fromInt binaryFormatVersion);
     BinIO.output1(s, Word8.fromInt (length (valueShape v)));
     BinIO.output(s, strvec (typeToStr (valueElemType v)));
     writeShape (valueShape v) s;
     BinIO.output(s,valueBytes v))
end
