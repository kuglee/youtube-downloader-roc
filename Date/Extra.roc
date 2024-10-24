module [
    dateToWeekday,
    weekdayToDate,
]

import isodate.Date
import Num.Extra

dateToWeekday = \date ->
    Date.weekday date.year date.month date.dayOfMonth

weekdayToDate : U8, Date.Date -> Date.Date
weekdayToDate = \weekday, startDate ->
    startDateWeekday = dateToWeekday startDate |> Num.toI8
    weekdayInt = Num.toI8 weekday
    dayDiff = Num.Extra.mod (weekdayInt - startDateWeekday) 7

    Date.addDays startDate dayDiff

expect
    expected = { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 4, dayOfYear: 4 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 5, dayOfYear: 5 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 12, dayOfYear: 12 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 6, dayOfYear: 6 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 12, dayOfYear: 12 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 13, dayOfYear: 13 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 7, dayOfYear: 7 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 12, dayOfYear: 12 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 13, dayOfYear: 13 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 14, dayOfYear: 14 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 8, dayOfYear: 8 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 12, dayOfYear: 12 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 13, dayOfYear: 13 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 14, dayOfYear: 14 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 15, dayOfYear: 15 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 9, dayOfYear: 9 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 11, dayOfYear: 11 }
    actual = weekdayToDate 0 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 12, dayOfYear: 12 }
    actual = weekdayToDate 1 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 13, dayOfYear: 13 }
    actual = weekdayToDate 2 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 14, dayOfYear: 14 }
    actual = weekdayToDate 3 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 15, dayOfYear: 15 }
    actual = weekdayToDate 4 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 16, dayOfYear: 16 }
    actual = weekdayToDate 5 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual

expect
    expected = { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    actual = weekdayToDate 6 { year: 1970, month: 1, dayOfMonth: 10, dayOfYear: 10 }
    expected == actual
