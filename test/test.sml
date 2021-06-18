fun test () =
    let val f = BinIO.openIn (List.nth (CommandLine.arguments (),0))
    in Data.readValue f end

val _ = test ()
