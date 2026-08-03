import SwiftUI
import Shared

@main
struct HelianzApp: App {
    init() {
        // Koin is initialized in Shared module via KoinApplication in HelianzApp.kt
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Shared.MainViewControllerKt.MainViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
