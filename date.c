#include "date.h"
#include <stdlib.h>
#include <time.h>

uw_Date_date uw_Date_now(uw_context ctx, uw_Basis_int offset) {
  uw_Date_date uwNow = uw_malloc(ctx, sizeof(uw_Date_date_struct));
  time_t seconds = time(NULL);
  setenv("TZ", "PST8PDT", 1);
  tzset();
  struct tm now;
  localtime_r(&seconds, &now);
  uwNow->day = now.tm_mday;
  uwNow->month = now.tm_mon + 1;
  uwNow->year = now.tm_year + 1900;
  return uwNow;
}

uw_Basis_int uw_Date_day(uw_context ctx, uw_Date_date date) {
  return date->day;
}

uw_Basis_int uw_Date_month(uw_context ctx, uw_Date_date date) {
  return date->month;
}

uw_Basis_int uw_Date_year(uw_context ctx, uw_Date_date date) {
  return date->year;
}
