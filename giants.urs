type game = { Year : int, Month : int, Day : int, Hour : int, Minute : int, Home : bool, Who : string, Where : string }
val getActiveGame : Date.date -> transaction game
