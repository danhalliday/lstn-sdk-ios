import Foundation

public class Lstn {

    public static let shared = Lstn()

    
    private init() {}

}

public class Player {

    public typealias Callback = (Bool) -> Void

    public init() {

    }

    public func load(url: URL, complete: Callback? = nil) {
        complete?(true)
    }

}
