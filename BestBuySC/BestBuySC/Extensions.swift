//
//  Extensions.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import Foundation
import Loggerithm

extension Loggerithm {
    static func newLogger() -> Loggerithm {
        // .All, .Verbose, .Debug, .Info, .Warning, .Error, .Off
        return newLogger(LogLevel.All)
    }
    static func newLogger(logLevel: LogLevel) -> Loggerithm {
        var log = Loggerithm()
        log.logLevel = logLevel
        log.showDateTime = false
        log.showLineNumber = true
        log.showFileName = true
        log.showFunctionName = true
        log.showLogLevel = true
        // NOTE: In order to set colors see: https://github.com/robbiehanson/XcodeColors
        //       Used color-scheme from KlicApp: (pink,greenish)Colors
        log.verboseColor = UIColor(red: 22/255.0, green: 116/255.0, blue: 0/255.0, alpha: 1.0)
        log.debugColor = UIColor.blackColor()
        log.infoColor = UIColor(red: 255/255.0, green: 58/255.0, blue: 159/255.0, alpha: 1.0)
        return log
    }
}