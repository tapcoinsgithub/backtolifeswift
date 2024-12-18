//
//  Shapes.swift
//  BackToLife
//
//  Created by Eric Viera on 11/26/24.
//

import Foundation
import SwiftUI

struct PolygonShape: Shape {
    var sides: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angle = .pi * 2 / CGFloat(sides)

        for i in 0..<sides {
            let x = center.x + radius * cos(angle * CGFloat(i))
            let y = center.y + radius * sin(angle * CGFloat(i))
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}
