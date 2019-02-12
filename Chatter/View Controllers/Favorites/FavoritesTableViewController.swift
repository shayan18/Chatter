
import UIKit
import RealmSwift

class FavoritesTableViewController: UITableViewController {


    private var favMessages : Results<Message>!
    private var favToken: NotificationToken?


  override func viewDidLoad() {
    super.viewDidLoad()
    let realm = try! Realm()
    let user = User.defaultUser(in: realm)
    favMessages = user.messages.filter("isFavorite = true")
    favToken = favMessages._addNotificationBlock { [weak self] changes in

        switch changes {
        case .initial:
            self?.tableView.reloadData()

        case .update(_, let deletions, let insertions,let modifications):
            self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)

        case .error: break
        }


    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)


  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)




  }

  // MARK: - table view methods

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favMessages.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier,
                                             for: indexPath) as! FeedTableViewCell

    let message = favMessages[indexPath.row]
    cell.configureWithMessage(message)

    return cell
  }

}
