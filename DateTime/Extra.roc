module [
    toBasicIsoStr,
]

import isodate.DateTime

toBasicIsoStr = \dateTime ->
    dateTime
    |> DateTime.toIsoStr
    |> Str.replaceEach ":" ""
    |> Str.replaceEach "-" ""
