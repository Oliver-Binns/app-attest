import Foundation
import Testing
import X509

extension Array where Element == Certificate {
    static var valid: [Certificate] {
        get throws {
            try [SecCertificate.leaf, SecCertificate.intermediate]
                .map(Certificate.init)
        }
    }

    static var expired: [Certificate] {
        get throws {
            try [SecCertificate.leafExpired, SecCertificate.intermediate]
                .map(Certificate.init)
        }
    }
}

extension SecCertificate {
    static var leaf: SecCertificate {
        get throws {
            try create(base64Encoded: """
            MIIDXzCCAuWgAwIBAgIGAZMVyZSFMAoGCCqGSM49BAMCME8xIzAhBgNVBAMMGkFwcGxlIEF
            wcCBBdHRlc3RhdGlvbiBDQSAxMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYW
            xpZm9ybmlhMB4XDTI0MTEwOTExMTU1MloXDTI1MTAwNTE5MDc1MlowgZExSTBHBgNVBAMMQ
            DdkNDI4ZmY4NWM2OWI3MGEzZTlmNTc1Yzg2YmY1OGU1ZjQ1N2ExMzY3YTBmM2YxYWVhZjNi
            MzM1NmQzNzM3NTIxGjAYBgNVBAsMEUFBQSBDZXJ0aWZpY2F0aW9uMRMwEQYDVQQKDApBcHB
            sZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9ybmlhMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQg
            AEQK8HzASF41AXNmXVIIg3CDutgiZx053sldohfKkbXhmrN/DokwzC4NrWNXqnHkYVEkXoN
            jY/MEqmQfAmPzb986OCAWgwggFkMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgTwMIGI
            BgkqhkiG92NkCAUEezB5pAMCAQq/iTADAgEBv4kxAwIBAL+JMgMCAQG/iTMDAgEBv4k0KQQ
            nWjg2REg0NlA3OS51ay5jby5vbGl2ZXJiaW5ucy5hcHAtYXR0ZXN0pQYEBHNrcyC/iTYDAg
            EFv4k3AwIBAL+JOQMCAQC/iToDAgEAv4k7AwIBADCBgwYJKoZIhvdjZAgHBHYwdL+KeAYEB
            DE4LjK/iFAHAgUA/////r+KewoECDIyQzUxMjVlv4p9BgQEMTguMr+KfgMCAQC/iwoQBA4y
            Mi4zLjEyNS41LjUsML+LDBAEDjIyLjMuMTI1LjUuNSwwv4gCCgQIaXBob25lb3O/iAUGBAR
            CZXRhMDMGCSqGSIb3Y2QIAgQmMCShIgQg/pH9CCpEljZQbBaYbs7ajaq6I0GhKw0JCiiPQc
            Mk6fIwCgYIKoZIzj0EAwIDaAAwZQIwBbmsjB5Hc7imux1DAg8aDkrfOAOUZqtrAxVupXlwc
            yEU8OkU8CoxocFvPjKm0CFoAjEA/oMA+PzwA5bPT0C0vYSNCa/TjVCHJGodqkitZs2DqwQ/
            EBuBitj/kZw/lIy8KT25
            """)
        }
    }

    static var intermediate: SecCertificate {
        get throws {
            try create(base64Encoded: """
            MIICQzCCAcigAwIBAgIQCbrF4bxAGtnUU5W8OBoIVDAKBggqhkjOPQQDAzBSMSYwJAYDVQQ
            DDB1BcHBsZSBBcHAgQXR0ZXN0YXRpb24gUm9vdCBDQTETMBEGA1UECgwKQXBwbGUgSW5jLj
            ETMBEGA1UECAwKQ2FsaWZvcm5pYTAeFw0yMDAzMTgxODM5NTVaFw0zMDAzMTMwMDAwMDBaM
            E8xIzAhBgNVBAMMGkFwcGxlIEFwcCBBdHRlc3RhdGlvbiBDQSAxMRMwEQYDVQQKDApBcHBs
            ZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9ybmlhMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAErls
            3oHdNebI1j0Dn0fImJvHCX+8XgC3qs4JqWYdP+NKtFSV4mqJmBBkSSLY8uWcGnpjTY71eNw
            +/oI4ynoBzqYXndG6jWaL2bynbMq9FXiEWWNVnr54mfrJhTcIaZs6Zo2YwZDASBgNVHRMBA
            f8ECDAGAQH/AgEAMB8GA1UdIwQYMBaAFKyREFMzvb5oQf+nDKnl+url5YqhMB0GA1UdDgQW
            BBQ+410cBBmpybQx+IR01uHhV3LjmzAOBgNVHQ8BAf8EBAMCAQYwCgYIKoZIzj0EAwMDaQA
            wZgIxALu+iI1zjQUCz7z9Zm0JV1A1vNaHLD+EMEkmKe3R+RToeZkcmui1rvjTqFQz97YNBg
            IxAKs47dDMge0ApFLDukT5k2NlU/7MKX8utN+fXr5aSsq2mVxLgg35BDhveAe7WJQ5tw==
            """)
        }
    }

    static var leafExpired: SecCertificate {
        get throws {
            try create(base64Encoded: """
            MIIDsjCCAzmgAwIBAgIGAY7x/U1KMAoGCCqGSM49BAMCME8xIzAhBgNVBAMMGkFwcGxlIEF
            wcCBBdHRlc3RhdGlvbiBDQSAxMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYW
            xpZm9ybmlhMB4XDTI0MDQxNzE2MTQ1M1oXDTI0MDQyMDE2MTQ1M1owgZExSTBHBgNVBAMMQ
            DZkMmFjNDg0NWYxMzIzMzIyZjU5MjNmMGJkOWQyMmRiZTUwZTA2YjdiODAxMjFmY2UyYjJi
            NWU2NmU5ZTk4ZDYxGjAYBgNVBAsMEUFBQSBDZXJ0aWZpY2F0aW9uMRMwEQYDVQQKDApBcHB
            sZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9ybmlhMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQg
            AEjC4Mq2+SI5cOf1q26S/XpNbWIaYOVIZEvxl2TvHvhTYR9sK2u1Oyu6LTRoGX5L6rLDbKw
            OTiT0HzUTLJR15cJKOCAbwwggG4MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgTwMIGI
            BgkqhkiG92NkCAUEezB5pAMCAQq/iTADAgEBv4kxAwIBAL+JMgMCAQG/iTMDAgEBv4k0KQQ
            nMDM1MjE4NzM5MS5jb20uYXBwbGUuZXhhbXBsZV9hcHBfYXR0ZXN0pQYEBHNrcyC/iTYDAg
            EFv4k3AwIBAL+JOQMCAQC/iToDAgEAv4k7AwIBADCB1wYJKoZIhvdjZAgHBIHJMIHGv4p4B
            gQEMTguML+IUAcCBQD/////v4p7CQQHMjJBMjQ0Yr+KfAYEBDE4LjC/in0GBAQxOC4wv4p+
            AwIBAL+KfwMCAQC/iwADAgEAv4sBAwIBAL+LAgMCAQC/iwMDAgEAv4sEAwIBAb+LBQMCAQC
            /iwoQBA4yMi4xLjI0NC4wLjIsML+LCxAEDjIyLjEuMjQ0LjAuMiwwv4sMEAQOMjIuMS4yND
            QuMC4yLDC/iAIKBAhpcGhvbmVvc7+IBQoECEludGVybmFsMDMGCSqGSIb3Y2QIAgQmMCShI
            gQg+20WKnF+yrF3iQBQb6lNZ+4MHcPUWxLN3oG+/Fblt+swCgYIKoZIzj0EAwIDZwAwZAIw
            Ik4vHloC64CyG7xk6mEC2wNk4hFv+CryBxCTirG4ZOdRgu0CrvFuj3zQEmtLDUe2AjACi2Y
            ebCyyzhd8AwH1hvLgIrpmMj2AJiy0is9Z5OLDYkz9BNUX0IBWGJlewqdr2iU=
            """)
        }
    }

    fileprivate static func create(base64Encoded: String) throws -> SecCertificate {
        let base64Certificate = try #require(
            base64Encoded
                .filter { !$0.isWhitespace }
                .data(using: .utf8)
        )
        let data = try #require(Data(base64Encoded: base64Certificate))
        return try #require(SecCertificateCreateWithData(nil, data as CFData))
    }
}
