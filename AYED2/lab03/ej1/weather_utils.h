#ifndef WEAYHER_UTILS_H
#define WEAYHER_UTILS_H

#include "array_helpers.h"

int lower_min_temp(WeatherTable a);

void max_temp_by_year(WeatherTable a, int max_temp[YEARS]);

void max_rainfall_month(WeatherTable a, month_t years[YEARS]);

#endif