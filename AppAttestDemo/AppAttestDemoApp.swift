import AppAttest
import SwiftUI

@main
struct AppAttestDemoApp: App {
    let appAttestProvider: AppAttestProvider = AppAttestService(
        challengeProvider: LocalChallengeProvider()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        let attestation = try await appAttestProvider.fetchAttestation()
                        print("attestation: \(attestation.base64EncodedString())")
                    } catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
    }
}
