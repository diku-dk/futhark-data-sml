structure Convert : CONVERT = struct

fun checkScalarOfType v t =
    if Data.valueShape v <> [] orelse Data.valueElemType v <> t
    then raise Domain else ()

structure u32 = struct
fun fromFuthark v =
    let val () = checkScalarOfType v Data.u32
        val bytes = Data.valueBytes v
        fun byte i =
            LargeWord.<<(Word8.toLarge (Word8Vector.sub(bytes,i)), Word.fromInt i*0w8)
    in Word32.fromLarge (byte 0 + byte 1 + byte 2 + byte 3)
    end

fun toFuthark x =
    let fun byte i =
            Word8.fromLarge(Word32.toLarge(Word32.andb(Word32.>>(x,Word.fromInt(8*i)), 0w255)))
    in Data.mkValue [] Data.u32 (Word8Vector.fromList(List.tabulate(4,byte))) end

end

structure u64 = struct
fun fromFuthark v =
    let val () = checkScalarOfType v Data.u64
        val bytes = Data.valueBytes v
        fun byte i =
            LargeWord.<<(Word8.toLarge (Word8Vector.sub(bytes,i)), Word.fromInt i*0w8)
    in Word64.fromLarge (byte 0 + byte 1 + byte 2 + byte 3 + byte 4 + byte 5 + byte 6 + byte 7)
    end

fun toFuthark x =
    let fun byte i =
            Word8.fromLarge(Word64.toLarge(Word64.andb(Word64.>>(x,Word.fromInt(8*i)), 0w255)))
    in Data.mkValue [] Data.u64 (Word8Vector.fromList(List.tabulate(8,byte))) end

end

structure i64 = struct
fun fromFuthark v =
    let val () = checkScalarOfType v Data.i64
        val bytes = Data.valueBytes v
        fun byte i =
            LargeWord.<<(Word8.toLarge (Word8Vector.sub(bytes,i)), Word.fromInt i*0w8)
    in Int64.fromLarge (LargeWord.toLargeIntX (byte 0 + byte 1 + byte 2 + byte 3 + byte 4 + byte 5 + byte 6 + byte 7))
    end

fun toFuthark x =
    let val x = Word64.fromLargeInt (Int64.toLarge x)
        fun byte i =
            Word8.fromLarge(Word64.toLarge(Word64.andb(Word64.>>(x,Word.fromInt(8*i)), 0w255)))
    in Data.mkValue [] Data.i64 (Word8Vector.fromList(List.tabulate(8,byte))) end

end

structure f64 = struct
fun fromFuthark v =
    let val () = checkScalarOfType v Data.f64
        val bytes = Data.valueBytes v
    in PackRealLittle.fromBytes bytes end

fun toFuthark x =
    Data.mkValue [] Data.f64 (PackRealLittle.toBytes x)
end

structure bool = struct

fun fromFuthark v =
    let val () = checkScalarOfType v Data.bool
        val bytes = Data.valueBytes v
    in Word8Vector.sub(bytes,0) <> 0w0 end

fun toFuthark x =
    Data.mkValue [] Data.bool (Word8Vector.fromList [if x then 0w1 else 0w0])
end

end
