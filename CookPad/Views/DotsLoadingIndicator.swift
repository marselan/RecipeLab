//
//  DotsLoadingIndicator.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct DotsLoadingIndicator: View {
    
    @State private var animationStarted = false
    
    var body: some View {
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 25, height: 25)
                        .padding(3)
                        .foregroundColor(.orange)
                        .scaleEffect(animationStarted ? 1 : 0)
                        .animation(.linear(duration: 0.6).repeatForever().delay(0.2 * Double(index)), value: animationStarted)
            }
            .onAppear {
                self.animationStarted.toggle()
            }
        }
    }
}

#Preview {
    DotsLoadingIndicator()
}
