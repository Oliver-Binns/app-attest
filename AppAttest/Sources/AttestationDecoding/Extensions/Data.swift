import Foundation

extension Int {
    init(data: Data) {
        self = data.reduce(0) { value, byte in
            value << 8 | Int(byte)
        }
    }
}
