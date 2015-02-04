#include <urweb.h>

typedef struct {
  int day;
  int month;
  int year;
} uw_Date_date_struct;

typedef uw_Date_date_struct *uw_Date_date;

uw_Date_date uw_Date_now(uw_context ctx, uw_Basis_int offset);
uw_Basis_int uw_Date_day(uw_context ctx, uw_Date_date date);
uw_Basis_int uw_Date_month(uw_context ctx, uw_Date_date date);
uw_Basis_int uw_Date_year(uw_context ctx, uw_Date_date date);

