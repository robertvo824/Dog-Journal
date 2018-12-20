import UIKit

class JournalEntry: CustomStringConvertible {
    
    let date: Date
    let contents: String
    let dateFormatter = DateFormatter()
    var description: String {
        return dateFormatter.string(from: date)
    }
    
    init(date: Date, contents: String) {
        self.date = date
        self.contents = contents
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
}
