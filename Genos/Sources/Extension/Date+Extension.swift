//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

import SwiftDate

public extension Date {
    func dateByAddingDay(day: Int) -> Date {
        var components = DateComponents()
        components.day = day
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self)!
    }

    var formatToDay: String { toFormat(DAY_FORMAT) }

    var formatToSecond: String { toFormat(SECOND_FORMAT) }
}
