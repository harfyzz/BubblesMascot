//
//  SpeechBubble.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 16/05/2026.
//

import SwiftUI

struct SpeechBubble: View {
    let text: String
    var direction: Direction = .down
    
    enum Direction {
        case up, down, left, right
    }
    
    private let pointerSize: CGFloat = 14
    private let cornerRadius: CGFloat = 12
    
    private var isHorizontal: Bool {
        direction == .left || direction == .right
    }
    
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundStyle(Color("gray700"))
            .frame(maxWidth: isHorizontal ? .infinity : nil, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(pointerEdge, pointerSize)
            .background(
                BubbleShape(direction: direction, cornerRadius: cornerRadius, pointerSize: pointerSize)
                    .fill(Color("gray100"))
            )
            .overlay(
                BubbleShape(direction: direction, cornerRadius: cornerRadius, pointerSize: pointerSize)
                    .stroke(Color("gray200"), lineWidth: 1.5)
            )
    }
    
    private var pointerEdge: Edge.Set {
        switch direction {
        case .up: return .top
        case .down: return .bottom
        case .left: return .leading
        case .right: return .trailing
        }
    }
}

private struct BubbleShape: Shape {
    let direction: SpeechBubble.Direction
    let cornerRadius: CGFloat
    let pointerSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let r = cornerRadius
        let p = pointerSize
        
        let bRect: CGRect
        switch direction {
        case .up:
            bRect = CGRect(x: rect.minX, y: rect.minY + p, width: rect.width, height: rect.height - p)
        case .down:
            bRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - p)
        case .left:
            bRect = CGRect(x: rect.minX + p, y: rect.minY, width: rect.width - p, height: rect.height)
        case .right:
            bRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width - p, height: rect.height)
        }
        
        var path = Path()
        
        // Top-left corner
        path.move(to: CGPoint(x: bRect.minX + r, y: bRect.minY))
        
        // Top edge + up pointer
        if direction == .up {
            let cx = bRect.midX
            path.addLine(to: CGPoint(x: cx - p, y: bRect.minY))
            path.addLine(to: CGPoint(x: cx, y: rect.minY))
            path.addLine(to: CGPoint(x: cx + p, y: bRect.minY))
        }
        
        // Top-right corner
        path.addLine(to: CGPoint(x: bRect.maxX - r, y: bRect.minY))
        path.addArc(center: CGPoint(x: bRect.maxX - r, y: bRect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        
        // Right edge + right pointer
        if direction == .right {
            let cy = bRect.midY
            path.addLine(to: CGPoint(x: bRect.maxX, y: cy - p))
            path.addLine(to: CGPoint(x: rect.maxX, y: cy))
            path.addLine(to: CGPoint(x: bRect.maxX, y: cy + p))
        }
        
        // Bottom-right corner
        path.addLine(to: CGPoint(x: bRect.maxX, y: bRect.maxY - r))
        path.addArc(center: CGPoint(x: bRect.maxX - r, y: bRect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        // Bottom edge + down pointer
        if direction == .down {
            let cx = bRect.midX
            path.addLine(to: CGPoint(x: cx + p, y: bRect.maxY))
            path.addLine(to: CGPoint(x: cx, y: rect.maxY))
            path.addLine(to: CGPoint(x: cx - p, y: bRect.maxY))
        }
        
        // Bottom-left corner
        path.addLine(to: CGPoint(x: bRect.minX + r, y: bRect.maxY))
        path.addArc(center: CGPoint(x: bRect.minX + r, y: bRect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        // Left edge + left pointer
        if direction == .left {
            let cy = bRect.midY
            path.addLine(to: CGPoint(x: bRect.minX, y: cy + p))
            path.addLine(to: CGPoint(x: rect.minX, y: cy))
            path.addLine(to: CGPoint(x: bRect.minX, y: cy - p))
        }
        
        // Top-left corner
        path.addLine(to: CGPoint(x: bRect.minX, y: bRect.minY + r))
        path.addArc(center: CGPoint(x: bRect.minX + r, y: bRect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.closeSubpath()
        return path
    }
}
#Preview {
    VStack(spacing: 32) {
        SpeechBubble(text: "Hi there! I'm Bubbles!", direction: .down)
        SpeechBubble(text: "What's your programming comfort level?", direction: .left)
        SpeechBubble(text: "Pointing up!", direction: .up)
        SpeechBubble(text: "Pointing right!", direction: .right)
    }
    .padding()
}

