(* Easy conversion between Futhark values and SML values.  Currently
incomplete, because the required functions are not implemented in all
SML compilers.  The conversion functions are "dynamically checked"
because all Futhark values have the same ML type.  They will raise a
Domain exception if the Futhark value has the wrong underlying
type. *)
signature CONVERT = sig

  structure u32 : sig
              val fromFuthark : Data.value -> Word32.word
              val toFuthark : Word32.word -> Data.value
            end

  structure u64 : sig
              val fromFuthark : Data.value -> Word64.word
              val toFuthark : Word64.word -> Data.value
            end

  structure i64 : sig
              val fromFuthark : Data.value -> Int64.int
              val toFuthark : Int64.int -> Data.value
            end

  (* Assumes real is Real64 *)
  structure f64 : sig
              val fromFuthark : Data.value -> real
              val toFuthark : real -> Data.value
            end

  structure bool : sig
              val fromFuthark : Data.value -> bool
              val toFuthark : bool -> Data.value
            end

end
