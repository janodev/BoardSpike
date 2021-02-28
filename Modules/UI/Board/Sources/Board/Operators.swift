
import Foundation

// swiftlint:disable static_operator

// MARK: - Function composition

precedencegroup CompositionPrecedence {
    associativity: left
    higherThan: ForwardApplication, NilCoalescingPrecedence
}

infix operator >>>: CompositionPrecedence

/// Return a function that partially applies the function passed.
public func >>> <T, U, V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    { rhs(lhs($0)) }
}

// MARK: - Pipe forward

precedencegroup ForwardApplication {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator |>: ForwardApplication

/// Return the result of applying a function on a value.
public func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}
