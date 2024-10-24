module [
    findMap,
]

findMap : List a, (a -> Result b *) -> Result b [NotFound]
findMap = \list, fun ->
    list
    |> List.walkUntil (Err NotFound) \_, elem ->
        when fun elem is
            Ok out -> Break (Ok out)
            Err _ -> Continue (Err NotFound)
