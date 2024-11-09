import AttestationValidator
import Foundation
import Testing

struct MockAttestationStatement: AttestationStatement {
    let certificateChain: [SecCertificate]
    let receipt: Data
}

extension AttestationStatement
where Self == MockAttestationStatement {
    static var valid: AttestationStatement {
        get throws {
            try MockAttestationStatement(
                certificateChain: [
                    .leaf,
                    .intermediate
                ],
                receipt: Data()
            )
        }
    }

    static var expired: AttestationStatement {
        get throws {
            try MockAttestationStatement(
                certificateChain: [
                    .leafExpired,
                    .intermediate
                ],
                receipt: Data()
            )
        }
    }

    static var empty: AttestationStatement {
        MockAttestationStatement(
            certificateChain: [],
            receipt: Data()
        )
    }
}

extension SecCertificate {
    static var leaf: SecCertificate {
        get throws {
            try create(base64Encoded: """
            MIIDYDCCAuegAwIBAgIGAZLILdecMAoGCCqGSM49BAMCME8xIzAhBgNVBAMMGkFwcGxlIEF
            wcCBBdHRlc3RhdGlvbiBDQSAxMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYW
            xpZm9ybmlhMB4XDTI0MTAyNTA5MzUwMFoXDTI1MTAwNDE1MTMwMFowgZExSTBHBgNVBAMMQ
            Dk3MDQwZWM1NDM1Mjc4YjgyMWVmOTQyMTFiMzU2NmU1ODk5M2Y0YzIwOTU4ZmUxZWFiODBl
            ZDQxMjlhMTNmYjMxGjAYBgNVBAsMEUFBQSBDZXJ0aWZpY2F0aW9uMRMwEQYDVQQKDApBcHB
            sZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9ybmlhMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQg
            AERuZ4XWwPi98Zxt458t5Kl/HoJQxQ4Q2l8lmTnIMTDvpMXgZTP5hKkdsRjhvEmI0O1gXqY
            EuxiEdkyUDjgFbPhaOCAWowggFmMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgTwMIGI
            BgkqhkiG92NkCAUEezB5pAMCAQq/iTADAgEBv4kxAwIBAL+JMgMCAQG/iTMDAgEBv4k0KQQ
            nWjg2REg0NlA3OS51ay5jby5vbGl2ZXJiaW5ucy5hcHAtYXR0ZXN0pQYEBHNrcyC/iTYDAg
            EFv4k3AwIBAL+JOQMCAQC/iToDAgEAv4k7AwIBADCBhQYJKoZIhvdjZAgHBHgwdr+KeAYEB
            DE4LjK/iFAHAgUA/////r+KewoECDIyQzUxMDlwv4p9BgQEMTguMr+KfgMCAQC/iwoRBA8y
            Mi4zLjEwOS41LjE2LDC/iwwRBA8yMi4zLjEwOS41LjE2LDC/iAIKBAhpcGhvbmVvc7+IBQY
            EBEJldGEwMwYJKoZIhvdjZAgCBCYwJKEiBCCpykhwtVSQxd3sbQ2i/VeE3LeA9zhTcc1PY4
            Ico2h8HTAKBggqhkjOPQQDAgNnADBkAjAY3fRr+VP9wsoEGLFg/9q9bXoTONwDz+n5e5327
            hxihkgYHwo62RJC/PZ9aG+hc9sCMDR9aY7eNXgsV1csEa0Z3pFKODCaA7oBwyGauh48Hh0r
            QbfOWvQn/W0/KEzNKgv0mg==
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
