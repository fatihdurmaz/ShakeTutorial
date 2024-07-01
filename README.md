# SwiftUI Shake Tutorial



## Extension.swift
This file extends the functionalities of UIDevice and UIWindow classes using NotificationCenter to detect shaking motions.

```swift 
extension UIDevice {
    static let deviceDidStartShakeNotification = Notification.Name(rawValue: "deviceDidStartShakeNotification")
    static let deviceDidFinishShakeNotification = Notification.Name(rawValue: "deviceDidFinishShakeNotification")
}

extension UIWindow {
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidStartShakeNotification, object: nil)
        }
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidFinishShakeNotification, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let onStart: () -> Void
    let onFinish: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidStartShakeNotification)) { _ in
                onStart()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidFinishShakeNotification)) { _ in
                onFinish()
            }
    }
}

extension View {
    func onShake(start: @escaping () -> Void, finish: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(onStart: start, onFinish: finish))
    }
}

```



**UIDevice Extension:** Detects the device shaking using motionBegan and motionEnded methods and sends start/end notifications.
**UIWindow Extension:** Extends the UIWindow class to post relevant notifications when the device is shaken.
**DeviceShakeViewModifier**
This ViewModifier adds functionalities to trigger actions when a shaking motion starts and finishes on a SwiftUI view.
**onShake function:** Adds animations and other functionalities to a SwiftUI view when a shake motion starts and finishes.

# ContentView.swift
This file creates a ContentView using SwiftUI that detects shake motions and provides visual feedback to the user.

**ContentView:**  Within a VStack, updates text and animations when shake motion starts and finishes.

            VStack {
                if shakeStarted {
                    Text("Shaking!")
                        .padding()
                        .font(.largeTitle)
                        .transition(.opacity)
                    
                } else {
                    Text("Not Shaking!")
                        .padding()
                        .font(.largeTitle)
                        .transition(.opacity)
                }
            }
            .onShake(start: {
                withAnimation {
                    self.shakeStarted = true
                }
            }, finish: {
                Task {
                    try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                    withAnimation {
                        self.shakeStarted = false
                    }
                    print("Shaking finished!")
                    
                }
            })

**onShake modifier:** Provides additional functionality to detect shake motions within ContentView.

*This structure provides an example where specific text and animations are shown to the user when the device is shaken, and removes them when the shaking motion ends. You can use this code to develop applications that dynamically respond to shaking gestures.*
