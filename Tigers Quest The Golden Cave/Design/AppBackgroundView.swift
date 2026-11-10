//
//  AppBackgroundView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.26, green: 0.11, blue: 0.04),
                    CavePalette.cave,
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [CavePalette.ember.opacity(0.32), .clear],
                center: UnitPoint(x: 0.5, y: 0.22),
                startRadius: 8,
                endRadius: 340
            )

            RadialGradient(
                colors: [CavePalette.gold.opacity(0.10), .clear],
                center: UnitPoint(x: 0.12, y: 0.88),
                startRadius: 2,
                endRadius: 240
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .ignoresSafeArea()
    }
}
