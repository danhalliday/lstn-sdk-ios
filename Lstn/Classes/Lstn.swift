import Foundation

@objc public class Lstn: NSObject {

    public static let shared = Lstn()

    public let player: Player = LocalPlayer()

    private override init() {
        super.init()
    }

    // static let API = URL(string: "https://api.lstn.ltd")!
    static let API = URL(string: "https://private-378fa2-lstn.apiary-mock.com/v1")!

}
