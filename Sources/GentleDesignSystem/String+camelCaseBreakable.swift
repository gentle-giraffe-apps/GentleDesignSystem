import Swift

extension String {
    var camelCaseBreakable: String {
        self
            // Break before uppercase letters
            .replacingOccurrences(
                of: "([a-z])([A-Z])",
                with: "$1\u{200B}$2",
                options: .regularExpression
            )
            // Optional: allow break before underscores too
            .replacingOccurrences(of: "_", with: "\u{200B}_")
    }
}
