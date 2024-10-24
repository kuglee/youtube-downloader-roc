app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br",
    parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.7.2/1usTzOOACTpnkarBX0ED3gFESzR4ROdAlt1Llf4WFzo.tar.br",
    isodate: "https://github.com/imclerran/roc-isodate/releases/download/v0.5.1/XHx5wx95nuICKpN8sxMwYnCme5oX_YFbJUL1s6D1feU.tar.br",
}

import Date.Extra
import DateTime.Extra
import List.Extra
import Parser.Extra exposing [exactly]
import isodate.Date exposing [Date]
import isodate.DateTime
import pf.Cmd
import pf.Path
import pf.Stdout
import pf.Utc
import pf.Arg
import pf.Arg.Cli as Cli
import pf.Arg.Opt as Opt
import parser.Core exposing [Parser, chompUntil, chompWhile, const, keep, maybe, oneOf, sepBy, skip]
import parser.String exposing [Utf8, digits, codeunit, string]

ignoredHostsDict : Dict Str {}
ignoredHostsDict =
    Dict.empty {}
    |> Dict.insert "dropbox" {}

hostNameMappingsDict : Dict Str Str
hostNameMappingsDict =
    Dict.empty {}
    |> Dict.insert "youtu" "youtube"

main : Task {} _
main =
    args = Arg.list! {}

    when Cli.parseOrDisplayMessage argParser args is
        Ok (InputFileName inputFileName) ->
            run inputFileName

        Err message ->
            Stdout.line! message

            Task.err (Exit 1 "")

argParser : Cli.CliParser [InputFileName Str]
argParser =
    Opt.str { short: "i", long: "input", help: "The file to process." }
    |> Cli.map InputFileName
    |> Cli.finish {
        name: "youtube-downloader",
    }
    |> Cli.assertValid

run : Str -> Task {} _
run = \inputFileName ->
    inputFilePath = inputFileName |> Path.fromStr
    Stdout.line! "Downloading links from $(inputFilePath |> Path.display)"

    utcNow = Utc.now! {}

    logFileName = "$(dateTimeNow utcNow |> DateTime.Extra.toBasicIsoStr).log"

    inputFile =
        inputFileName
            |> Path.fromStr
            |> readFile
            |> Task.onErr!
                \ReadFileErr message ->
                    Stdout.line! message
                    Task.err (Exit 1 "")
            |> Str.split "\n"

    firstDate = getFirstDate inputFile |> Result.withDefault (dateNow utcNow)
    dateLinksDict = linksToDateLinksDict inputFile firstDate

    (Dict.toList dateLinksDict)
    |> List.map
        \(date, links) ->
            linkCount = List.len links
            links
            |> List.mapWithIndex (\link, index -> download link date index linkCount logFileName)
            |> Task.sequence
    |> Task.sequence
    |> Task.map \_ -> {}

linksToDateLinksDict : List Str, Date -> Dict Date (List Str)
linksToDateLinksDict = \lines, startDate ->
    (dateLinksDict, _) = List.walk lines (Dict.empty {}, startDate) \(dict, currentDate), line ->
        newCurrentDate =
            when String.parseStr hungarianAbbrevDateParser line is
                Ok date ->
                    date

                Err _ ->
                    when String.parseStr relativeDateParser line is
                        Ok weekday ->
                            Date.Extra.weekdayToDate weekday currentDate

                        Err _ ->
                            currentDate

        newDict =
            when getLink line is
                Ok link ->
                    Dict.update dict newCurrentDate \x ->
                        when x is
                            Ok value -> Ok (List.append value link)
                            Err Missing -> Ok [link]

                Err _ ->
                    dict

        (newDict, newCurrentDate)

    dateLinksDict

## Download utils

download : Str, Date.Date, Num *, Num *, Str -> Task {} []_
download = \link, date, index, linkCount, logFileName ->
    hostName = getHostName link |> Result.withDefault "" |> normalizeHostname hostNameMappingsDict
    dateStr = Date.toIsoStr date
    outputPath = "$(hostName)/$(dateStr)"
    message = "$(dateStr): $(Num.toStr (index + 1)) of $(Num.toStr linkCount)"

    Stdout.line! message
    downloadCommand link outputPath logFileName

downloadCommand : Str, Str, Str -> Task {} []_
downloadCommand = \link, outputPath, logFileName ->
    Cmd.exec "bash" ["-c", ytDlpCommand link outputPath]
    |> Task.onErr \CmdError err ->
        when err is
            ExitCode _ -> logFileName |> appendToFile link
            KilledBySignal -> Stdout.line "Child was killed by signal"
            IOError str -> Stdout.line "IOError executing: $(str)"

ytDlpCommand : Str, Str -> Str
ytDlpCommand = \link, outputPath ->
    """
    yt-dlp \\
    -f \"bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/mp4\" \\
    -S vcodec:h264 \\
    -P $(outputPath) \\
    --restrict-filename \\
    -o \"%(title).150B-[%(id)s].%(ext)s\" \\
    $(link) \\
    --cookies-from-browser safari
    """

## URL utils

getLink : Str -> [Err [IgnoredHost, NonLinkConvertible], Ok Str]
getLink = \str ->
    if Str.startsWith str "https://" then
        isIgnoredHost =
            str
            |> getHostName
            |> Result.map \x -> Dict.contains ignoredHostsDict x
            |> Result.withDefault Bool.false

        if isIgnoredHost == Bool.true then
            Err IgnoredHost
        else
            Ok str
    else
        String.parseStr youtubeVideoIdParser str |> Result.mapErr \_ -> NonLinkConvertible

normalizeHostname : v, Dict v v -> v where v implements Hash & Eq
normalizeHostname = \hostName, dict ->
    Dict.get dict hostName |> Result.withDefault hostName

## Date utils

getFirstDate : List Str -> Result Date.Date [NotFound]
getFirstDate = \lines ->
    List.Extra.findMap lines \line -> String.parseStr hungarianAbbrevDateParser line

dateNow : Utc.Utc -> Date.Date
dateNow = \utcNow ->
    utcNow |> Utc.toNanosSinceEpoch |> Date.fromNanosSinceEpoch

dateTimeNow : Utc.Utc -> DateTime.DateTime
dateTimeNow = \utcNow ->
    utcNow |> Utc.toNanosSinceEpoch |> DateTime.fromNanosSinceEpoch

## File operations

readFile : Path.Path -> Task Str [ReadFileErr Str]
readFile = \path ->
    path
    |> Path.readUtf8
    |> Task.mapErr
        \fileReadErr ->
            pathStr = Path.display path

            when fileReadErr is
                FileReadErr _ NotFound ->
                    ReadFileErr "$(pathStr): No such file or directory"

                FileReadErr _ readErr ->
                    readErrStr = Inspect.toStr readErr

                    ReadFileErr
                        """
                        \n\tFailed to read file:
                        \t\t$(pathStr)
                        \tWith error:
                        \t\t$(readErrStr)
                        """

                FileReadUtf8Err _ _ ->
                    ReadFileErr
                        """
                        \n\tI could not read the file:
                        \t\t$(pathStr)
                        \tIt contains charcaters that are not valid UTF-8:
                        \t\t- Check if the file is encoded using a different format and convert it to UTF-8.
                        \t\t- Check if the file is corrupted.
                        \t\t- Find the characters that are not valid UTF-8 and fix or remove them.
                        """

appendToFile : Str, Str -> Task {} []_
appendToFile = \fileName, str ->
    Cmd.exec! "touch" [fileName]

    fileContent = fileName |> Path.fromStr |> readFile!
    newFileContent = "$(fileContent)\n$(str)"

    fileName |> Path.fromStr |> Path.writeUtf8 newFileContent

## Parsers

hungarianAbbrevDateParser : Parser (List U8) Date.Date
hungarianAbbrevDateParser =
    const (\year -> \month -> \day -> Date.fromYmd year month day)
    |> keep digits
    |> skip (string ". ")
    |> keep (monthParser)
    |> skip (string ". ")
    |> keep digits
    |> skip (string ". ")
    |> skip (digits |> sepBy (codeunit ':'))

dayParser : Core.Parser (List U8) U8
dayParser =
    oneOf [
        const 0 |> skip (string "V"),
        const 1 |> skip (string "H"),
        const 2 |> skip (string "K"),
        const 3 |> skip (string "Sze"),
        const 4 |> skip (string "Cs"),
        const 5 |> skip (string "P"),
        const 6 |> skip (string "Szo"),
    ]

monthParser : Core.Parser (List U8) U64
monthParser =
    oneOf [
        const 1 |> skip (string "jan"),
        const 2 |> skip (string "feb"),
        const 3 |> skip (string "már"),
        const 4 |> skip (string "ápr"),
        const 5 |> skip (string "máj"),
        const 6 |> skip (string "jún"),
        const 7 |> skip (string "júl"),
        const 8 |> skip (string "aug"),
        const 9 |> skip (string "szept"),
        const 10 |> skip (string "okt"),
        const 11 |> skip (string "nov"),
        const 12 |> skip (string "dec"),
    ]

relativeDateParser : Parser Utf8 U8
relativeDateParser =
    dayParser
    |> skip (string " ")
    |> skip (digits |> sepBy (codeunit ':'))

youtubeVideoIdParser : Core.Parser (List U8) Str
youtubeVideoIdParser =
    const (\id -> String.strFromUtf8 id |> \x -> "https://www.youtube.com/watch?v=$(x)")
    |> skip (maybe (codeunit ' '))
    |> keep (exactly String.anyCodeunit 11)
    |> skip (codeunit ' ')
    |> skip (codeunit '/')
    |> skip (codeunit ' ')
    |> skip (exactly String.anyCodeunit 4)
    |> skip (codeunit ' ')
    |> skip (exactly String.anyCodeunit 4)
    |> skip (codeunit ' ')
    |> skip (exactly String.anyCodeunit 4)
    |> skip (codeunit ' ')
    |> skip (exactly String.anyCodeunit 4)
    |> skip (codeunit ' ')
    |> skip (exactly String.anyCodeunit 4)

getHostName = \urlStr ->
    String.parseStr hostNameParser urlStr

# doesn't handle subdomains
# if the input contains subdomains, the first subdomain will be returned
hostNameParser =
    const (\x -> String.strFromUtf8 x)
    |> skip (string "https://")
    |> skip (maybe (string "www."))
    |> keep (chompUntil '.')
    |> skip (codeunit '.')
    |> skip (chompWhile \x -> x != '\n')
