
import Foundation

//
// MARK: - JSON API protocol for the Inboxly web service
//

typealias JSONObject = [String: Any]

protocol ChatterAPI {
  func getMessages(_ completion:  @escaping ([JSONObject]) -> Void)
  func postMessage(_ message: Message, completion: @escaping (JSONObject?) -> Void)
}

//
// MARK: - Mock API to provide network responses in JSON format
//

class StubbedChatterAPI: ChatterAPI {

  func getMessages(_ completion: @escaping ([JSONObject]) -> Void) {
    let incomingMessages = randomMessages()

    DispatchQueue.main.async {
      completion(incomingMessages)
    }
  }

  func postMessage(_ message: Message, completion: @escaping (JSONObject?)->Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5.0) {
      completion(JSONObject())
    }
  }

  //MARK: - Stubbing server responses
  private let users = ["Jennifer", "Amanda", "John", "Jiřího", "Maciej", "Morticia"]
  private let phrases = [
    "Wednesday is hump day, but has anyone asked the camel if he’s happy about it?",
    "If you like tuna and tomato sauce- try combining the two. It’s really not as bad as it sounds.",
    "Where do random thoughts come from?",
    "I will never be this young again. Ever. Oh damn… I just got older.",
    "I think I will buy the red car, or I will lease the blue one.",
    "My Mum tries to be cool by saying that she likes all the same things that I do.",
    "Let me help you with your baggage.",
    "A purple pig and a green donkey flew a kite in the middle of the night and ended up sunburnt.",
    "He told us a very exciting adventure story.",
    "We have never been to Asia, nor have we visited Africa.",
    "Should we start class now, or should we wait for everyone to get here?",
    "She only paints with bold colors; she does not like pastels.",
    "Hurry!",
    "This is the last random sentence I will be writing and I am going to stop mid-sent",
    "They got there early, and they got really good seats.",
    "The memory we used to share is no longer coherent.",
    "She borrowed the book from him many years ago and hasn't yet returned it.",
    "Two seats were vacant.",
    "I am counting my calories, yet I really want dessert.",
    "She did her best to help him.",
    "I am happy to take your donation; any amount will be greatly appreciated."
  ]

  private func randomMessages() -> [JSONObject] {
    return (0...arc4random_uniform(3))
      .map { _ -> JSONObject in
        let name = users[Int(arc4random_uniform(UInt32(users.count)))]
        return [
          "id": UUID().uuidString,
          "message": phrases[Int(arc4random_uniform(UInt32(phrases.count)))],
          "name": name,
          "timestamp": Date().timeIntervalSinceReferenceDate
        ]
    }
  }
}
