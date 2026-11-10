//
//  BattleSession.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import Combine
import Foundation

final class BattleSession: ObservableObject {
    enum Outcome: Equatable {
        case victory
        case defeat
    }

    struct Pulse: Equatable {
        var token = 0
        var heavy = false
    }

    let foe: Foe
    let staffRank: Int
    let armorRank: Int
    let playerMax: Int

    @Published private(set) var foeHealth: Int
    @Published private(set) var playerHealth: Int
    @Published private(set) var block = 0
    @Published private(set) var hand: [HeldSpell] = []
    @Published private(set) var log: String
    @Published private(set) var outcome: Outcome?
    @Published private(set) var pulse = Pulse()

    private var drawPile: [SpellKind]
    private var discard: [SpellKind] = []

    init(foe: Foe, staffRank: Int, armorRank: Int, playerMax: Int) {
        self.foe = foe
        self.staffRank = staffRank
        self.armorRank = armorRank
        self.playerMax = playerMax
        foeHealth = foe.maxHealth
        playerHealth = playerMax
        drawPile = QuestCatalog.openingDeck().shuffled()
        log = "Tap a spell. Swipe it up to put the staff behind it."
        draw(upTo: 3)
    }

    func play(_ held: HeldSpell, strike: Bool) {
        guard outcome == nil, let index = hand.firstIndex(where: { $0.id == held.id }) else { return }
        let spell = held.kind
        hand.remove(at: index)
        discard.append(spell)
        pulse.token += 1
        pulse.heavy = strike

        if spell == .ward {
            block = (strike ? 8 : 5) + armorRank * 2
            log = strike ? "The staff braces a heavier ward (\(block))." : "A ward rises (\(block))."
        } else {
            let harm = spell.baseDamage + staffRank + (strike ? staffRank + 2 : 0)
            foeHealth = max(0, foeHealth - harm)
            log = strike
                ? "The staff strike lands for \(harm)."
                : "\(spell.title) lands for \(harm)."
            if spell == .caveBreathe {
                draw(upTo: hand.count + 1)
                log += " The cave answers with another spell."
            }
        }

        guard foeHealth > 0 else {
            outcome = .victory
            return
        }

        let raw = max(1, foe.power - armorRank)
        let soaked = min(block, raw)
        let dealt = raw - soaked
        block = max(0, block - soaked)
        playerHealth = max(0, playerHealth - dealt)
        if dealt == 0 {
            log += " The ward holds."
        } else {
            log += " \(foe.name) hits for \(dealt)."
        }

        guard playerHealth > 0 else {
            outcome = .defeat
            return
        }
        draw(upTo: hand.count + 1)
    }

    private func draw(upTo target: Int) {
        while hand.count < target {
            if drawPile.isEmpty {
                drawPile = discard.shuffled()
                discard.removeAll()
            }
            guard !drawPile.isEmpty else { return }
            hand.append(HeldSpell(drawPile.removeFirst()))
        }
    }
}

struct HeldSpell: Identifiable, Equatable {
    let id = UUID()
    var kind: SpellKind

    init(_ kind: SpellKind) {
        self.kind = kind
    }
}
