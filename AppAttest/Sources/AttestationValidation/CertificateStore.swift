import Foundation
import X509

extension CertificateStore {
    static var appAttest: CertificateStore {
        get throws {
            let url = Bundle.module.url(
                forResource: "Apple_App_Attestation_Root_CA",
                withExtension: "pem"
            )!
            let pemEncoded = try String(contentsOf: url, encoding: .utf8)
            return try CertificateStore([
                Certificate(pemEncoded: pemEncoded)
            ])
        }
    }
}
