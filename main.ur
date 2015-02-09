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
style loading
style clickable

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

fun generate_menu body_class loading_source date_input_source when_source giants_source sharks_source permalink menu_visible =
  show_menu <- signal menu_visible;
  let val menu_button = <xml>
            <div class="menubutton" onclick={fn _ => set menu_visible True}>
              <div class="menubar" />
              <div class="menubar" />
              <div class="menubar" />
            </div>
          </xml>
      fun update_page () =
        date <- get date_input_source;
        let val when = (parse_mdy date) in
          set loading_source True;
          rpcRes <- rpc (day_status when);
          let val (gg, sg) = rpcRes in
            set giants_source gg;
            set sharks_source sg;
            set when_source when;
            set loading_source False
          end
        end
      fun maybe_submit k = if k.KeyCode = 13 then update_page () else return {}
      val menu_area = <xml>
            <div class="menuoptions">
                <ctextbox size=9 source={date_input_source} onkeypress={maybe_submit}>test</ctextbox>
                <div class="clickable" onclick={fn _ => update_page ()}>Check</div>
                <div>{permalink}</div>
            </div>
          </xml>
  in
  return <xml>
    <div class={classes body_class menu}>
      {if show_menu then menu_area else menu_button}
    </div>
  </xml>
  end

and day_status when =
  giants_game <- Giants.getActiveGame when;
  sharks_game <- Sharks.getActiveGame when;
  return (giants_game, sharks_game)

fun check_status when =
  giants_game <- Giants.getActiveGame when;
  sharks_game <- Sharks.getActiveGame when;
  giants_source <- source giants_game;
  sharks_source <- source sharks_game;
  currentTime <- now;
  menu_visible <- source False;
  when_source <- source when;
  date_input_source <- source (timef "%D" when);
  loading_source <- source False;
  let fun giants_body () =
          game <- signal giants_source;
          case game of
            None => return <xml></xml>
          | Some game => return <xml><div class="details giants">{[timef "%H:%M" game.When]}: Giants play {[game.Who]} at {[game.Where]}</div></xml>
      fun sharks_body () =
          game <- signal sharks_source;
          case game of
            None => return <xml></xml>
          | Some game => return <xml><div class="details sharks">{[timef "%H:%M" game.When]}: Sharks play {[game.Who]}</div></xml>
      fun game_suck s = game <- signal s; when <- signal when_source; return (suck_type game when)
      fun giants_suck () = game_suck giants_source
      fun sharks_suck () = game_suck sharks_source
      fun body_class () =
          giants_game <- signal giants_source;
          sharks_game <- signal sharks_source;
          when <- signal when_source;
          now_loading <- signal loading_source;
          let val suck_classes = case (suck_type giants_game when, suck_type sharks_game when) of
                      (Happy, Happy) => null
                    | (_, Happy) => classes suck giants
                    | (Happy, _) => classes suck sharks
                    | _ => classes suck doublesuck
              val loading_classes = if now_loading then loading else null
          in
            return (classes suck_classes loading_classes)
          end
      fun any_suck () = gs <- giants_suck (); ss <- sharks_suck (); return (gs <> Happy || ss <> Happy)
      fun happy_div () = as <- any_suck (); return (if not as then <xml><span class="happy">No</span></xml> else <xml></xml>)
      fun generateYesNoDiv check classname =
        gs <- giants_suck ();
        ss <- sharks_suck ();
        return let fun make classes value =
          <xml><span class={classes}><div>{[value]}</div><!--div class="whichtime">{[check]}</div--></span></xml>
        in
          if gs = check && ss = check then make classname "Very" else
          if ss = check               then make (classes classname sharks) "Yes" else
          if gs = check               then make (classes classname giants) "Yes" else
          if False                    then <xml>No</xml> else
                                           <xml></xml>
        end
      (*val morning_div = return (generateYesNoDiv Morning morning)*)
      fun afternoon_div () = generateYesNoDiv Afternoon afternoon
      fun date_string () =
        when <- signal when_source;
        date <- return (timef "%D" when);
        if timef "%D" currentTime = date
        then return <xml>today</xml>
        else return <xml>on {[date]}</xml>
      val permalink =
        <xml><dyn signal={
          when <- signal when_source;
          return <xml><a link={on (datetimeYear when) (datetimeMonth when + 1) (datetimeDay when)}>permalink</a></xml>
        }></dyn></xml>
      val contact_email = "comments-" ^ (timef "%s" currentTime) ^ "@willcaltrainsucktoday.com"
  in
    return
    <xml>
      <head>
        <title>Will Caltrain suck today?</title>
        <link href="/css/site.css" rel="stylesheet" type="text/css" />
        <link href="http://fonts.googleapis.com/css?family=Permanent+Marker" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <div dynClass={bc <- body_class (); return (classes bodydiv bc)} onmousedown={fn _ => set menu_visible False}>
          <h1 class="header">Will Caltrain suck <dyn signal={date_string ()} />?</h1>
          <div class="yesno">
            <dyn signal={happy_div ()} />
            <dyn signal={afternoon_div ()} />
          </div>
          <dyn signal={giants_body ()} />
          <dyn signal={sharks_body ()} />
          <div class="footer"><a link={about ()}>about</a><div class="contact">{[contact_email]}</div></div>
        </div>
        <dyn signal={bc <- body_class (); generate_menu bc loading_source date_input_source when_source giants_source sharks_source permalink menu_visible} />
      </body>
    </xml>
  end

and index () =
  currentTime <- now;
  let val when = fromDatetime (datetimeYear currentTime) (datetimeMonth currentTime) (datetimeDay currentTime) 0 0 0 in
  check_status when
  end

and on year month day =
  let val when = fromDatetime year (month - 1) day 0 0 0 in
  check_status when
  end
