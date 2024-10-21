import AppAttest
import SwiftUI

@main
struct AppAttestDemoApp: App {
    let service: AppAttestProvider = AppAttestService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // app attest!
                }
        }
    }
}
