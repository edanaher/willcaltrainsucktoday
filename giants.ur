table games : { When: time, Who : string, Where : string, Home : bool }

fun getActiveGame when =
  oneOrNoRows1 (SELECT * FROM games WHERE games.When >= {[when]} AND games.When <= {[addSeconds when 86400]} AND games.Home ORDER BY games.When DESC)
