import UIKit

class NewJournalEntryViewController: UIViewController {

    @IBOutlet weak var journalEntryContents: UITextView!
    var journal: Journal?
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let entry = JournalEntry(date: Date(), contents: journalEntryContents.text)
        journal?.addEntry(entry)
        dismiss(animated: true, completion: nil)
    }
    
}
