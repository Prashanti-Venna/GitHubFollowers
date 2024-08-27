//
//  Date+Extension.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 26/07/2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
}
