//
//  CaveTabBar.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

enum CampTab: Int, CaseIterable, Identifiable {
    case campfire
    case seals
    case forge
    case settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .campfire: "Campfire"
        case .seals: "Seals"
        case .forge: "Forge"
        case .settings: "Settings"
        }
    }

    var symbol: String {
        switch self {
        case .campfire: "flame.fill"
        case .seals: "door.left.hand.closed"
        case .forge: "hammer.fill"
        case .settings: "gearshape.fill"
        }
    }
}

struct CaveTabBar: View {
    @Binding var selection: CampTab

    var body: some View {
        HStack(spacing: 6) {
            ForEach(CampTab.allCases) { tab in
                CaveTabItem(
                    tab: tab,
                    isSelected: selection == tab
                ) {
                    selection = tab
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background {
            CaveRaisedShape(radius: 26, fill: CaveDepth.panelFill, elevated: true)
        }
        .padding(.horizontal, 14)
        .padding(.bottom, 6)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Camp tabs")
    }
}

private struct CaveTabItem: View {
    var tab: CampTab
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(CaveDepth.emberFill)
                            .frame(width: 44, height: 32)
                            .shadow(color: CavePalette.ember.opacity(0.45), radius: 8, x: 0, y: 3)
                    }
                    Image(systemName: tab.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isSelected ? CavePalette.ink : CavePalette.inkDim)
                        .frame(width: 44, height: 32)
                }
                Text(tab.title)
                    .font(CaveType.caption(weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? CavePalette.gold : CavePalette.inkDim)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
