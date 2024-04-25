import Foundation
import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(MapLibreSwiftMacrosImpl)
    import MapLibreSwiftMacrosImpl
#endif

final class ExpressionTests: XCTestCase {
    override func invokeTest() {
        #if canImport(MapLibreSwiftMacrosImpl)
            withMacroTesting(macros: [
                MLNStylePropertyMacro.self,
                MLNRawRepresentableStylePropertyMacro.self,
            ]) {
                super.invokeTest()
            }
        #endif
    }

    // TODO: Non-enum attachment

    func testMLNStylePropertyValid() throws {
        #if canImport(MapLibreSwiftMacrosImpl)
            assertMacro {
                """
                @MLNStyleProperty<UIColor>("backgroundColor")
                struct Layer {
                }
                """
            } matches: {
                """
                struct Layer {

                    fileprivate var backgroundColor: NSExpression? = nil

                    public func backgroundColor(_ value: UIColor) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forConstantValue: value)
                        return copy
                    }
                
                    public func backgroundColor(expression: NSExpression) -> Self {
                        var copy = self
                        copy.backgroundColor = expression
                        return copy
                    }

                    public func backgroundColor(featurePropertyNamed keyPath: String) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forKeyPath: keyPath)
                        return copy
                    }
                }
                """
            }

            assertMacro {
                """
                @MLNStyleProperty<UIColor>("backgroundColor", supportsInterpolation: false)
                struct Layer {
                }
                """
            } matches: {
                """
                struct Layer {

                    fileprivate var backgroundColor: NSExpression? = nil

                    public func backgroundColor(_ value: UIColor) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forConstantValue: value)
                        return copy
                    }
                
                    public func backgroundColor(expression: NSExpression) -> Self {
                        var copy = self
                        copy.backgroundColor = expression
                        return copy
                    }

                    public func backgroundColor(featurePropertyNamed keyPath: String) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forKeyPath: keyPath)
                        return copy
                    }
                }
                """
            }
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMLNStylePropertyValidWithSupportedExpressions() throws {
        #if canImport(MapLibreSwiftMacrosImpl)
            assertMacro {
                """
                @MLNStyleProperty<UIColor>("backgroundColor", supportsInterpolation: true)
                struct Layer {
                }
                """
            } matches: {
                """
                struct Layer {

                    fileprivate var backgroundColor: NSExpression? = nil

                    public func backgroundColor(_ value: UIColor) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forConstantValue: value)
                        return copy
                    }
                
                    public func backgroundColor(expression: NSExpression) -> Self {
                        var copy = self
                        copy.backgroundColor = expression
                        return copy
                    }

                    public func backgroundColor(featurePropertyNamed keyPath: String) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forKeyPath: keyPath)
                        return copy
                    }

                    public func backgroundColor(interpolatedBy expression: MLNVariableExpression, curveType: MLNExpressionInterpolationMode, parameters: NSExpression?, stops: NSExpression) -> Self {
                        var copy = self
                        copy.backgroundColor = interpolatingExpression(expression: expression, curveType: curveType, parameters: parameters, stops: stops)
                        return copy
                    }
                }
                """
            }
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testStyleRawExpressionValid() throws {
        #if canImport(MapLibreSwiftMacrosImpl)
            assertMacro {
                """
                @MLNRawRepresentableStyleProperty<UIColor>("backgroundColor")
                struct Layer {
                }
                """
            } matches: {
                """
                struct Layer {

                    fileprivate var backgroundColor: NSExpression? = nil

                    public func backgroundColor(_ value: UIColor) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forConstantValue: value.mlnRawValue.rawValue)
                        return copy
                    }

                    public func backgroundColor(expression: NSExpression) -> Self {
                        var copy = self
                        copy.backgroundColor = expression
                        return copy
                    }
                
                    public func backgroundColor(featurePropertyNamed keyPath: String) -> Self {
                        var copy = self
                        copy.backgroundColor = NSExpression(forKeyPath: keyPath)
                        return copy
                    }
                }
                """
            }
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
