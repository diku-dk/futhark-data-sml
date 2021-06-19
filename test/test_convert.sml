fun test (t, toFuthark, fromFuthark, toString, eq, x) =
    (print("Testing " ^ t ^ " " ^ toString x ^ ": ");
     let val y = fromFuthark (toFuthark x)
     in if eq(x, y) then
          (print "Success.\n"; true)
        else
          (print ("Failed: " ^ toString y ^ "\n"); false)
     end handle e => (print("Failed with exception.\n"); false)
    )

fun u32test x =
    test ("u32", Convert.u32.toFuthark, Convert.u32.fromFuthark, Word32.toString, op=, x)
fun u64test x =
    test ("u64", Convert.u64.toFuthark, Convert.u64.fromFuthark, Word64.toString, op=, x)
fun i64test x =
    test ("i64", Convert.i64.toFuthark, Convert.i64.fromFuthark, Int64.toString, op=, x)
fun f64test x =
    test ("f64", Convert.f64.toFuthark, Convert.f64.fromFuthark, Real.toString, Real.==, x)
fun booltest x =
    test ("bool", Convert.bool.toFuthark, Convert.bool.fromFuthark, Bool.toString, op=, x)

val tests =
    [i64test 0,
     i64test 123456789,
     i64test 9223372036854775807,
     i64test ~1,
     i64test ~9223372036854775808,
     u32test 0w0,
     u32test 0w12345568,
     u64test 0w0,
     u64test 0w123456789,
     u64test 0w9223372036854775807,
     f64test 0.0,
     f64test (1.0/0.0),
     f64test ~1234.0,
     booltest true,
     booltest false]

val () = if List.all (fn x => x) tests
         then OS.Process.exit OS.Process.success
         else OS.Process.exit OS.Process.failure

