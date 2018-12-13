// Made by Paul Lucas and Marc Heimendinger

extension Formula {
    
    /// The negation normal form of the formula.
    public var nnf: Formula {
        // Write your code here.
        switch self {
        case .constant(_):
            return self
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .constant(_):
                return self
            case .proposition(_):
                return self
            case .negation(let a):
                return a.nnf
            case .disjunction(let a, let b):
                return .conjunction(.negation(a.nnf), .negation(b.nnf))
            case .conjunction(let a, let b):
                return .disjunction(.negation(a.nnf), .negation(b.nnf))
            case .implication(let a, let b):
                return .conjunction(a.nnf, .negation(b.nnf))
            }
        case .disjunction(let a, let b):
            return .disjunction(a.nnf, b.nnf)
        case .conjunction(let a, let b):
            if a == b {
                return a
            } else {
                return .conjunction(a.nnf, b.nnf)
            }
        case .implication(let a, let b):
            return .disjunction(.negation(a.nnf), b.nnf)
        }
    }
    
    /// The disjunctive normal form (DNF) of the formula.
    public var dnf: Formula {
        // Write your code here.
        // conjunction : && ∧
        // Disjunction : || ∨
        switch self.nnf {
        case .conjunction(let a, let b):
            var checkDisjunction = true
            var lhs1: Formula?
            var lhs2: Formula?
            var rhs1: Formula?
            var rhs2: Formula?
            switch a {
            case .disjunction(let a1, let a2):
                lhs1 = a1
                lhs2 = a2
            default:
                checkDisjunction = false
            }
            switch b {
            case .disjunction(let b1, let b2):
                rhs1 = b1
                rhs2 = b2
            default:
                checkDisjunction = false
            }
            if checkDisjunction {
                if lhs1 == rhs1 {
                    return .disjunction(lhs1!.dnf, .conjunction(lhs2!.dnf, rhs2!.dnf))
                } else if lhs1 == rhs2 {
                    return .disjunction(lhs1!.dnf, .conjunction(lhs2!.dnf, rhs1!.dnf))
                } else if lhs2 == rhs1 {
                    return .disjunction(lhs2!.dnf, .conjunction(lhs2!.dnf, rhs1!.dnf))
                } else if lhs2 == rhs2 {
                    return .disjunction(lhs2!.dnf, .conjunction(lhs2!.dnf, rhs2!.dnf))
                } else { // If all are different
                    return .disjunction(Formula.disjunction(.conjunction(lhs1!, rhs1!), .conjunction(lhs1!, rhs2!)).dnf, Formula.disjunction(.conjunction(lhs2!, rhs1!), .conjunction(lhs2!, rhs2!)).dnf)
                }
            }
        case .disjunction(let lhs, let rhs):
            var lhsConstant = false
            var lhsDisjunction = false
            var rhsConstant = false
            var rhsDisjunction = false
            var a: Formula?
            var b: Formula?
            var c: Formula?
            switch lhs {
            case .disjunction(let lhs1, let lhs2):
                a = lhs1
                b = lhs2
                lhsDisjunction = true
            case .constant(let lhs):
                c = .constant(lhs)
                lhsConstant = true
            case .negation(let lhs):
                c = lhs
                lhsConstant = true
            default:
                break
            }
            switch rhs {
            case .disjunction(let rhs1, let rhs2):
                a = rhs1
                b = rhs2
                rhsDisjunction = true
            case .constant(let rhs):
                c = .constant(rhs)
                rhsConstant = true
            case .negation(let rhs):
                c = rhs
                rhsConstant = true
            default:
                break
            }
            if (lhsConstant && rhsDisjunction) || (lhsDisjunction && rhsConstant) {
                return .disjunction(.conjunction(a!.dnf, c!.dnf), .conjunction(c!.dnf, b!.dnf))
            }
        default:
            return self.nnf
        }
        return self.nnf
    }
    
    /// The conjunctive normal form (CNF) of the formula.
    public var cnf: Formula {
        // Write your code here.
        switch self.nnf {
        case .disjunction(let a, let b):
            var checkConjunction = true
            var lhs1: Formula?
            var lhs2: Formula?
            var rhs1: Formula?
            var rhs2: Formula?
            switch a {
            case .conjunction(let a1, let a2):
                lhs1 = a1
                lhs2 = a2
            default:
                checkConjunction = false
            }
            switch b {
            case .conjunction(let b1, let b2):
                rhs1 = b1
                rhs2 = b2
            default:
                checkConjunction = false
            }
            if checkConjunction {
                if lhs1 == rhs1 {
                    return .conjunction(lhs1!.dnf, .disjunction(lhs2!.dnf, rhs2!.dnf))
                } else if lhs1 == rhs2 {
                    return .conjunction(lhs1!.dnf, .disjunction(lhs2!.dnf, rhs1!.dnf))
                } else if lhs2 == rhs1 {
                    return .conjunction(lhs2!.dnf, .disjunction(lhs2!.dnf, rhs1!.dnf))
                } else if lhs2 == rhs2 {
                    return .conjunction(lhs2!.dnf, .disjunction(lhs2!.dnf, rhs2!.dnf))
                } else { // If all are different
                    return .conjunction(Formula.conjunction(.disjunction(lhs1!, rhs1!), .disjunction(lhs1!, rhs2!)).dnf, Formula.conjunction(.disjunction(lhs2!, rhs1!), .disjunction(lhs2!, rhs2!)).dnf)
                }
            }
        case .conjunction(let lhs, let rhs):
            var lhsConstant = false
            var lhsConjunction = false
            var rhsConstant = false
            var rhsConjunction = false
            var a: Formula?
            var b: Formula?
            var c: Formula?
            switch lhs {
            case .conjunction(let lhs1, let lhs2):
                a = lhs1
                b = lhs2
                lhsConjunction = true
            case .constant(let lhs):
                c = .constant(lhs)
                lhsConstant = true
            case .negation(let lhs):
                c = lhs
                lhsConstant = true
            default:
                break
            }
            switch rhs {
            case .conjunction(let rhs1, let rhs2):
                a = rhs1
                b = rhs2
                rhsConjunction = true
            case .constant(let rhs):
                c = .constant(rhs)
                rhsConstant = true
            case .negation(let rhs):
                c = rhs
                rhsConstant = true
            default:
                break
            }
            if (lhsConstant && rhsConjunction) || (lhsConjunction && rhsConstant) {
                return .conjunction(.disjunction(a!.dnf, c!.dnf), .disjunction(c!.dnf, b!.dnf))
            }
        default:
            return self.nnf
        }
        return self.nnf
    }
    
    /// The minterms of a formula in disjunctive normal form.
    public var minterms: Set<Set<Formula>> {
        // Write your code here.
        var output = Set<Set<Formula>>()
        switch self {
        case .disjunction(_, _):
            for operand in self.disjunctionOperands {
                output.insert(operand.conjunctionOperands)
            }
            return output
        default:
            return output
        }
    }
    
    /// The maxterms of a formula in conjunctive normal form.
    public var maxterms: Set<Set<Formula>> {
        // Write your code here.
        var output = Set<Set<Formula>>()
        switch self {
        case .conjunction(_, _):
            for operand in self.conjunctionOperands {
                output.insert(operand.disjunctionOperands)
            }
            return output
        default:
            return output
        }
    }
    
    /// Unfold a tree of binary disjunctions into a set of operands.
    ///
    ///     let f: Formula = .disjunction("a", .disjunction("b", .negation("c")))
    ///     print(disjunctionOperands)
    ///     // Prints "[a, b, ¬c]"
    ///
    private var disjunctionOperands: Set<Formula> {
        switch self {
        case .disjunction(let a, let b):
            return a.disjunctionOperands.union(b.disjunctionOperands)
        default:
            return [self]
        }
    }
    
    /// Unfold a tree of binary conjunctions into a set of operands.
    ///
    ///     let f: Formula = .conjunction("a", .conjunction("b", .negation("c")))
    ///     print(f.conjunctionOperands)
    ///     // Prints "[a, b, ¬c]"
    ///
    private var conjunctionOperands: Set<Formula> {
        switch self {
        case .conjunction(let a, let b):
            return a.conjunctionOperands.union(b.conjunctionOperands)
        default:
            return [self]
        }
    }
    
}
