//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

import SwiftDate

extension Date {
    public func dateByAddingDay(day: Int) -> Date {
        var components = DateComponents()
        components.day = day
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self)!
    }

    public var formatToDay: String { toFormat(DAY_FORMAT) }

    public var formatToSecond: String { toFormat(SECOND_FORMAT) }
}
