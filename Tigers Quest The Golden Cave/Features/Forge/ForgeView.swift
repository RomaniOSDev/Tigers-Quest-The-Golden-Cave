//
//  ForgeView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct ForgeView: View {
    @EnvironmentObject private var store: QuestStore
    @State private var note = "Gold from the caves feeds the fire. It does not leave the cave."
    @State private var staffNote: String?
    @State private var armorNote: String?

    var body: some View {
        ZStack {
            AppBackgroundView()
            CaveAdaptiveContainer {
                ForgeScroll(
                    note: $note,
                    staffNote: $staffNote,
                    armorNote: $armorNote
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct ForgeScroll: View {
    @EnvironmentObject private var store: QuestStore
    @Environment(\.caveMetrics) private var metrics
    @Binding var note: String
    @Binding var staffNote: String?
    @Binding var armorNote: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                CaveScreenHeader(
                    title: "Forge",
                    subtitle: "Gold from the caves feeds the fire."
                )

                CaveSection(title: nil) {
                    CaveAssetImage(name: CaveArtName.forge, height: metrics.bannerHeight, corner: CaveDepth.tileRadius)
                    PouchLabels(gold: store.gold, gems: store.gems)
                }

                CaveSection(title: "Brazier", subtitle: note) {
                    CavePanel(elevated: false) {
                        Text(store.gearLine)
                            .font(CaveType.body())
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                CaveSection(title: "Temper", subtitle: "Coins stay in the cave.") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                ForgeUpgradeCell(
                    title: "Staff",
                    symbol: "wand.and.stars",
                    detail: "Each temper adds harm to every spell. A swipe adds that heat twice, and two more.",
                    rank: store.staffRank,
                    maxRank: store.maxGearRank,
                    cost: store.staffCost,
                    canAfford: store.staffCost.map { store.gold >= $0 } ?? false,
                    actionTitle: "Temper the staff",
                    note: staffNote
                ) {
                    if let message = store.temperStaff() {
                        staffNote = message
                    } else {
                        staffNote = "The staff takes the heat."
                        note = "The forge holds. Coins stay in the cave."
                    }
                }

                ForgeUpgradeCell(
                    title: "Armor",
                    symbol: "shield.fill",
                    detail: "Each plate softens a blow and adds life at the start of a fight.",
                    rank: store.armorRank,
                    maxRank: store.maxGearRank,
                    cost: store.armorCost,
                    canAfford: store.armorCost.map { store.gold >= $0 } ?? false,
                    actionTitle: "Rivet a plate",
                    note: armorNote
                ) {
                    if let message = store.rivetArmor() {
                        armorNote = message
                    } else {
                        armorNote = "The plate holds."
                        note = "The forge holds. Coins stay in the cave."
                    }
                }
                    }
                }
            }
            .padding(.horizontal, metrics.gutter)
            .padding(.top, 4)
            .padding(.bottom, metrics.tabBarClearance)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clearScrollBackground()
    }
}
