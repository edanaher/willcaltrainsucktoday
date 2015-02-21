fun simpletest () =
  src <- source <xml>Hello</xml>;
  let val sg = signal src in
    return <xml>
      <body>
        <dyn signal={signal src} />
        <dyn signal={signal src} />
        <dyn signal={sg} />
        <!--dyn signal={sg} /--> <!-- This line breaks it -->
      </body>
    </xml>
  end

fun want () =
  src <- source 1;
  let val onemore = v <- signal src; return (v + 1)
      val twomore = v <- onemore; return (v + 1)
      fun wrap sg = v <- sg; return <xml>{[v]}</xml>
  in
    return <xml>
      <body>
        <div onclick={fn _ => set src 2}>Change to 2</div>
        <dyn signal={wrap onemore} />
        <!--dyn signal={wrap twomore} /--> <!-- This line breaks it -->
      </body>
    </xml>
  end

fun works () =
  src <- source 1;
  let fun onemore () = v <- signal src; return (v + 1)
      val twomore = v <- onemore (); return (v + 1)
      fun wrap sg = v <- sg; return <xml>{[v]}</xml>
  in
    return <xml>
      <body>
        <div onclick={fn _ => set src 2}>Change to 2</div>
        <dyn signal={wrap (onemore ())} />
        <dyn signal={wrap twomore} />
      </body>
    </xml>
  end
