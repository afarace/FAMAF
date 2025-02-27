/*
  @file sort.c
  @brief sort functions implementation
*/

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "helpers.h"
#include "sort.h"
#include "player.h"

bool goes_before(player_t x, player_t y)
{
    if (x.rank < y.rank)
    {
        return true;
    }
    else if (x.rank == y.rank)
    {
        if (x.points < y.points)
        {
            return true;
        }
        else if (x.points == y.points)
        {
            if (x.tournaments < y.tournaments)
            {
                return true;
            }
            else if (x.tournaments == y.tournaments)
            {
                if (x.age < y.age)
                {
                    return true;
                }
                else if (x.age == y.age)
                {
                    if (strcmp(x.name, y.name) < 0)
                    {
                        return true;
                    }
                    else if (strcmp(x.name, y.name) == 0)
                    {
                        if (strcmp(x.country, y.country) < 0)
                        {
                            return true;
                        }
                    }
                }
            }
        }
    }
    return false;
}

bool array_is_sorted(player_t atp[], unsigned int length)
{
    unsigned int i = 1u;
    while (i < length && goes_before(atp[i - 1u], atp[i]))
    {
        i++;
    }
    return (i == length);
}

void sort(player_t a[], unsigned int length)
{
    unsigned int i, j;
    player_t tmp;
    for (i = 1u; i < length; i++)
    {
        tmp = a[i];
        j = i;
        while (j > 0 && goes_before(tmp, a[j - 1u]))
        {
            a[j] = a[j - 1u];
            j--;
        }
        a[j] = tmp;
    }
}
