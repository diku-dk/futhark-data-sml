fun test () =
    let val inf = BinIO.openIn (List.nth (CommandLine.arguments (),0))
        val outf = BinIO.openOut (List.nth (CommandLine.arguments (),1))
        val v = Data.readValue inf
    in Data.writeValue v outf; BinIO.closeOut outf end

val _ = test ()
