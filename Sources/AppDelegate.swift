import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

class PhoneSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Ứng dụng CarPlay Cá Nhân đã sẵn sàng!\nHãy cắm cáp vào màn hình xe."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = vc.view.bounds
        vc.view.addSubview(label)

        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }
}