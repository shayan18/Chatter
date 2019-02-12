
import UIKit
import RealmSwift

class FeedTableViewController: UITableViewController {

  private var dataController: DataController!
    fileprivate var messages : List<Message>!
    private var messagesToken: NotificationToken?

    override func viewDidLoad() {
    super.viewDidLoad()

    let realm = try! Realm()
   messages = User.defaultUser(in: realm).messages
        messagesToken = messages.addNotificationBlock { [weak self] changes in
            guard let tableView = self?.tableView else {return}

            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
            case .error: break

            }
            self?.title = "Feed (\(self?.messages.count ?? 0))"

        }
    dataController = DataController(api: StubbedChatterAPI())
    dataController.startFetchingMessages()

  }
    
  @IBAction func refresh() {
    tableView.reloadData()
  }

  deinit {
    dataController.stopFetchingMessages()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let compose = segue.destination as? ComposeViewController {
      compose.dataController = dataController
    }
  }
}

//MARK: - Tableview methods
extension FeedTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as! FeedTableViewCell
    let message = messages[indexPath.row]
    cell.configureWithMessage(message)
    return cell
  }
}
