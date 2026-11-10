//
//  ScreenChrome.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

extension View {
    func clearScrollBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.clear)
    }

    func transparentScreenChrome() -> some View {
        background(Color.clear)
    }
}

struct GameHUDView<Center: View>: View {
    var onClose: () -> Void
    @ViewBuilder var center: () -> Center

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(CavePalette.ink)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(CaveDepth.panelFill)
                            .overlay(Circle().stroke(CavePalette.gold.opacity(0.45), lineWidth: 1))
                    )
                    .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Leave the fight")

            center()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                colors: [CavePalette.cave.opacity(0.92), CavePalette.cave.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
        )
    }
}

struct PouchLabels: View {
    var gold: Int
    var gems: Int

    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        Group {
            if metrics.isNarrow {
                VStack(spacing: metrics.tileGap) {
                    ResourceChip(title: "Coins", value: gold, symbol: "seal.fill", tint: CavePalette.gold)
                    ResourceChip(title: "Rubies", value: gems, symbol: "diamond.fill", tint: CavePalette.ruby)
                }
            } else {
                HStack(alignment: .top, spacing: metrics.tileGap) {
                    ResourceChip(title: "Coins", value: gold, symbol: "seal.fill", tint: CavePalette.gold)
                    ResourceChip(title: "Rubies", value: gems, symbol: "diamond.fill", tint: CavePalette.ruby)
                }
            }
        }
    }
}

struct LifeTrack: View {
    var title: String
    var current: Int
    var maximum: Int
    var tint: Color

    private var fraction: CGFloat {
        guard maximum > 0 else { return 0 }
        return CGFloat(current) / CGFloat(maximum)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(title)
                    .font(CaveType.heading())
                    .foregroundStyle(CavePalette.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Spacer(minLength: 8)
                Text("\(current)/\(maximum)")
                    .font(CaveType.caption(.subheadline))
                    .foregroundStyle(CavePalette.inkDim)
                    .monospacedDigit()
                    .lineLimit(1)
            }
            ProgressTrack(title: nil, value: Double(fraction), tint: tint)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(current) of \(maximum)")
    }
}
