//
//  CaveWidgets.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct HomeHeroWidget: View {
    var situation: String
    var progress: Double
    var stageTitle: String
    var primaryTitle: String
    var primarySymbol: String
    var onPrimary: () -> Void

    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        CavePanel(padding: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    CaveAssetImage(name: CaveArtName.homeHero, height: metrics.heroHeight, corner: 0, faded: false)
                        .mask(
                            LinearGradient(
                                colors: [.white, .white, .white.opacity(0.12)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(stageTitle)
                            .font(CaveType.display(.title))
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(situation)
                            .font(CaveType.body())
                            .foregroundStyle(CavePalette.bone)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(metrics.panelInset)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ProgressTrack(title: "Expedition", value: progress, tint: CavePalette.gold)
                    CaveActionButton(title: primaryTitle, symbol: primarySymbol, action: onPrimary)
                }
                .padding(metrics.panelInset)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CaveDepth.panelRadius, style: .continuous))
    }
}

struct ResourceChip: View {
    var title: String
    var value: Int
    var symbol: String
    var tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(Circle().fill(tint.opacity(0.2)))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(CaveType.caption())
                    .foregroundStyle(CavePalette.inkDim)
                Text("\(value)")
                    .font(CaveType.heading(.title3, weight: .bold))
                    .foregroundStyle(CavePalette.ink)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                .fill(CaveDepth.tileFill)
                .overlay {
                    RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                        .strokeBorder(tint.opacity(0.4), lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value)")
    }
}

struct PouchWidget: View {
    var gold: Int
    var gems: Int

    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        CavePanel(padding: 0, elevated: false) {
            Group {
                if metrics.isNarrow {
                    VStack(alignment: .leading, spacing: 12) {
                        Image(CaveArtName.pouch)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .clipped()
                            .accessibilityHidden(true)
                        pouchCopy
                            .padding(.horizontal, metrics.panelInset)
                            .padding(.bottom, metrics.panelInset)
                    }
                } else {
                    HStack(alignment: .top, spacing: 0) {
                        Image(CaveArtName.pouch)
                            .resizable()
                            .scaledToFill()
                            .frame(width: metrics.mediaSide, height: metrics.mediaSide + 12)
                            .clipped()
                            .accessibilityHidden(true)
                        pouchCopy
                            .padding(metrics.panelInset)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CaveDepth.panelRadius, style: .continuous))
    }

    private var pouchCopy: some View {
        VStack(alignment: .leading, spacing: 10) {
            ResourceChip(title: "Coins", value: gold, symbol: "seal.fill", tint: CavePalette.gold)
            ResourceChip(title: "Rubies", value: gems, symbol: "diamond.fill", tint: CavePalette.ruby)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ShortcutWidget: View {
    var title: String
    var detail: String
    var imageName: String
    var symbol: String
    var action: () -> Void

    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: metrics.isNarrow ? 148 : 132)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.72)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Label(title, systemImage: symbol)
                        .font(CaveType.heading())
                        .foregroundStyle(CavePalette.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    Text(detail)
                        .font(CaveType.caption())
                        .foregroundStyle(CavePalette.bone)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                    .strokeBorder(CaveDepth.goldEdge, lineWidth: 1.1)
            }
            .background {
                RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                    .fill(Color.black.opacity(0.001))
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 5)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, minHeight: 44)
        .accessibilityLabel(title)
        .accessibilityHint(detail)
    }
}

struct GearStatusCell: View {
    var title: String
    var symbol: String
    var rank: Int
    var maxRank: Int
    var detail: String

    var body: some View {
        CavePanel(elevated: false) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: symbol)
                    .font(.title2)
                    .foregroundStyle(CavePalette.ember)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(CavePalette.ember.opacity(0.18)))

                VStack(alignment: .leading, spacing: 8) {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 8) {
                            Text(title)
                                .font(CaveType.heading())
                                .foregroundStyle(CavePalette.ink)
                            Spacer(minLength: 8)
                            rankLabel
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(CaveType.heading())
                                .foregroundStyle(CavePalette.ink)
                            rankLabel
                        }
                    }
                    Text(detail)
                        .font(CaveType.body(.subheadline))
                        .foregroundStyle(CavePalette.inkDim)
                        .fixedSize(horizontal: false, vertical: true)
                    ProgressTrack(
                        title: nil,
                        value: Double(rank) / Double(max(1, maxRank)),
                        tint: CavePalette.ember
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var rankLabel: some View {
        Text("Rank \(rank)/\(maxRank)")
            .font(CaveType.caption(.subheadline))
            .foregroundStyle(CavePalette.gold)
            .monospacedDigit()
            .lineLimit(1)
    }
}

struct ThreatCell: View {
    var foe: Foe
    var caption: String
    var actionTitle: String
    var action: () -> Void

    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        CavePanel(padding: 0, elevated: false) {
            Group {
                if metrics.isNarrow {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(CaveArtName.foe(foe.kind))
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .clipped()
                            .accessibilityHidden(true)
                        threatCopy
                            .padding(metrics.panelInset)
                    }
                } else {
                    HStack(alignment: .top, spacing: 0) {
                        Image(CaveArtName.foe(foe.kind))
                            .resizable()
                            .scaledToFill()
                            .frame(width: metrics.mediaSide + 8, height: 148)
                            .clipped()
                            .accessibilityHidden(true)
                        threatCopy
                            .padding(metrics.panelInset)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CaveDepth.panelRadius, style: .continuous))
    }

    private var threatCopy: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(foe.name)
                .font(CaveType.title(.title3))
                .foregroundStyle(CavePalette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(caption)
                .font(CaveType.body(.subheadline))
                .foregroundStyle(CavePalette.inkDim)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 8) {
                MiniStat(symbol: "heart.fill", text: "\(foe.maxHealth)", tint: CavePalette.ruby)
                MiniStat(symbol: "flame.fill", text: "\(foe.power)", tint: CavePalette.ember)
            }
            CaveActionButton(title: actionTitle, symbol: "figure.fencing", action: action)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SealCell<Content: View>: View {
    var title: String
    var inscription: String
    var stateLabel: String
    var accent: Color
    var isCurrent: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        CavePanel(elevated: false) {
            VStack(alignment: .leading, spacing: 12) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(CaveType.title(.title3))
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 8)
                        stateBadge
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(CaveType.title(.title3))
                            .foregroundStyle(CavePalette.ink)
                        stateBadge
                    }
                }
                Text(inscription)
                    .font(isCurrent ? CaveType.body(weight: .semibold) : CaveType.body())
                    .foregroundStyle(isCurrent ? CavePalette.ink : CavePalette.inkDim)
                    .fixedSize(horizontal: false, vertical: true)
                content()
            }
        }
    }

    private var stateBadge: some View {
        Text(stateLabel)
            .font(CaveType.caption(weight: .bold))
            .foregroundStyle(accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(accent.opacity(0.18)))
    }
}

struct LoreCell: View {
    var entry: LoreEntry

    var body: some View {
        CavePanel(elevated: false) {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(CaveType.title(.title3))
                    .foregroundStyle(CavePalette.gold)
                Text(entry.body)
                    .font(CaveType.body())
                    .foregroundStyle(CavePalette.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ForgeUpgradeCell: View {
    var title: String
    var symbol: String
    var detail: String
    var rank: Int
    var maxRank: Int
    var cost: Int?
    var canAfford: Bool
    var actionTitle: String
    var note: String?
    var action: () -> Void

    var body: some View {
        CavePanel(elevated: false) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: symbol)
                        .font(.title2)
                        .foregroundStyle(CavePalette.gold)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(CavePalette.gold.opacity(0.16)))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(CaveType.title(.title3))
                            .foregroundStyle(CavePalette.ink)
                        Text("Rank \(rank)/\(maxRank)")
                            .font(CaveType.caption(.subheadline))
                            .foregroundStyle(CavePalette.gold)
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(detail)
                    .font(CaveType.body())
                    .foregroundStyle(CavePalette.inkDim)
                    .fixedSize(horizontal: false, vertical: true)
                ProgressTrack(
                    title: nil,
                    value: Double(rank) / Double(max(1, maxRank)),
                    tint: CavePalette.ember
                )
                if let cost {
                    Text(canAfford ? "This heat costs \(cost) coins." : "This heat costs \(cost) coins. The pouch is short.")
                        .font(CaveType.body(.subheadline))
                        .foregroundStyle(canAfford ? CavePalette.inkDim : CavePalette.ruby)
                        .fixedSize(horizontal: false, vertical: true)
                    CaveActionButton(
                        title: actionTitle,
                        symbol: "hammer.fill",
                        enabled: canAfford,
                        action: action
                    )
                } else {
                    Text("This piece will take no more heat.")
                        .font(CaveType.heading())
                        .foregroundStyle(CavePalette.gold)
                }
                if let note {
                    Text(note)
                        .font(CaveType.caption(.footnote))
                        .foregroundStyle(CavePalette.inkDim)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct ProgressTrack: View {
    var title: String?
    var value: Double
    var tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title {
                Text(title)
                    .font(CaveType.caption(.subheadline))
                    .foregroundStyle(CavePalette.inkDim)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(CavePalette.cave.opacity(0.9))
                        .overlay(Capsule().strokeBorder(CavePalette.gold.opacity(0.18), lineWidth: 1))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [tint, tint.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(10, geo.size.width * min(1, max(0, value))))
                        .shadow(color: tint.opacity(0.35), radius: 3, x: 0, y: 1)
                }
            }
            .frame(height: 12)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title ?? "Progress")
        .accessibilityValue("\(Int((value * 100).rounded())) percent")
    }
}

struct MiniStat: View {
    var symbol: String
    var text: String
    var tint: Color

    var body: some View {
        Label(text, systemImage: symbol)
            .font(CaveType.caption())
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Capsule().fill(tint.opacity(0.16)))
    }
}

struct SpellCardCell: View {
    var spell: SpellKind
    var onTap: () -> Void
    var onSwipe: () -> Void

    @Environment(\.caveMetrics) private var metrics
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var lift: CGFloat = 0
    @State private var swiped = false

    var body: some View {
        Button(action: {
            if swiped {
                swiped = false
                return
            }
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [CavePalette.ember.opacity(0.35), CavePalette.cave],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 54)
                    Image(systemName: spell.symbol)
                        .font(.title2)
                        .foregroundStyle(CavePalette.gold)
                }
                Text(spell.title)
                    .font(CaveType.heading())
                    .foregroundStyle(CavePalette.ink)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                Text(spell.detail)
                    .font(CaveType.caption())
                    .foregroundStyle(CavePalette.inkDim)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Swipe up to strike")
                    .font(CaveType.caption(.caption2, weight: .semibold))
                    .foregroundStyle(CavePalette.ember)
            }
            .padding(12)
            .frame(width: metrics.spellCardWidth, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                    .fill(CaveDepth.panelFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CaveDepth.tileRadius, style: .continuous)
                    .stroke(CaveDepth.goldEdge, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .frame(minHeight: 44)
        .offset(y: reduceMotion ? 0 : lift)
        .accessibilityLabel(spell.title)
        .accessibilityHint("Tap to cast. Swipe up to strike with the staff.")
        .simultaneousGesture(
            DragGesture(minimumDistance: 24)
                .onChanged { value in
                    guard value.translation.height < 0, abs(value.translation.height) > abs(value.translation.width) else { return }
                    swiped = true
                    if !reduceMotion {
                        lift = max(-36, value.translation.height)
                    }
                }
                .onEnded { value in
                    let strike = value.translation.height < -40 && abs(value.translation.height) > abs(value.translation.width)
                    lift = 0
                    if strike {
                        swiped = true
                        onSwipe()
                    } else {
                        swiped = false
                    }
                }
        )
    }
}
