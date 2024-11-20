import Foundation

public enum Environment {
    case development
    case production
}

extension Environment {
    init?(bytes: Data) {
        switch bytes {
        case Data("appattestdevelop".utf8):
            self = .development
        case Data("appattest".utf8) + repeatElement(0x00, count: 7):
            self = .production
        default:
            return nil
        }
    }
}
