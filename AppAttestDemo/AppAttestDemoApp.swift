import AppAttest
import SwiftUI

@main
struct AppAttestDemoApp: App {
    let appAttestProvider: AppAttestProvider = AppAttestService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await appAttestProvider
                            .fetchAttestation()
                    } catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
    }
}
