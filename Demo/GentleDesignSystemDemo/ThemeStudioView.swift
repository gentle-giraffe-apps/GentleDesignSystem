import GentleDesignSystem
import SwiftUI
import UIKit

struct ThemeStudioView: View {
    var isTitleEditable: Bool = false

    var body: some View {
        GentleDesignStudioView(isTitleEditable: isTitleEditable, embedInNavigationStack: false)
    }
}
