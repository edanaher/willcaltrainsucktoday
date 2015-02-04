table games : { Year : int, Month : int, Day : int, Hour : int, Minute : int, Home : bool, Who : string, Where : string }

fun getActiveGame date =
  oneRow1 (SELECT * FROM games WHERE games.Year = {[date.Year]} AND games.Month = {[date.Month]} AND games.Day = {[date.Day]})
