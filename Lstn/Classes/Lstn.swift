import Foundation

@objc public class Lstn: NSObject {

    public static let shared = Lstn()

    public let player = Player()

    private override init() {
        super.init()
    }

    // static let API = "https://api.lstn.ltd"
    static let API = "https://private-378fa2-lstn.apiary-mock.com"

}
