module [
    exactly,
]

import parser.Core exposing [Parser, parsePartial, ParseResult, buildPrimitiveParser]

exactly : Parser input a, U64 -> Parser input (List a)
exactly = \parser, n ->
    buildPrimitiveParser \input ->
        exactlyImpl parser [] input n

exactlyImpl : Parser input a, List a, input, U64 -> ParseResult input (List a)
exactlyImpl = \parser, vals, input, n ->
    result = parsePartial parser input

    if n == 0 then
        Ok { val: vals, input: input }
    else
        when result is
            Err _ ->
                Ok { val: vals, input: input }

            Ok { val: val, input: inputRest } ->
                exactlyImpl parser (List.append vals val) inputRest (n - 1)
