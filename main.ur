fun about () =
  return <xml>
    <head><title>Will Caltrain suck today?</title></head>
    <body>
      <p><a href="http://isthereagiantsgametoday.com">That other site</a> created by <a href="http://lauraforrest.com/">Laura Forrest</a> and <a href="http://dailycavalier.com">William Reynolds</a>, two San Franciscans who during 9 months of the year find themselves constantly asking <i>Is there a Giants game today?</i>.</p>
	    <p>That site ripped off and hacked up by Evan Danaher after reading a silly (now private) tweet along the lines of "isthereagiantsgame.com; should be called willcaltrainsucktoday.com".  Then rewritten in <a href="http://www.impredicative.com/ur/">Ur/Web</a> to do avoid spurious round-trips.  And add more features.</p>
      <p>Have an idea? <a href="https://github.com/edanaher/willcaltrainsucktoday/">Fork this project</a> on Github and submit pull requests.</p>
    </body>
  </xml>

fun check_status when =
  game <- Giants.getActiveGame when;
  let val giants_body = case game of
    None => <xml><p>No Giants game today</p></xml>
  | Some game => <xml><p>Giants play {[game.Who]} at {[game.Where]}!</p></xml> in
    return
    <xml>
      <head>
        <title>Will Caltrain suck today?</title>
        <link href="/css/site.css" rel="stylesheet" type="text/css" />
        <link href="http://fonts.googleapis.com/css?family=Permanent+Marker" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <p>The date is {[datetimeYear when]}-{[datetimeMonth when + 1]}-{[datetimeDay when]}</p>
        {giants_body}
        <a link={about ()}>about</a>
      </body>
    </xml>
  end

fun index () =
  currentTime <- now;
  let val when = fromDatetime (datetimeYear currentTime) (datetimeMonth currentTime) (datetimeDay currentTime) 0 0 0 in
  check_status when
  end

fun at year month day =
  let val when = fromDatetime year (month - 1) day 0 0 0 in
  check_status when
  end
