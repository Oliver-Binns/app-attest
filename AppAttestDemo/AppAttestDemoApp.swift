import AppAttest
import SwiftUI

@main
struct AppAttestDemoApp: App {
    let appAttestProvider: AppAttestProvider = AppAttestService(
        // challengeProvider: LocalChallengeProvider()
        challengeProvider: RemoteChallengeProvider()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        _ = try await appAttestProvider.fetchAttestation()
                    } catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
    }
}
