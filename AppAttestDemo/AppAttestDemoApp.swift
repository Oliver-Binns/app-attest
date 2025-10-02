import AppAttest
import SwiftUI

@main
struct AppAttestDemoApp: App {
    let attestationManager = AttestationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await attestationManager.submitAttestation()
                    } catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
    }
}
