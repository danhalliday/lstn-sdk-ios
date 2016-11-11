import Foundation

@objc public class Lstn: NSObject {

    /// Singleton instance for easy access to Lstn.
    ///
    /// For more complex apps it may be desirable to use Lstn's classes directly. Factory methods
    /// are provided for this purpose. For example, to create a player, use `Lstn.createPlayer()`.
    ///
    public static let shared = Lstn()

    /// Lstn's podcast player.
    ///
    /// The `Player` loads text articles and plays them as spoken audio using Lstn's web service.
    ///
    public let player: Player = DefaultPlayer()

    /// Factory vending Player instances.
    /// - Returns: A Player instance
    ///
    public static func createPlayer() -> Player { return DefaultPlayer() }

    // static let API = URL(string: "https://api.lstn.ltd")!
    static let API = URL(string: "https://private-378fa2-lstn.apiary-mock.com/v1")!

    private override init() {
        super.init()
    }

}
