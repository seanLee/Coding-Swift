//
//  NSDate+Helper.swift
//  Coding-Swift
//
//  Created by sean on 16/4/24.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation

private var _calendar: NSCalendar?
private var _displayFormatter: NSDateFormatter?

extension NSDate {
    private class var kNSDateHelperFormatFullDateWithTime: String { return "MMM d, yyyy h:mm a"}
    private class var kNSDateHelperFormatFullDate:         String { return "MMM d, yyyy"}
    private class var kNSDateHelperFormatShortDateWithTime:String { return "MMM d h:mm a"}
    private class var kNSDateHelperFormatShortDate:        String { return "MMM d"}
    private class var kNSDateHelperFormatWeekday:          String { return "EEEE"}
    private class var kNSDateHelperFormatWeekdayWithTime:  String { return "EEEE h:mm a"}
    private class var kNSDateHelperFormatTime:             String { return "h:mm a"}
    private class var kNSDateHelperFormatTimeWithPrefix:   String { return "'at' h:mm a"}
    private class var kNSDateHelperFormatSQLDate:          String { return "yyyy-MM-dd"}
    private class var kNSDateHelperFormatSQLTime:          String { return "HH:mm:ss"}
    private class var kNSDateHelperFormatSQLDateWithTime:  String { return "yyyy-MM-dd HH:mm:ss"}
    
    private var minuteInSeconds: Double { return 60 }
    private var hourInSeconds:   Double { return 3600 }
    private var dayInSeconds:    Double { return 86400 }
    private var weekInSeconds:   Double { return 604800 }
    private var yearInSeconds:   Double { return 31556926 }
    
    // MARK: - Singleton
    class func initializeStatics() {
        var onceToken:dispatch_once_t = 0
        dispatch_once(&onceToken) {
            if _calendar == nil {
                _calendar = NSCalendar.currentCalendar()
            }
            if _displayFormatter == nil {
                _displayFormatter = NSDateFormatter();
            }
        }
    }
    
    class func sharedCalendar() -> NSCalendar {
        initializeStatics()
        return _calendar!
    }
    
    class func sharedDateFormatter() -> NSDateFormatter {
        initializeStatics()
        return _displayFormatter!
    }
    
    // MARK: - Class Function
    class func dateStartOfDay(date: NSDate) -> NSDate {
        let gregorian = NSCalendar.currentCalendar()
        let comps = gregorian.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        return gregorian.dateFromComponents(comps) as NSDate!
    }
    
    class func dateStartOfWeek() -> NSDate {
        let gregorian = NSCalendar.currentCalendar()
        gregorian.firstWeekday = 2
        
        let comps = gregorian.components(NSCalendarUnit.Weekday, fromDate: NSDate())
        
        let componentsToSubtract = NSDateComponents()
        componentsToSubtract.day = (((comps.weekday - gregorian.firstWeekday) + 7) % 7) * -1
        
        let beginningOfWeek = gregorian.dateByAddingComponents(componentsToSubtract, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0)) as NSDate!
        
        let componentsStripped = gregorian.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: beginningOfWeek!)
        
        return gregorian.dateFromComponents(componentsStripped) as NSDate!
    }
    
    class func dateEndOfWeek() -> NSDate {
        let gregorian = NSCalendar.currentCalendar()
        gregorian.firstWeekday = 2
        
        let comps = gregorian.components(NSCalendarUnit.Weekday, fromDate: NSDate())
        
        let componentsToAdd = NSDateComponents()
        componentsToAdd.day = ((((comps.weekday - gregorian.firstWeekday) + 7) % 7) + 6)
        
        let endOfWeek =  gregorian.dateByAddingComponents(componentsToAdd, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0)) as NSDate!
        
        let componentsStripped = gregorian.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: endOfWeek!)
        
        return gregorian.dateFromComponents(componentsStripped) as NSDate!
    }
    
    class func dateFormatString() -> String {
        return kNSDateHelperFormatSQLDate
    }
    
    class func timeFormatString() -> String {
        return kNSDateHelperFormatSQLTime
    }
    
    class func timestampFormatString() -> String {
        return kNSDateHelperFormatSQLDateWithTime
    }
    
    class func dbFormatString() -> String {
        return self.timestampFormatString()
    }
    
    class func dateFromString(dateString: String) -> NSDate {
        return self.dateFromString(dateString, self.classForCoder().dbFormatString())
    }
    
    class func dateFromString(dateString: String, _ format: String) -> NSDate {
        let formatter = self.classForCoder().sharedDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)!
    }
    
    class func stringFromDate(date: NSDate, _ format: String) -> String {
        return date.stringWithFormat(format)
    }
    
    class func stringFromDate(date: NSDate) -> String {
        return date.string()
    }
    
    // MARK: - Method
    func stringWithDateStyle(dateStyle: NSDateFormatterStyle, _ timeStyle: NSDateFormatterStyle) -> String {
        self.classForCoder.sharedDateFormatter().dateStyle = dateStyle
        self.classForCoder.sharedDateFormatter().timeStyle = timeStyle
        return self.classForCoder.sharedDateFormatter().stringFromDate(self)
    }
    
    func daysAgo() -> Int {
        let calendar = self.classForCoder.sharedCalendar()
        let components = calendar.components(NSCalendarUnit.Day, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        return abs(components.day)
    }
    
    func daysAgoAgainstMidnight() -> Int {
        let mdf = self.classForCoder.sharedDateFormatter()
        mdf.dateFormat = "yyyy-MM-dd"
        let midnight = mdf.dateFromString(mdf.stringFromDate(self))
        return abs(Int(midnight!.timeIntervalSinceNow / dayInSeconds))
    }
    
    func stringDaysAgo() -> String {
        return self.stringDaysAgoAgainstMidnight(true)
    }
    
    func stringDaysAgoAgainstMidnight(flag: Bool) -> String {
        let daysAgo = flag ? self.daysAgoAgainstMidnight() : self.daysAgo()
        var daysText: String?
        switch daysAgo {
        case 0:
            daysText = "今天"
        case 1:
            daysText = "昨天"
        default:
            daysText = "\(daysAgo)天前"
        }
        return daysText!
    }
    
    
    func year() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Year, fromDate: self)
    }
    func month() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Month, fromDate: self)
    }
    func day() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Day, fromDate: self)
    }
    func hour() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Hour, fromDate: self)
    }
    func minute() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Minute, fromDate: self)
    }
    func second() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Second, fromDate: self)
    }
    func weeday() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.Weekday, fromDate: self)
    }
    func weekNumber() -> Int {
        return self.classForCoder.sharedCalendar().component(NSCalendarUnit.WeekOfYear, fromDate: self)
    }
    
    func offsetYear(numYears: Int) -> NSDate {
        let offsetComponents = NSDateComponents()
        offsetComponents.year = numYears
        
        return self.classForCoder.sharedCalendar().dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions(rawValue: 0)) as NSDate!
    }
    
    func offsetMonth(numberMonths: Int) -> NSDate {
        let offsetComponents = NSDateComponents()
        offsetComponents.month = numberMonths
        
        return self.classForCoder.sharedCalendar().dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions(rawValue: 0)) as NSDate!
    }
    
    func offsetDay(numberDays: Int) -> NSDate {
        let offsetComponents = NSDateComponents()
        offsetComponents.day = numberDays
        
        return self.classForCoder.sharedCalendar().dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions(rawValue: 0)) as NSDate!
    }
    
    func offsetHour(numberHours: Int) -> NSDate {
        let offsetComponents = NSDateComponents()
        offsetComponents.hour = numberHours
        
        return self.classForCoder.sharedCalendar().dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions(rawValue: 0)) as NSDate!
    }
    
    func numDaysInMonth() -> Int {
        let cal = self.classForCoder.sharedCalendar()
        let rng = cal.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self)
        return rng.length
    }
    
    func firstWeekDayInMonth() -> Int {
        let gregorian = self.classForCoder.sharedCalendar()
        gregorian.firstWeekday = 2
        
        let comps = gregorian.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: self)
        comps.day = 1
        let newDate: NSDate! = gregorian.dateFromComponents(comps)
        
        return gregorian.ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: newDate)
    }
    
    func utcTimeStamp() -> UInt {
        return UInt(self.timeIntervalSince1970)
    }
    
    func stringWithFormat(format: String) -> String {
        let formatter = self.classForCoder.sharedDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    func string() -> String {
        return self.stringWithFormat(self.classForCoder.dbFormatString())
    }
}