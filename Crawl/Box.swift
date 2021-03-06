// https://github.com/robrix/Box

public protocol BoxType {
    /// The type of the wrapped value.
    typealias Value

    /// Initializes an intance of the type with a value.
    init(_ value: Value)

    /// The wrapped value.
    var value: Value { get }
}

public final class Box<T>: BoxType, CustomStringConvertible {
    /// Initializes a `Box` with the given value.
    public init(_ value: T) {
        self.value = value
    }


    /// Constructs a `Box` with the given `value`.
    public class func unit(value: T) -> Box<T> {
        return Box(value)
    }


    /// The (immutable) value wrapped by the receiver.
    public let value: T

    /// Constructs a new Box by transforming `value` by `f`.
    public func map<U>(@noescape f: T -> U) -> Box<U> {
        return Box<U>(f(value))
    }


    // MARK: Printable
    
    public var description: String {
        return String(value)
    }
}

// MARK: Equality

/// Equality of `BoxType`s of `Equatable` types.
///
/// We cannot declare that e.g. `Box<T: Equatable>` conforms to `Equatable`, so this is a relatively ad hoc definition.
public func == <B: BoxType where B.Value: Equatable> (lhs: B, rhs: B) -> Bool {
    return lhs.value == rhs.value
}

/// Inequality of `BoxType`s of `Equatable` types.
///
/// We cannot declare that e.g. `Box<T: Equatable>` conforms to `Equatable`, so this is a relatively ad hoc definition.
public func != <B: BoxType where B.Value: Equatable> (lhs: B, rhs: B) -> Bool {
    return lhs.value != rhs.value
}


// MARK: Map

/// Maps the value of a box into a new box.
public func map<B: BoxType, C: BoxType>(v: B, @noescape f: B.Value -> C.Value) -> C {
    return C(f(v.value))
}