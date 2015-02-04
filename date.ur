fun now () =
  let val time = C_date.now() in
    return { Year = C_date.year time, Month = C_date.month time, Day = C_date.day time }
  end
