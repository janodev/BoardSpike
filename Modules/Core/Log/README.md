# BikiniLog

A Unified logging appender for Swift Log.

### Streaming events

You can stream to console app filtering by process BoardApp. You won’t be able to see a level lower than error, even if you choose Action > Include Debug Messages.

You can stream all events to your terminal using commands like this:
```
xcrun simctl spawn booted log stream --debug --predicate 'category == "ui"'
xcrun simctl spawn booted log stream --debug --predicate 'subsystem == "com.bikini.board.ui"'
xcrun simctl spawn booted log stream --debug --predicate 'process == "BoardApp"' | grep 'com.bikini'
xcrun simctl spawn booted log stream --debug --predicate 'process == "BoardApp"' --style | grep 'com.bikini'
xcrun simctl spawn booted log stream --debug --predicate 'category == "ui"' --style compact | awk '{$5=""; print}'
```

To drop the first five columns from the output:
```
xcrun simctl spawn booted log stream --debug --predicate 'category == "ui"' --style compact | cut -d" " -f5- | grep 'com.bikini'
```

For other options see
```
xcrun simctl spawn booted log help
xcrun simctl spawn booted log help predicates
xcrun simctl spawn booted log stream help
```

### Include origin

Note that the option `--source` produces mangled strings. For instance, this output:
```
<BoardApp`$s3Log11OSLogLoggerV3log5level7message8metadata4file8function4liney7Logging0C0V5LevelO_AM7MessageVSDySSAM13MetadataValueOGSgS2SSutF>
```
can be demangled like this:
```
xcrun swift-demangle '$s3Log11OSLogLoggerV3log5level7message8metadata4file8function4liney7Logging0C0V5LevelO_AM7MessageVSDySSAM13MetadataValueOGSgS2SSutF'
$s3Log11OSLogLoggerV3log5level7message8metadata4file8function4liney7Logging0C0V5LevelO_AM7MessageVSDySSAM13MetadataValueOGSgS2SSutF ---> Log.OSLogLogger.log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: [Swift.String : Logging.Logger.MetadataValue]?, file: Swift.String, function: Swift.String, line: Swift.UInt) -> ()
```
It’s more practical to edit the message of OSLogLogger:67 to include that information in the message.
