#include "weather_utils.h"

int lower_min_temp(WeatherTable a) {
    int min_temp = a[0][0][0]._min_temp;
    for (unsigned int year = 0u; year < YEARS; ++year) {
        for (month_t month = january; month <= december; ++month) {
            for (unsigned int day = 0u; day < DAYS; ++day) {
                if (a[year][month][day]._min_temp < min_temp) {
                    min_temp = a[year][month][day]._min_temp;
                }
            }
        }
    }
    return min_temp;
}

void max_temp_by_year(WeatherTable a, int max_temp[YEARS]) {
    for (unsigned int year = 0u; year < YEARS; ++year) {
        max_temp[year] = a[year][0][0]._max_temp;
        for (month_t month = january; month <= december; ++month) {
            for (unsigned int day = 0u; day < DAYS; ++day) {
                if (a[year][month][day]._max_temp > max_temp[year]) {
                    max_temp[year] = a[year][month][day]._max_temp;
                }
            }
        }
    }
}

void max_rainfall_month(WeatherTable a, month_t years[YEARS]) {
    for (unsigned int year = 0u; year < YEARS; ++year) {
        years[year] = january;
        unsigned int max_rainfall = a[year][january][0]._rainfall;
        for (month_t month = january; month <= december; ++month) {
            unsigned int rainfall = 0u;
            for (unsigned int day = 0u; day < DAYS; ++day) {
                rainfall += a[year][month][day]._rainfall;
            }
            if (rainfall > max_rainfall) {
                max_rainfall = rainfall;
                years[year] = month;
            }
        }
    }
}