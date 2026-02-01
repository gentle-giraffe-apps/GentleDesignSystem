//  Jonathan Ritchey
import Testing
@testable import GentleDesignSystem

// MARK: - EditSession Initialization Tests

@Suite("EditSession Initialization Tests")
struct EditSessionInitializationTests {

    @Test("EditSession initializes with no active session")
    func testInitialState() {
        let session = EditSession<String>()

        #expect(session.initialValue == nil)
        #expect(session.didSave == false)
        #expect(session.isActive == false)
    }
}

// MARK: - EditSession Begin Tests

@Suite("EditSession Begin Tests")
struct EditSessionBeginTests {

    @Test("begin captures initial value")
    func testBeginCapturesValue() {
        let session = EditSession<String>()

        session.begin(with: "initial") { _ in }

        #expect(session.initialValue == "initial")
        #expect(session.isActive == true)
    }

    @Test("begin resets didSave to false")
    func testBeginResetsSaveState() {
        let session = EditSession<String>()
        session.begin(with: "first") { _ in }
        session.markSaved()

        // Begin a new session
        session.begin(with: "second") { _ in }

        #expect(session.didSave == false)
    }

    @Test("begin with complex type captures value")
    func testBeginWithComplexType() {
        struct TestSpec: Equatable, Sendable {
            var name: String
            var value: Int
        }

        let session = EditSession<TestSpec>()
        let spec = TestSpec(name: "test", value: 42)

        session.begin(with: spec) { _ in }

        #expect(session.initialValue == spec)
    }
}

// MARK: - EditSession Save Tests

@Suite("EditSession Save Tests")
struct EditSessionSaveTests {

    @Test("markSaved sets didSave to true")
    func testMarkSaved() {
        let session = EditSession<String>()
        session.begin(with: "value") { _ in }

        session.markSaved()

        #expect(session.didSave == true)
    }

    @Test("markSaved can be called multiple times")
    func testMarkSavedIdempotent() {
        let session = EditSession<String>()
        session.begin(with: "value") { _ in }

        session.markSaved()
        session.markSaved()
        session.markSaved()

        #expect(session.didSave == true)
    }
}

// MARK: - EditSession Revert Tests

@Suite("EditSession Revert Tests")
struct EditSessionRevertTests {

    @Test("revert calls revert action with initial value")
    func testRevertCallsAction() {
        let session = EditSession<String>()
        var revertedValue: String?

        session.begin(with: "initial") { value in
            revertedValue = value
        }

        session.revert()

        #expect(revertedValue == "initial")
    }

    @Test("revert does nothing without active session")
    func testRevertWithoutSession() {
        let session = EditSession<String>()
        var revertCalled = false

        // Don't call begin, just try to revert
        session.revert()

        #expect(revertCalled == false)
    }

    @Test("cancelAndRevert calls revert action")
    func testCancelAndRevert() {
        let session = EditSession<String>()
        var revertedValue: String?

        session.begin(with: "test") { value in
            revertedValue = value
        }

        session.cancelAndRevert()

        #expect(revertedValue == "test")
    }

    @Test("revert can be called multiple times")
    func testRevertMultipleTimes() {
        let session = EditSession<String>()
        var revertCount = 0

        session.begin(with: "value") { _ in
            revertCount += 1
        }

        session.revert()
        session.revert()
        session.revert()

        #expect(revertCount == 3)
    }
}

// MARK: - EditSession Dismissal Tests

@Suite("EditSession Dismissal Tests")
struct EditSessionDismissalTests {

    @Test("handleDismissal reverts when not saved")
    func testHandleDismissalRevertsWhenNotSaved() {
        let session = EditSession<String>()
        var revertedValue: String?

        session.begin(with: "initial") { value in
            revertedValue = value
        }

        session.handleDismissal()

        #expect(revertedValue == "initial")
    }

    @Test("handleDismissal does not revert when saved")
    func testHandleDismissalSkipsRevertWhenSaved() {
        let session = EditSession<String>()
        var revertCalled = false

        session.begin(with: "value") { _ in
            revertCalled = true
        }
        session.markSaved()

        session.handleDismissal()

        #expect(revertCalled == false)
    }

    @Test("handleDismissal resets session state")
    func testHandleDismissalResetsState() {
        let session = EditSession<String>()

        session.begin(with: "value") { _ in }
        session.handleDismissal()

        #expect(session.initialValue == nil)
        #expect(session.didSave == false)
        #expect(session.isActive == false)
    }

    @Test("shouldRevertOnDismissal returns true when not saved")
    func testShouldRevertWhenNotSaved() {
        let session = EditSession<String>()

        session.begin(with: "value") { _ in }

        #expect(session.shouldRevertOnDismissal() == true)
    }

    @Test("shouldRevertOnDismissal returns false when saved")
    func testShouldNotRevertWhenSaved() {
        let session = EditSession<String>()

        session.begin(with: "value") { _ in }
        session.markSaved()

        #expect(session.shouldRevertOnDismissal() == false)
    }

    @Test("shouldRevertOnDismissal returns false without active session")
    func testShouldNotRevertWithoutSession() {
        let session = EditSession<String>()

        #expect(session.shouldRevertOnDismissal() == false)
    }
}

// MARK: - EditSession Reset Tests

@Suite("EditSession Reset Tests")
struct EditSessionResetTests {

    @Test("reset clears all state")
    func testResetClearsState() {
        let session = EditSession<String>()

        session.begin(with: "value") { _ in }
        session.markSaved()
        session.reset()

        #expect(session.initialValue == nil)
        #expect(session.didSave == false)
        #expect(session.isActive == false)
    }

    @Test("reset allows starting new session")
    func testResetAllowsNewSession() {
        let session = EditSession<String>()

        session.begin(with: "first") { _ in }
        session.markSaved()
        session.reset()

        session.begin(with: "second") { _ in }

        #expect(session.initialValue == "second")
        #expect(session.didSave == false)
    }
}

// MARK: - EditSession Workflow Tests

@Suite("EditSession Workflow Tests")
struct EditSessionWorkflowTests {

    @Test("Complete save workflow")
    func testSaveWorkflow() {
        let session = EditSession<Int>()
        var currentValue = 10
        var revertCalled = false

        // User opens editor
        session.begin(with: currentValue) { value in
            currentValue = value
            revertCalled = true
        }

        // User makes changes (simulated by changing currentValue)
        currentValue = 20

        // User taps confirm
        session.markSaved()

        // Sheet dismisses
        session.handleDismissal()

        // Value should remain changed
        #expect(currentValue == 20)
        #expect(revertCalled == false)
    }

    @Test("Complete cancel workflow")
    func testCancelWorkflow() {
        let session = EditSession<Int>()
        var currentValue = 10

        // User opens editor
        session.begin(with: currentValue) { value in
            currentValue = value
        }

        // User makes changes
        currentValue = 20

        // User taps cancel
        session.cancelAndRevert()

        // Value should be reverted
        #expect(currentValue == 10)
    }

    @Test("Drag dismiss workflow (no save)")
    func testDragDismissWorkflow() {
        let session = EditSession<Int>()
        var currentValue = 10

        // User opens editor
        session.begin(with: currentValue) { value in
            currentValue = value
        }

        // User makes changes
        currentValue = 20

        // User drags to dismiss (triggers onDisappear)
        session.handleDismissal()

        // Value should be reverted
        #expect(currentValue == 10)
    }

    @Test("Reuse session for multiple edits")
    func testSessionReuse() {
        let session = EditSession<String>()
        var value = "original"

        // First edit - save
        session.begin(with: value) { v in value = v }
        value = "changed1"
        session.markSaved()
        session.handleDismissal()
        #expect(value == "changed1")

        // Second edit - cancel
        session.begin(with: value) { v in value = v }
        value = "changed2"
        session.cancelAndRevert()
        session.handleDismissal()
        #expect(value == "changed1") // Reverted to state at begin
    }
}

// MARK: - EditSession with GentleDesignSystem Types Tests

@Suite("EditSession with GentleDesignSystem Types Tests")
struct EditSessionGentleTypesTests {

    @Test("EditSession works with GentleTypographyRoleSpec")
    func testWithTypographySpec() {
        let session = EditSession<GentleTypographyRoleSpec>()
        var spec = GentleTypographyRoleSpec(
            pointSize: 16,
            weight: .regular,
            design: .default,
            relativeTo: .body,
            colorRole: .textPrimary
        )

        session.begin(with: spec) { value in
            spec = value
        }

        // Simulate edit
        spec.pointSize = 24

        // Cancel
        session.cancelAndRevert()

        #expect(spec.pointSize == 16)
    }

    @Test("EditSession works with GentleButtonRoleSpec")
    func testWithButtonSpec() {
        let session = EditSession<GentleButtonRoleSpec>()
        var spec = GentleButtonRoleSpec(
            shape: .rounded,
            fillRole: .solidFillPrimaryCTA,
            borderRole: .hidden,
            animationRole: .squish,
            pressedScale: 0.98,
            pressedOpacity: 1.0
        )

        session.begin(with: spec) { value in
            spec = value
        }

        // Simulate edit
        spec.shape = .pill
        spec.pressedScale = 0.9

        // Save
        session.markSaved()
        session.handleDismissal()

        // Should keep changes
        #expect(spec.shape == .pill)
        #expect(spec.pressedScale == 0.9)
    }

    @Test("EditSession works with GentleSurfaceRoleSpec")
    func testWithSurfaceSpec() {
        let session = EditSession<GentleSurfaceRoleSpec>()
        let border = GentleColorPair(lightHex: "#FFFFFF", darkHex: "#000000")
        var spec = GentleSurfaceRoleSpec(
            backgroundStyle: .solid(colorRole: .surfaceBase),
            surfaceDepthEffect: .noEffect,
            border: border,
            cornerRadius: 12,
            borderWidth: 0,
            shadowRadius: 0,
            shadowOpacity: 0,
            shadowOffsetX: 0,
            shadowOffsetY: 0
        )

        session.begin(with: spec) { value in
            spec = value
        }

        // Simulate edit
        spec.cornerRadius = 20
        spec.backgroundStyle = .material(material: .thin, tintColorRole: .surfaceTint, tintOpacity: 0.1)

        // Drag dismiss (no save)
        session.handleDismissal()

        // Should revert
        #expect(spec.cornerRadius == 12)
        if case .solid = spec.backgroundStyle {
            // Expected
        } else {
            Issue.record("Expected solid background style after revert")
        }
    }
}
