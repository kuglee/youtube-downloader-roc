module [
    mod,
]

# from: https://stackoverflow.com/a/20638659/13162032
mod : Int a, Int a -> Int a
mod = \a, b ->
    if Num.isZero b then
        crash "Integer division by 0!"
    else if Num.compare b -1 == True then
        0
    else
        rem = Num.rem a b

        if Num.isNegative rem then
            if Num.isNegative b then
                rem - b
            else
                rem + b
        else
            rem
