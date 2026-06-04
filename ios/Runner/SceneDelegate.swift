import Flutter
import UIKit
import app_links

class SceneDelegate: FlutterSceneDelegate {

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    if let userActivity = connectionOptions.userActivities.first(where: {
      $0.activityType == NSUserActivityTypeBrowsingWeb
    }), let url = userActivity.webpageURL {
      AppLinks.shared.handleLink(url: url)
    }

    if let urlContext = connectionOptions.urlContexts.first {
      AppLinks.shared.handleLink(url: urlContext.url)
    }
  }

  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if let url = userActivity.webpageURL {
      AppLinks.shared.handleLink(url: url)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      AppLinks.shared.handleLink(url: url)
    }
  }
}
