#include <urweb.h>

typedef struct {
  int day;
  int month;
  int year;
} uw_C_date_date_struct;

typedef uw_C_date_date_struct *uw_C_date_date;

uw_C_date_date uw_C_date_now(uw_context ctx, uw_Basis_int offset);
uw_Basis_int uw_C_date_day(uw_context ctx, uw_C_date_date date);
uw_Basis_int uw_C_date_month(uw_context ctx, uw_C_date_date date);
uw_Basis_int uw_C_date_year(uw_context ctx, uw_C_date_date date);

