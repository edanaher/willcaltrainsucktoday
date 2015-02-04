
table games : { Year : int, Month : int, Day : int, Hour : int, Minute : int, Home : bool, Who : string, Where : string }

fun getGame () =
  oneRow1 (SELECT * FROM games)
