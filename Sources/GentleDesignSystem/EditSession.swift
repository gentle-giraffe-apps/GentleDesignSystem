//  Jonathan Ritchey
import SwiftUI

/// Manages the lifecycle of an editing session for a spec value.
/// Captures the initial state on begin, tracks save intent, and can revert changes.
///
/// This extracts the common save/revert pattern from editor sheets into a testable class.
///
/// Usage:
/// ```swift
/// @State private var editSession = EditSession<MySpec>()
///
/// // In onAppear:
/// editSession.begin(with: currentValue, revertAction: { spec in
///     binding.wrappedValue = spec
/// })
///
/// // Cancel button:
/// editSession.cancelAndRevert()
///
/// // Confirm button:
/// editSession.markSaved()
///
/// // In onDisappear:
/// editSession.handleDismissal()
/// ```
@Observable
public final class EditSession<SpecType: Sendable>: @unchecked Sendable {

    // MARK: - State

    /// The captured initial value when editing began.
    public private(set) var initialValue: SpecType?

    /// Whether the user explicitly saved (confirmed) their changes.
    public private(set) var didSave: Bool = false

    /// Whether an editing session is currently active.
    public var isActive: Bool { initialValue != nil }

    /// The action to perform when reverting changes.
    private var revertAction: ((SpecType) -> Void)?

    // MARK: - Initialization

    public init() {}

    // MARK: - Lifecycle Methods

    /// Begins an editing session by capturing the initial value.
    /// Call this in `onAppear` of the editor sheet.
    ///
    /// - Parameters:
    ///   - value: The current spec value to capture as the initial state.
    ///   - revertAction: A closure that will be called with the initial value when reverting.
    public func begin(with value: SpecType, revertAction: @escaping (SpecType) -> Void) {
        self.initialValue = value
        self.revertAction = revertAction
        self.didSave = false
    }

    /// Marks the session as saved. Call this when the user confirms their changes.
    /// After calling this, `handleDismissal()` will not revert changes.
    public func markSaved() {
        didSave = true
    }

    /// Reverts to the initial value if one was captured.
    /// Call this when the user explicitly cancels.
    public func revert() {
        guard let initialValue, let revertAction else { return }
        revertAction(initialValue)
    }

    /// Cancels the session and reverts changes.
    /// Convenience method that combines `revert()` for use with cancel buttons.
    public func cancelAndRevert() {
        revert()
    }

    /// Handles sheet dismissal. If the user didn't explicitly save, reverts changes.
    /// Call this in `onDisappear` of the editor sheet.
    ///
    /// This handles the case where the user drags to dismiss without tapping cancel or confirm.
    public func handleDismissal() {
        if !didSave {
            revert()
        }
        // Reset state for potential reuse
        reset()
    }

    /// Resets the session state. Called automatically after `handleDismissal()`.
    public func reset() {
        initialValue = nil
        didSave = false
        revertAction = nil
    }

    // MARK: - Query Methods

    /// Returns true if changes should be reverted on dismissal.
    /// Useful for testing the dismissal logic without side effects.
    public func shouldRevertOnDismissal() -> Bool {
        return !didSave && initialValue != nil
    }
}

// MARK: - SwiftUI View Extension

public extension View {
    /// Configures an edit session to begin on appear and handle dismissal.
    ///
    /// - Parameters:
    ///   - session: The edit session to manage.
    ///   - currentValue: A closure returning the current value to capture.
    ///   - revertAction: The action to perform when reverting.
    func editSession<SpecType>(
        _ session: EditSession<SpecType>,
        capturing currentValue: @escaping () -> SpecType,
        revertAction: @escaping (SpecType) -> Void
    ) -> some View {
        self
            .onAppear {
                session.begin(with: currentValue(), revertAction: revertAction)
            }
            .onDisappear {
                session.handleDismissal()
            }
    }
}
