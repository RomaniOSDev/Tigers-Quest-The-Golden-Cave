//
//  ContentView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = QuestStore()
    @State private var tab: CampTab = .campfire
    @State private var fight: FightOffer?

    var body: some View {
        ZStack(alignment: .bottom) {
            tabRoot
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CaveTabBar(selection: $tab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .environmentObject(store)
        .fullScreenCover(item: $fight) { offer in
            BattleView(offer: offer)
                .environmentObject(store)
        }
    }

    @ViewBuilder
    private var tabRoot: some View {
        switch tab {
        case .campfire:
            NavigationStack {
                HomeView(tab: $tab, fight: $fight)
            }
            .transparentScreenChrome()
        case .seals:
            NavigationStack {
                DoorPuzzleView()
            }
            .transparentScreenChrome()
        case .forge:
            NavigationStack {
                ForgeView()
            }
            .transparentScreenChrome()
        case .settings:
            NavigationStack {
                SettingsView()
            }
            .transparentScreenChrome()
        }
    }
}

struct HomeView: View {
    @Binding var tab: CampTab
    @Binding var fight: FightOffer?

    var body: some View {
        ZStack {
            AppBackgroundView()

            CaveAdaptiveContainer {
                HomeScroll(tab: $tab, fight: $fight)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct HomeScroll: View {
    @EnvironmentObject private var store: QuestStore
    @Environment(\.caveMetrics) private var metrics
    @Binding var tab: CampTab
    @Binding var fight: FightOffer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                HomeHeroWidget(
                    situation: store.situation,
                    progress: store.expeditionProgress,
                    stageTitle: store.stageTitle,
                    primaryTitle: store.primaryActionTitle,
                    primarySymbol: store.primaryActionSymbol,
                    onPrimary: handlePrimary
                )

                CaveSection(title: "Pouch", subtitle: "Gold stays in the caves.") {
                    PouchWidget(gold: store.gold, gems: store.gems)
                }

                CaveSection(title: "Paths", subtitle: "Seals and forge share the same fire.") {
                    LazyVGrid(columns: metrics.shortcutColumns, spacing: metrics.tileGap) {
                        ShortcutWidget(
                            title: "Seals",
                            detail: sealShortcutDetail,
                            imageName: CaveArtName.seal,
                            symbol: "door.left.hand.closed"
                        ) {
                            tab = .seals
                        }

                        ShortcutWidget(
                            title: "Forge",
                            detail: "Temper the staff or rivet a plate.",
                            imageName: CaveArtName.forge,
                            symbol: "hammer.fill"
                        ) {
                            tab = .forge
                        }
                    }
                }

                CaveSection(title: "Gear", subtitle: "Heat held in wood and plate.") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                        GearStatusCell(
                            title: "Staff",
                            symbol: "wand.and.stars",
                            rank: store.staffRank,
                            maxRank: store.maxGearRank,
                            detail: store.gearLine
                        )

                        GearStatusCell(
                            title: "Armor",
                            symbol: "shield.fill",
                            rank: store.armorRank,
                            maxRank: store.maxGearRank,
                            detail: "\(store.maxHealth) life at the start of a fight."
                        )
                    }
                }

                if let offer = store.storyFight {
                    CaveSection(title: "Threat", subtitle: "Story path. Victory opens the next hall.") {
                        ThreatCell(
                            foe: offer.foe,
                            caption: "Defeat \(offer.foe.name) to advance.",
                            actionTitle: "Enter the fight",
                            action: { fight = offer }
                        )
                    }
                } else if let patrol = store.patrol {
                    CaveSection(title: "Patrol", subtitle: "Gather coins for the seals and the forge.") {
                        ThreatCell(
                            foe: patrol.foe,
                            caption: patrol.foe.threat,
                            actionTitle: "Gather coins",
                            action: { fight = patrol }
                        )
                    }
                } else if store.step == .quiet {
                    CaveSection(title: "Quiet") {
                        CavePanel {
                            Text("The curse is quiet. Stay by the fire or gather what the seals no longer need.")
                                .font(CaveType.body())
                                .foregroundStyle(CavePalette.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                CaveSection(title: "Codex", subtitle: "Pages the caves have opened.") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                        ForEach(store.unlockedLore) { entry in
                            LoreCell(entry: entry)
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

    private var sealShortcutDetail: String {
        if store.step == .quiet {
            return "Every seal has turned."
        }
        if store.storyFight != nil {
            return "Open after the next fight."
        }
        return "Match the inscription and turn the stone."
    }

    private func handlePrimary() {
        if let offer = store.storyFight {
            fight = offer
        } else if store.step == .quiet {
            return
        } else {
            tab = .seals
        }
    }
}

#Preview {
    ContentView()
}
