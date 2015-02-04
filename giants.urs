type game = { When : time, Who : string, Where : string, Home : bool }
val getActiveGame : time -> transaction (option game)
