//
//  CaveTypography.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

enum CaveType {
    private static let family = "Cinzel"

    static func display(_ style: Font.TextStyle = .title, weight: Font.Weight = .bold) -> Font {
        .custom(family, size: pointSize(for: style), relativeTo: style).weight(weight)
    }

    static func title(_ style: Font.TextStyle = .title2, weight: Font.Weight = .bold) -> Font {
        .custom(family, size: pointSize(for: style), relativeTo: style).weight(weight)
    }

    static func heading(_ style: Font.TextStyle = .headline, weight: Font.Weight = .semibold) -> Font {
        .custom(family, size: pointSize(for: style), relativeTo: style).weight(weight)
    }

    static func body(_ style: Font.TextStyle = .body, weight: Font.Weight = .regular) -> Font {
        .system(style, design: .rounded).weight(weight)
    }

    static func caption(_ style: Font.TextStyle = .caption, weight: Font.Weight = .semibold) -> Font {
        .system(style, design: .rounded).weight(weight)
    }

    private static func pointSize(for style: Font.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: 34
        case .title: 28
        case .title2: 22
        case .title3: 20
        case .headline: 17
        case .body: 17
        case .callout: 16
        case .subheadline: 15
        case .footnote: 13
        case .caption: 12
        case .caption2: 11
        @unknown default: 17
        }
    }
}

struct CaveMetrics: Equatable {
    var width: CGFloat

    var gutter: CGFloat {
        if width < 360 { return 14 }
        if width > 430 { return 24 }
        return 18
    }

    var stack: CGFloat {
        if width < 360 { return 20 }
        if width > 430 { return 28 }
        return 24
    }

    var sectionGap: CGFloat {
        width < 360 ? 12 : 14
    }

    var panelInset: CGFloat {
        width < 360 ? 12 : 16
    }

    var tileGap: CGFloat {
        width < 360 ? 12 : 14
    }

    var tabBarClearance: CGFloat {
        92
    }

    var heroHeight: CGFloat {
        min(260, max(176, width * 0.56))
    }

    var bannerHeight: CGFloat {
        min(168, max(120, width * 0.36))
    }

    var battleArtHeight: CGFloat {
        min(230, max(168, width * 0.5))
    }

    var mediaSide: CGFloat {
        min(120, max(84, width * 0.28))
    }

    var spellCardWidth: CGFloat {
        min(158, max(124, width * 0.36))
    }

    var isNarrow: Bool {
        width < 380
    }

    var shortcutColumns: [GridItem] {
        if isNarrow {
            return [GridItem(.flexible(minimum: 0), spacing: tileGap)]
        }
        return [
            GridItem(.flexible(minimum: 0), spacing: tileGap),
            GridItem(.flexible(minimum: 0), spacing: tileGap)
        ]
    }
}

private struct CaveMetricsKey: EnvironmentKey {
    static let defaultValue = CaveMetrics(width: 390)
}

extension EnvironmentValues {
    var caveMetrics: CaveMetrics {
        get { self[CaveMetricsKey.self] }
        set { self[CaveMetricsKey.self] = newValue }
    }
}

private struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 390
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CaveAdaptiveContainer<Content: View>: View {
    @ViewBuilder var content: () -> Content
    @State private var width: CGFloat = 390

    var body: some View {
        content()
            .environment(\.caveMetrics, CaveMetrics(width: width))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: WidthPreferenceKey.self, value: geo.size.width)
                }
            )
            .onPreferenceChange(WidthPreferenceKey.self) { width = $0 }
    }
}
