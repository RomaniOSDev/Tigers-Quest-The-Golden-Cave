//
//  DoorPuzzleView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct DoorPuzzleView: View {
    @EnvironmentObject private var store: QuestStore
    @State private var placed: [Offering?] = []
    @State private var note = "Match the inscription, then turn the seal."

    private var order: [ExpeditionStep] { ExpeditionStep.allCases }

    var body: some View {
        ZStack {
            AppBackgroundView()
            CaveAdaptiveContainer {
                DoorScroll(placed: $placed, note: $note)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: resetSlots)
        .onChange(of: store.step) { _, _ in
            resetSlots()
        }
    }

    private func resetSlots() {
        guard let seal = QuestCatalog.seals.first(where: { $0.step == store.step }) else {
            placed = []
            return
        }
        placed = Array(repeating: nil, count: seal.pattern.count)
        note = "Match the inscription, then turn the seal."
    }
}

private struct DoorScroll: View {
    @EnvironmentObject private var store: QuestStore
    @Environment(\.caveMetrics) private var metrics
    @Binding var placed: [Offering?]
    @Binding var note: String

    private var order: [ExpeditionStep] { ExpeditionStep.allCases }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                CaveScreenHeader(
                    title: "Seals",
                    subtitle: "Match the inscription, then turn the stone."
                )

                CaveSection(title: nil) {
                    CaveAssetImage(name: CaveArtName.seal, height: metrics.bannerHeight, corner: CaveDepth.tileRadius)
                    PouchLabels(gold: store.gold, gems: store.gems)
                }

                if store.step == .quiet {
                    CaveSection(title: "Quiet Cave") {
                        CavePanel(elevated: false) {
                            Text("Every seal has turned. Leave the rest of the gold where it lies.")
                                .font(CaveType.title(.title3, weight: .semibold))
                                .foregroundStyle(CavePalette.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                CaveSection(title: "Stone Latches", subtitle: "Only the open seal takes an offering.") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                        ForEach(QuestCatalog.seals) { seal in
                            sealCell(seal)
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

    @ViewBuilder
    private func sealCell(_ seal: Seal) -> some View {
        let state = phase(of: seal)
        SealCell(
            title: seal.title,
            inscription: seal.inscription,
            stateLabel: stateLabel(state),
            accent: stateAccent(state),
            isCurrent: state == .current
        ) {
            switch state {
            case .open:
                Text("The stone has already turned.")
                    .font(CaveType.caption(.subheadline, weight: .semibold))
                    .foregroundStyle(CavePalette.gold)
            case .buried:
                Text("Still buried behind the last fight.")
                    .font(CaveType.body(.subheadline))
                    .foregroundStyle(CavePalette.inkDim)
            case .current:
                VStack(alignment: .leading, spacing: 12) {
                    slots
                    Group {
                        if metrics.isNarrow {
                            VStack(spacing: 10) {
                                CaveActionButton(title: "Coin", symbol: "seal.fill", emphasis: false) {
                                    place(.coin)
                                }
                                CaveActionButton(title: "Ruby", symbol: "diamond.fill", emphasis: false) {
                                    place(.gem)
                                }
                            }
                        } else {
                            HStack(spacing: 10) {
                                CaveActionButton(title: "Coin", symbol: "seal.fill", emphasis: false) {
                                    place(.coin)
                                }
                                CaveActionButton(title: "Ruby", symbol: "diamond.fill", emphasis: false) {
                                    place(.gem)
                                }
                            }
                        }
                    }
                    CaveActionButton(title: "Turn the seal", symbol: "key.horizontal.fill") {
                        turn(seal)
                    }
                    Text(note)
                        .font(CaveType.caption(.footnote))
                        .foregroundStyle(CavePalette.inkDim)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var slots: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(placed.indices, id: \.self) { index in
                    Button {
                        placed[index] = nil
                        note = "That offering is back in the pouch."
                    } label: {
                        slotFace(placed[index])
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityLabel(slotLabel(placed[index]))
                }
            }
            .padding(.vertical, 2)
        }
        .clearScrollBackground()
    }

    private func slotFace(_ offering: Offering?) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(CaveDepth.tileFill)
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(CaveDepth.goldEdge, lineWidth: 1.1)
                }
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
            switch offering {
            case .coin:
                Image(systemName: "seal.fill")
                    .font(.title3)
                    .foregroundStyle(CavePalette.gold)
            case .gem:
                Image(systemName: "diamond.fill")
                    .font(.title3)
                    .foregroundStyle(CavePalette.ruby)
            case nil:
                Image(systemName: "plus")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(CavePalette.inkDim)
            }
        }
    }

    private func place(_ offering: Offering) {
        guard let index = placed.firstIndex(where: { $0 == nil }) else {
            note = "Every hollow is full. Tap one to take it back."
            return
        }
        let coins = placed.compactMap { $0 }.filter { $0 == .coin }.count
        let gems = placed.compactMap { $0 }.filter { $0 == .gem }.count
        if offering == .coin && store.gold - coins <= 0 {
            note = "No coins left in the pouch."
            return
        }
        if offering == .gem && store.gems - gems <= 0 {
            note = "No rubies left in the pouch."
            return
        }
        placed[index] = offering
        note = "Tap a hollow to take an offering back."
    }

    private func turn(_ seal: Seal) {
        let offering = placed.compactMap { $0 }
        guard offering.count == seal.pattern.count else {
            note = "Every hollow still needs an offering."
            return
        }
        guard offering == seal.pattern else {
            placed = Array(repeating: nil, count: seal.pattern.count)
            note = "The stone pushes the offering back. Read the inscription again."
            return
        }
        let coins = offering.filter { $0 == .coin }.count
        let gems = offering.filter { $0 == .gem }.count
        if store.spend(coins: coins, gems: gems) {
            note = "The seal turns. The way is open."
        } else {
            note = "The pouch cannot pay this offering."
        }
    }

    private func phase(of seal: Seal) -> SealPhase {
        guard let current = order.firstIndex(of: store.step),
              let index = order.firstIndex(of: seal.step) else { return .buried }
        if current == index { return .current }
        return current > index ? .open : .buried
    }

    private func stateLabel(_ state: SealPhase) -> String {
        switch state {
        case .open: "Open"
        case .buried: "Buried"
        case .current: "Ready"
        }
    }

    private func stateAccent(_ state: SealPhase) -> Color {
        switch state {
        case .open: CavePalette.gold
        case .buried: CavePalette.inkDim
        case .current: CavePalette.ember
        }
    }

    private func slotLabel(_ offering: Offering?) -> String {
        switch offering {
        case .coin: "Coin. Take it back."
        case .gem: "Ruby. Take it back."
        case nil: "Empty hollow."
        }
    }

    private enum SealPhase {
        case open
        case buried
        case current
    }
}
