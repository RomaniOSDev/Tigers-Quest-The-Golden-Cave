//
//  BattleView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct BattleView: View {
    @EnvironmentObject private var store: QuestStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var session: BattleSession
    private let advances: Bool
    @State private var rewarded = false

    init(offer: FightOffer) {
        advances = offer.advances
        _session = StateObject(
            wrappedValue: BattleSession(
                foe: offer.foe,
                staffRank: offer.staffRank,
                armorRank: offer.armorRank,
                playerMax: offer.playerMax
            )
        )
    }

    var body: some View {
        Group {
            if let outcome = session.outcome {
                result(outcome)
            } else {
                playfield
            }
        }
        .preferredColorScheme(.dark)
        .sensoryFeedback(
            .impact(weight: session.pulse.heavy ? .heavy : .medium, intensity: 1),
            trigger: session.pulse.token
        )
        .onChange(of: session.outcome) { _, outcome in
            guard outcome == .victory, !rewarded else { return }
            rewarded = true
            store.applyVictory(against: session.foe, advances: advances)
        }
    }

    private var playfield: some View {
        ZStack {
            AppBackgroundView()
            CaveAdaptiveContainer {
                BattlePlayfield(
                    session: session,
                    onAct: act
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            GameHUDView(onClose: { dismiss() }) {
                CavePanel(padding: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        LifeTrack(
                            title: "You",
                            current: session.playerHealth,
                            maximum: session.playerMax,
                            tint: CavePalette.gold
                        )
                        if session.block > 0 {
                            Text("Ward \(session.block)")
                                .font(CaveType.caption(.subheadline))
                                .foregroundStyle(CavePalette.lapis)
                        }
                    }
                }
            }
        }
    }

    private func result(_ outcome: BattleSession.Outcome) -> some View {
        ZStack {
            AppBackgroundView()
            CaveAdaptiveContainer {
                BattleResultScroll(
                    session: session,
                    advances: advances,
                    outcome: outcome,
                    onDismiss: { dismiss() }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func act(_ held: HeldSpell, strike: Bool) {
        let quiet = reduceMotion || store.reduceMotionPreference
        if quiet {
            session.play(held, strike: strike)
        } else {
            withAnimation(.easeOut(duration: 0.18)) {
                session.play(held, strike: strike)
            }
        }
    }
}

private struct BattlePlayfield: View {
    @ObservedObject var session: BattleSession
    var onAct: (HeldSpell, Bool) -> Void
    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        VStack(alignment: .leading, spacing: metrics.tileGap + 2) {
            CavePanel(padding: 0) {
                VStack(spacing: 0) {
                    Image(CaveArtName.foe(session.foe.kind))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: metrics.battleArtHeight)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [.clear, CavePalette.cave.opacity(0.9)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )

                    VStack(alignment: .leading, spacing: 10) {
                        Text(session.foe.name)
                            .font(CaveType.display(.title))
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        LifeTrack(
                            title: "Foe",
                            current: session.foeHealth,
                            maximum: session.foe.maxHealth,
                            tint: CavePalette.ruby
                        )
                        Text(session.log)
                            .font(CaveType.body())
                            .foregroundStyle(CavePalette.inkDim)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(minHeight: 44, alignment: .topLeading)
                    }
                    .padding(metrics.panelInset)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CaveDepth.panelRadius, style: .continuous))

            Spacer(minLength: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("Spells")
                    .font(CaveType.heading())
                    .foregroundStyle(CavePalette.ink)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: metrics.tileGap) {
                        ForEach(session.hand) { held in
                            SpellCardCell(spell: held.kind) {
                                onAct(held, false)
                            } onSwipe: {
                                onAct(held, true)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .clearScrollBackground()
            }
        }
        .padding(.horizontal, metrics.gutter)
        .padding(.top, 72)
        .padding(.bottom, 12)
    }
}

private struct BattleResultScroll: View {
    @ObservedObject var session: BattleSession
    var advances: Bool
    var outcome: BattleSession.Outcome
    var onDismiss: () -> Void
    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                CaveAssetImage(name: CaveArtName.foe(session.foe.kind), height: metrics.battleArtHeight)
                CavePanel {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(outcome == .victory ? "Victory" : "Retreat")
                            .font(CaveType.display(.title))
                            .foregroundStyle(outcome == .victory ? CavePalette.gold : CavePalette.ruby)
                        Text(outcome == .victory ? session.foe.victoryLine : "You stagger back to the fire. The curse is still ahead.")
                            .font(CaveType.title(.title3, weight: .semibold))
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        if outcome == .victory, advances {
                            Text("\(session.foe.gold) coins and \(session.foe.gems) rubies go into the pouch.")
                                .font(CaveType.body())
                                .foregroundStyle(CavePalette.inkDim)
                        } else if outcome == .victory {
                            Text("\(max(4, session.foe.gold / 2)) coins go into the pouch.")
                                .font(CaveType.body())
                                .foregroundStyle(CavePalette.inkDim)
                        }
                        CaveActionButton(title: "Back to the fire", symbol: "flame.fill", action: onDismiss)
                    }
                }
            }
            .padding(.horizontal, metrics.gutter)
            .padding(.top, 24)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clearScrollBackground()
    }
}

#Preview {
    BattleView(offer: FightOffer(
        foe: QuestCatalog.boneCat,
        advances: true,
        staffRank: 0,
        armorRank: 0,
        playerMax: 28
    ))
    .environmentObject(QuestStore(defaults: UserDefaults(suiteName: "battle.preview") ?? .standard))
}
