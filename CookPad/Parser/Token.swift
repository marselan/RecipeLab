//
//  Token.swift
//  CookPad
//
//  Created by Mariano Arselan on 30-01-26.
//

import Foundation

enum Token {
    case number(Int)
    case plus
    case minus
    case leftParen
    case rightParen
}

indirect enum Expression {
    case number(Int)
    case add(Expression, Expression)
    case substract(Expression, Expression)
}

struct Parser<A> {
    let parse: (String) -> (A, String)?
}

func pure<A>(_ a: A) -> Parser<A> {
    Parser { (a, $0) }
}

func empty<A>() -> Parser<A> {
    Parser { _ in nil }
}
