//
//  Extension.swift
//  ShakeTutorial
//
//  Created by Fatih Durmaz on 1.07.2024.
//

import SwiftUI

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
