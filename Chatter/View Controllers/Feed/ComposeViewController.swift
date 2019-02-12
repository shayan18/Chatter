import UIKit

class ComposeViewController: UIViewController {

  var dataController: DataController!
  override func viewWillAppear(_ animated: Bool) {
    textView.becomeFirstResponder()
  }

  @IBOutlet weak var textView: UITextView!

  @IBAction func close(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func send(_ sender: AnyObject) {
    dataController.postMessage(textView.text)
    close(sender)
  }
}
