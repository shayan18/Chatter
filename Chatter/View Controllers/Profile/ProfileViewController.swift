
import UIKit
import RealmSwift
import Kingfisher

class ProfileViewController: UIViewController {

  @IBOutlet weak var statsLabel: UILabel!
  @IBOutlet weak var photo: UIImageView!

    private var userToken: NotificationToken?
  override func viewDidLoad() {
    super.viewDidLoad()
    let realm = try! Realm()
    let user = User.defaultUser(in: realm)
    userToken = user.addNotificationBlock{ [weak self] change in

        switch change {
        case .change(let properties):
            if let index = properties.index(where: {
                $0.name == "sent"

            }), let nr = properties[index].newValue as? Int {
                self?.updateUI(messageCount: nr)
            }

        case .deleted: break
        case .error: break
        }

    }
    updateUI(messageCount: user.sent)


    photo.kf.setImage(with: imageUrlForName("me"))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //updateUI(messageCount: sentMessages.count)
  }

  private func updateUI(messageCount: Int) {
    statsLabel.text = "\(messageCount) sent messages"
  }
}
