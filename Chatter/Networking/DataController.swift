
import Foundation
import RealmSwift

class DataController {

  private let api: ChatterAPI

  init(api: ChatterAPI) {
    self.api = api
  }

  private var timer: Timer?

  // MARK: - fetch new messages

  func startFetchingMessages() {
    timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetch), userInfo: nil, repeats: true)
    timer!.fire()
  }

  func stopFetchingMessages() {
    timer?.invalidate()
  }

  @objc fileprivate func fetch() {
    api.getMessages { jsonObjects in

        let newMessages = jsonObjects.map{ object in
            return Message(value: object)

        }
        let realm = try! Realm()
       let me = User.defaultUser(in: realm)
       try! realm.write {
            for message in newMessages {
      me.messages.insert(message, at: 0)
            }

        }
    }
  }

  // MARK: - post new message

  func postMessage(_ message: String) {
    let realm = try! Realm()
    let user = User.defaultUser(in: realm)

    let newMessage = Message(user: user, message: message)
   try! realm.write {
        user.outgoing.append(newMessage)
    }
     let newId = newMessage.id
     api.postMessage(newMessage, completion: {[weak self] _ in
     self?.didSentMessage(id: newId)
     })
  }

  private func didSentMessage(id: String) {


    let realm = try! Realm()
    let user = User.defaultUser(in: realm)

    if let sentMsg = realm.object(ofType: Message.self, forPrimaryKey: id), let index = user.outgoing.index(of: sentMsg) {
       try! realm.write {
            user.outgoing.remove(objectAtIndex: index)
            user.messages.insert(sentMsg, at: 0)
        }

    }

  }
}
