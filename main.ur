fun about () =
  return <xml>
    <head><title>Will Caltrain suck today?</title></head>
    <body>
      <p><a href="http://isthereagiantsgametoday.com">That other site</a> created by <a href="http://lauraforrest.com/">Laura Forrest</a> and <a href="http://dailycavalier.com">William Reynolds</a>, two San Franciscans who during 9 months of the year find themselves constantly asking <i>Is there a Giants game today?</i>.</p>
	    <p>That site ripped off and hacked up by Evan Danaher after reading a silly (now private) tweet along the lines of "isthereagiantsgame.com; should be called willcaltrainsucktoday.com".  Then rewritten in <a href="http://www.impredicative.com/ur/">Ur/Web</a> to do avoid spurious round-trips.  And add more features.</p>
      <p>Have an idea? <a href="https://github.com/edanaher/willcaltrainsucktoday/">Fork this project</a> on Github and submit pull requests.</p>
    </body>
  </xml>

style yesno
style header
style details
style footer
style contact
style suck
style giants
style sharks
style doublesuck
style morning
style afternoon
style happy
style whichtime
style menubutton
style menubar
style menu
style showmenu
style menuoptions
style bodydiv

datatype suckage = Morning | Afternoon | Happy
val suckage_eq = mkEq (fn a b => case (a, b) of
    (Morning, Morning) => True
  | (Afternoon, Afternoon) => True
  | (Happy, Happy) => True
  | _ => False)
val suckage_show = mkShow (fn a => case a of
    Morning => "Morning"
  | Afternoon => "Afternoon"
  | Happy => "Happy")

fun suck_type game when =
  let val mkTime = fromDatetime (datetimeYear when) (datetimeMonth when) (datetimeDay when)
      val morning_start = mkTime 8 0 0
      val morning_end = mkTime 12 0 0
      val afternoon_start = mkTime 17 0 0
      val afternoon_end = mkTime 21 0 0
      fun gameInRange game start finish = case game of
          None => False
        | Some game => (finish >= game.When) && (game.When >= start)
      in
    if gameInRange game morning_start morning_end then Morning else
    if gameInRange game afternoon_start afternoon_end then Afternoon else
    Happy
    end

fun parse_mdy mdy =
  let fun parseInt s default = case read s of None => default | Some n => n
      val month = (parseInt (substring mdy 0 2) 2) - 1
      val day = parseInt (substring mdy 3 2) 1
      val year' = parseInt (substring mdy 6 2) 2015
      val year = if year' < 100 then 2000 + year' else year'
  in
    fromDatetime year month day 0 0 0
  end

fun generate_menu date_signal menu_visible =
  show_menu <- signal menu_visible;
  let val menu_button = <xml>
            <div class="menubutton" onclick={fn _ => set menu_visible True}>
              <div class="menubar" />
              <div class="menubar" />
              <div class="menubar" />
            </div>
          </xml>
      val menu_area = <xml>
            <div class="menuoptions">
                <ctextbox size=9 source={date_signal}>test</ctextbox>
                <button onclick={fn _ => date <- get date_signal; result <- rpc (day_status date); alert("Got ")}>Check</button>
            </div>
          </xml>
  in
  return <xml>
    <div class="menu">
      {if show_menu then menu_area else menu_button}
    </div>
  </xml>
  end

and day_status mdy =
  let val when = parse_mdy mdy in
    giants_game <- Giants.getActiveGame when;
    sharks_game <- Sharks.getActiveGame when;
    return (giants_game, sharks_game)
  end

fun check_status when =
  giants_game <- Giants.getActiveGame when;
  sharks_game <- Sharks.getActiveGame when;
  currentTime <- now;
  menu_visible <- source False;
  date_signal <- source (timef "%D" when);
  let val giants_body = case giants_game of
        None => <xml></xml>
      | Some game => <xml><div class="details giants">{[timef "%H:%M" game.When]}: Giants play {[game.Who]} at {[game.Where]}</div></xml>
      val sharks_body = case sharks_game of
        None => <xml></xml>
      | Some game => <xml><div class="details sharks">{[timef "%H:%M" game.When]}: Sharks play {[game.Who]}</div></xml>
      val giants_suck = suck_type giants_game when
      val sharks_suck = suck_type sharks_game when
      val body_class = case (giants_suck, sharks_suck) of
        (Happy, Happy) => null
      | (_, Happy) => classes suck giants
      | (Happy, _) => classes suck sharks
      | _ => classes suck doublesuck
      val any_suck = giants_suck <> Happy || sharks_suck <> Happy
      val happy_div = if not any_suck then <xml><span class="happy">No</span></xml> else <xml></xml>
      fun generateYesNoDiv check classname =
        let fun make classes value =
          <xml><span class={classes}><div>{[value]}</div><!--div class="whichtime">{[check]}</div--></span></xml>
        in
          if giants_suck = check && sharks_suck = check then make classname "Very" else
          if sharks_suck = check                        then make (classes classname sharks) "Yes" else
          if giants_suck = check                        then make (classes classname giants) "Yes" else
          if any_suck                                   then make (classes classname happy) "No" else
                                                             <xml></xml>
        end
      val morning_div = generateYesNoDiv Morning morning
      val afternoon_div = generateYesNoDiv Afternoon afternoon
      val contact_email = "comments-" ^ (timef "%s" currentTime) ^ "@willcaltrainsucktoday.com"
  in
    return
    <xml>
      <head>
        <title>Will Caltrain suck today?</title>
        <link href="/css/site.css" rel="stylesheet" type="text/css" />
        <link href="http://fonts.googleapis.com/css?family=Permanent+Marker" rel="stylesheet" type="text/css" />
      </head>
      <body class={body_class}>
        <div class="bodydiv" onclick={fn _ => set menu_visible False}>
          <h1 class="header">Will Caltrain suck today?</h1>
          <div class="yesno">
            {happy_div}
            {afternoon_div}
          </div>
          {giants_body}
          {sharks_body}
          <div class="footer"><a link={about ()}>about</a><div class="contact">{[contact_email]}</div></div>
        </div>
        <dyn signal={generate_menu date_signal menu_visible} />
      </body>
    </xml>
  end

fun index () =
  currentTime <- now;
  let val when = fromDatetime (datetimeYear currentTime) (datetimeMonth currentTime) (datetimeDay currentTime) 0 0 0 in
  check_status when
  end

fun on year month day =
  let val when = fromDatetime year (month - 1) day 0 0 0 in
  check_status when
  end
