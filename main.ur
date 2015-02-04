fun about () =
  return <xml>
    <head><title>Will Caltrain suck today?</title></head>
    <body>
      <p><a href="http://isthereagiantsgametoday.com">That other site</a> created by <a href="http://lauraforrest.com/">Laura Forrest</a> and <a href="http://dailycavalier.com">William Reynolds</a>, two San Franciscans who during 9 months of the year find themselves constantly asking <i>Is there a Giants game today?</i>.</p>
	    <p>That site ripped off and hacked up by Evan Danaher after reading a silly (now private) tweet along the lines of "isthereagiantsgame.com; should be called willcaltrainsucktoday.com".  Then rewritten in <a href="http://www.impredicative.com/ur/">Ur/Web</a> to do avoid spurious round-trips.  And add more features.</p>
      <p>Have an idea? <a href="https://github.com/edanaher/willcaltrainsucktoday/">Fork this project</a> on Github and submit pull requests.</p>
    </body>
  </xml>

fun index () =
  game <- Giants.getGame();
  return let val now = Date.now () in
  <xml>
    <head>
      <title>Will Caltrain suck today?</title>
      <link href="/css/site.css" rel="stylesheet" type="text/css" />
      <link href="http://fonts.googleapis.com/css?family=Permanent+Marker" rel="stylesheet" type="text/css" />
    </head>
    <body>
      <p>The date is {[Date.year now]}-{[Date.month now]}-{[Date.day now]}</p>
      <p>A game is {[game.Who]}</p>
      <a link={about ()}>about</a>
    </body>
  </xml>
  end
