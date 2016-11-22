import Foundation


// MARK: Public Interface

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
    ///
    /// - Returns: A Player instance
    ///
    public static func createPlayer() -> Player { return DefaultPlayer() }

    private override init() { super.init() }

}

// MARK: - Internal Configuration

extension Lstn {

    private static let environment = ProcessInfo.processInfo.environment
    private static let info = Bundle.main.infoDictionary

    static var token: String? {

        if let token = self.environment["LSTN_TOKEN"] {
            return token
        }

        if let token = self.info?["LstnToken"] as? String {
            return token
        }

        print("Lstn token not set! See https://github.com/lstn-ltd/lstn-sdk-ios#installation")
        return nil

    }

    static var endpoint: URL {

        if let string = self.environment["LSTN_ENDPOINT"], let endpoint = URL(string: string) {
            return endpoint
        }

        if let string = self.info?["LstnEndpoint"] as? String, let endpoint = URL(string: string) {
            return endpoint
        }

        return URL(string: "https://api.lstn.ltd/v1")!

    }

}
