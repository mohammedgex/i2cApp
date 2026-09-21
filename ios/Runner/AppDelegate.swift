import Flutter
import UIKit
import FirebaseCore   // ⬅️ مهم جداً
import UserNotifications  // ⬅️ لضمان وضوح UNUserNotificationCenter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var screenCaptureOverlay: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 1) Firebase أولاً (قبل الـ plugins)
    FirebaseApp.configure()

    // 2) تسجيل الـ plugins مرة واحدة بس
    GeneratedPluginRegistrant.register(with: self)

    // 3) تفعيل الـ UNUserNotificationCenter delegate (لـ iOS 10+)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // 4) مراقبة تسجيل الشاشة (كودك الخاص)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleScreenCaptureChange),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )

    handleScreenCaptureChange()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc private func handleScreenCaptureChange() {
    guard let window = window else { return }

    if UIScreen.main.isCaptured {
      let overlay = UIView(frame: window.bounds)
      overlay.backgroundColor = .black
      overlay.tag = 99123
      overlay.alpha = 1.0

      if let existing = window.viewWithTag(99123) {
        existing.removeFromSuperview()
      }

      window.addSubview(overlay)
      window.bringSubviewToFront(overlay)
      screenCaptureOverlay = overlay
    } else {
      screenCaptureOverlay?.removeFromSuperview()
      screenCaptureOverlay = nil
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}