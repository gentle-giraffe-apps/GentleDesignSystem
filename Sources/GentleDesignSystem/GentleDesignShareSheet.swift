//  Jonathan Ritchey
import SwiftUI

#if canImport(UIKit)
import UIKit

public struct GentleDesignShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let activities: [UIActivity]? = nil

    public init(items: [Any]) {
        self.items = items
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: activities)
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // no-op
    }
}
#endif
