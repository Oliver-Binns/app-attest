import Foundation

extension URLRequest {
    func bodyStreamAsJSON() -> Any? {
        guard let bodyStream = self.httpBodyStream else {
            return nil
        }

        bodyStream.open()

        // Will read 16 chars per iteration.
        // Can use bigger buffer if needed
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(
            capacity: bufferSize
        )

        var data = Data()

        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }

        buffer.deallocate()

        bodyStream.close()

        do {
            return try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            )
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
