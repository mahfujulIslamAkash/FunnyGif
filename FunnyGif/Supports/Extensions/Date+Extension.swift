//
//  Date+Extension.swift
//  WalkiTalki-Redesign
//
//  Created by Appnap WS12 on 11/3/24.
//

import Foundation

extension Date {
    
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var time: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    var time_without_am_pm: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: self)
    }
    
    func changeDays(by days: Int) -> String{
        let date = Calendar.current.date(byAdding: .day, value: days, to: self)!
        return "\(date.year)-\(date.month)-\(date.day)"
    }
    
    static func getCurrentDate() -> String
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: Date())
        
    }
    
    
    static func getCurrentDateButton() -> String
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: Date())
        
    }
    
    static func getCurrentMonthButton() -> String
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        
        return dateFormatter.string(from: Date())
        
    }
}
