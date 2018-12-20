import UIKit

class JournalEntryViewController: UIViewController {
    
    @IBOutlet weak var journalEntryContents: UITextView!
    var journalEntry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let journalEntry = journalEntry {
            journalEntryContents.text = journalEntry.contents
            navigationItem.title = "August 24, 1987"
        }
    }
    
}
