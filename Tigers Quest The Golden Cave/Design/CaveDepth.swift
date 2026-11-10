//
//  CaveDepth.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

/// Static fills — created once, reused across cards (no per-frame gradient rebuild thrash).
enum CaveDepth {
    static let panelRadius: CGFloat = 18
    static let tileRadius: CGFloat = 16
    static let sectionRadius: CGFloat = 22

    static let panelFill = LinearGradient(
        colors: [
            Color(red: 0.34, green: 0.16, blue: 0.07),
            Color(red: 0.17, green: 0.07, blue: 0.03),
            Color(red: 0.07, green: 0.03, blue: 0.015)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let sectionFill = LinearGradient(
        colors: [
            Color(red: 0.24, green: 0.11, blue: 0.05),
            Color(red: 0.09, green: 0.035, blue: 0.02)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let tileFill = LinearGradient(
        colors: [
            Color(red: 0.30, green: 0.14, blue: 0.06),
            Color(red: 0.12, green: 0.05, blue: 0.02)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldEdge = LinearGradient(
        colors: [
            CavePalette.gold.opacity(0.92),
            CavePalette.ember.opacity(0.42),
            CavePalette.gold.opacity(0.22)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let rimLight = LinearGradient(
        colors: [
            Color.white.opacity(0.26),
            Color.white.opacity(0.05),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let sheen = LinearGradient(
        colors: [
            CavePalette.gold.opacity(0.14),
            Color.clear,
            CavePalette.ember.opacity(0.08)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let emberFill = LinearGradient(
        colors: [CavePalette.ember, CavePalette.emberDeep],
        startPoint: .top,
        endPoint: .bottom
    )

    static let bannerFade = LinearGradient(
        colors: [.clear, CavePalette.cave.opacity(0.55), CavePalette.cave.opacity(0.95)],
        startPoint: .top,
        endPoint: .bottom
    )
}

/// Single-shadow raised surface. Shadow sits on the shape, not on text/images.
struct CaveRaisedShape: View {
    var radius: CGFloat
    var fill: LinearGradient
    var elevated: Bool = true

    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(fill)
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(CaveDepth.sheen)
                    .allowsHitTesting(false)
            }
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(CaveDepth.rimLight, lineWidth: 1)
                    .padding(0.5)
                    .allowsHitTesting(false)
            }
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(CaveDepth.goldEdge, lineWidth: 1.1)
                    .allowsHitTesting(false)
            }
            .shadow(
                color: elevated ? Color.black.opacity(0.45) : .clear,
                radius: elevated ? 10 : 0,
                x: 0,
                y: elevated ? 6 : 0
            )
    }
}

struct CavePanel<Content: View>: View {
    var padding: CGFloat? = nil
    var elevated: Bool = true
    @Environment(\.caveMetrics) private var metrics
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding ?? metrics.panelInset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                CaveRaisedShape(
                    radius: CaveDepth.panelRadius,
                    fill: CaveDepth.panelFill,
                    elevated: elevated
                )
            }
    }
}

struct CaveSection<Content: View>: View {
    var title: String?
    var subtitle: String? = nil
    @Environment(\.caveMetrics) private var metrics
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: metrics.sectionGap) {
            if let title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(CaveType.title())
                        .foregroundStyle(CavePalette.gold)
                    if let subtitle {
                        Text(subtitle)
                            .font(CaveType.caption(.subheadline))
                            .foregroundStyle(CavePalette.inkDim)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            content()
        }
        .padding(metrics.panelInset)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            CaveRaisedShape(
                radius: CaveDepth.sectionRadius,
                fill: CaveDepth.sectionFill,
                elevated: true
            )
        }
    }
}

struct CaveScreenHeader: View {
    var title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(CaveType.display(.title))
                .foregroundStyle(CavePalette.ink)
                .fixedSize(horizontal: false, vertical: true)
            if let subtitle {
                Text(subtitle)
                    .font(CaveType.body(.subheadline))
                    .foregroundStyle(CavePalette.inkDim)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 2)
        .accessibilityAddTraits(.isHeader)
    }
}

struct CaveActionButton: View {
    var title: String
    var symbol: String
    var emphasis: Bool = true
    var enabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .font(.body.weight(.semibold))
                Text(title)
                    .font(CaveType.heading())
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .foregroundStyle(emphasis ? CavePalette.ink : CavePalette.gold)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(emphasis ? AnyShapeStyle(CaveDepth.emberFill) : AnyShapeStyle(CavePalette.caveLift.opacity(0.85)))
                    .shadow(
                        color: emphasis ? CavePalette.ember.opacity(0.28) : Color.black.opacity(0.22),
                        radius: 6,
                        x: 0,
                        y: 4
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(CavePalette.gold.opacity(emphasis ? 0.55 : 0.3), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.45)
    }
}

struct CaveAssetImage: View {
    var name: String
    var height: CGFloat
    var corner: CGFloat = CaveDepth.panelRadius
    var faded: Bool = true

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipped()
            .overlay {
                if faded {
                    CaveDepth.bannerFade
                        .allowsHitTesting(false)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(CavePalette.gold.opacity(0.3), lineWidth: 1)
            }
            .background {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color.black.opacity(0.001))
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 5)
            }
            .accessibilityHidden(true)
    }
}

enum CaveArtName {
    static let homeHero = "home_hero"
    static let pouch = "widget_pouch"
    static let seal = "widget_seal"
    static let forge = "widget_forge"

    static func foe(_ kind: FoeKind) -> String {
        switch kind {
        case .boneCat: "foe_bone_cat"
        case .hound: "foe_grave_hound"
        case .emberKing: "foe_ember_crown"
        case .coinWraith: "foe_coin_wraith"
        case .mirrorSerpent: "foe_mirror_serpent"
        case .veinBat: "foe_vein_bat"
        case .ashGolem: "foe_ash_golem"
        case .latchImp: "foe_latch_imp"
        }
    }
}
