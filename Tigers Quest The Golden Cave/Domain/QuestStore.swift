//
//  QuestStore.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import Combine
import Foundation

final class QuestStore: ObservableObject {
    @Published private(set) var gold: Int
    @Published private(set) var gems: Int
    @Published private(set) var staffRank: Int
    @Published private(set) var armorRank: Int
    @Published private(set) var step: ExpeditionStep
    @Published var reduceMotionPreference: Bool

    private let defaults: UserDefaults
    private let key = "quest.expedition.v2"
    private let motionKey = "quest.reduceMotion"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        reduceMotionPreference = defaults.bool(forKey: motionKey)
        if let data = defaults.data(forKey: key),
           let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) {
            gold = snapshot.gold
            gems = snapshot.gems
            staffRank = snapshot.staffRank
            armorRank = snapshot.armorRank
            step = snapshot.step
        } else if let legacy = defaults.data(forKey: "quest.expedition.v1"),
                  let snapshot = try? JSONDecoder().decode(Snapshot.self, from: legacy) {
            gold = snapshot.gold
            gems = snapshot.gems
            staffRank = snapshot.staffRank
            armorRank = snapshot.armorRank
            step = Self.migrated(from: snapshot.step)
            save()
        } else {
            gold = 0
            gems = 0
            staffRank = 0
            armorRank = 0
            step = .gallery
        }
    }

    var maxHealth: Int { 28 + armorRank * 5 }
    var maxGearRank: Int { 4 }

    var expeditionProgress: Double {
        let index = ExpeditionStep.allCases.firstIndex(of: step) ?? 0
        return Double(index) / Double(max(1, ExpeditionStep.allCases.count - 1))
    }

    var stageTitle: String {
        switch step {
        case .gallery: "First Gallery"
        case .sunLatch: "Sun Latch"
        case .kennel: "Ash Kennel"
        case .twinRubies: "Twin Rubies"
        case .mirrorHall: "Mirror Hall"
        case .veinSeal: "Vein Seal"
        case .ashBridge: "Ash Bridge"
        case .emberLatch: "Ember Latch"
        case .throne: "Brazier Throne"
        case .curseSeal: "Last Seal"
        case .quiet: "Quiet Cave"
        }
    }

    var primaryActionTitle: String {
        if storyFight != nil { return "Descend" }
        if step == .quiet { return "Rest by the fire" }
        return "Read the seal"
    }

    var primaryActionSymbol: String {
        if storyFight != nil { return "arrow.down.to.line" }
        if step == .quiet { return "flame.fill" }
        return "door.left.hand.closed"
    }

    var gearLine: String {
        let staff: String
        switch staffRank {
        case 0: staff = "The staff is still plain"
        case 1: staff = "The staff holds a warmer core"
        case 2: staff = "The staff burns steady"
        case 3: staff = "The staff throws a bright arc"
        default: staff = "The staff is at full heat"
        }
        let armor: String
        switch armorRank {
        case 0: armor = "and the shoulders are bare."
        case 1: armor = "and one plate sits on the shoulders."
        case 2: armor = "and the plates overlap."
        case 3: armor = "and the plates cover the chest."
        default: armor = "and the armor will take no more heat."
        }
        return "\(staff) \(armor)"
    }

    var situation: String {
        switch step {
        case .gallery: QuestCatalog.boneCat.threat
        case .sunLatch: QuestCatalog.coinWraith.threat
        case .kennel: QuestCatalog.hound.threat
        case .twinRubies: QuestCatalog.latchImp.threat
        case .mirrorHall: QuestCatalog.mirrorSerpent.threat
        case .veinSeal: QuestCatalog.veinBat.threat
        case .ashBridge: QuestCatalog.ashGolem.threat
        case .emberLatch: QuestCatalog.latchImp.threat
        case .throne: QuestCatalog.king.threat
        case .curseSeal: QuestCatalog.curseWarden.threat
        case .quiet: "The caves keep their gold. The curse is gone."
        }
    }

    var unlockedLore: [LoreEntry] {
        QuestCatalog.lore(unlockedBy: step)
    }

    var storyFight: FightOffer? {
        switch step {
        case .gallery: makeOffer(QuestCatalog.boneCat, advances: true)
        case .kennel: makeOffer(QuestCatalog.hound, advances: true)
        case .mirrorHall: makeOffer(QuestCatalog.mirrorSerpent, advances: true)
        case .ashBridge: makeOffer(QuestCatalog.ashGolem, advances: true)
        case .throne: makeOffer(QuestCatalog.king, advances: true)
        default: nil
        }
    }

    var patrol: FightOffer? {
        switch step {
        case .gallery, .kennel, .mirrorHall, .ashBridge, .throne: nil
        case .sunLatch: makeOffer(QuestCatalog.coinWraith, advances: false)
        case .twinRubies: makeOffer(QuestCatalog.latchImp, advances: false)
        case .veinSeal: makeOffer(QuestCatalog.veinBat, advances: false)
        case .emberLatch: makeOffer(QuestCatalog.latchImp, advances: false)
        case .curseSeal: makeOffer(QuestCatalog.curseWarden, advances: false)
        case .quiet: makeOffer(QuestCatalog.coinWraith, advances: false)
        }
    }

    private func makeOffer(_ foe: Foe, advances: Bool) -> FightOffer {
        FightOffer(
            foe: foe,
            advances: advances,
            staffRank: staffRank,
            armorRank: armorRank,
            playerMax: maxHealth
        )
    }

    var staffCost: Int? {
        let costs = [10, 18, 28, 40]
        return costs.indices.contains(staffRank) ? costs[staffRank] : nil
    }

    var armorCost: Int? {
        let costs = [8, 16, 26, 36]
        return costs.indices.contains(armorRank) ? costs[armorRank] : nil
    }

    func applyVictory(against foe: Foe, advances: Bool) {
        if advances {
            gold += foe.gold
            gems += foe.gems
            advance()
        } else {
            gold += max(4, foe.gold / 2)
        }
        save()
    }

    func spend(coins: Int, gems: Int) -> Bool {
        guard gold >= coins, self.gems >= gems else { return false }
        gold -= coins
        self.gems -= gems
        advance()
        save()
        return true
    }

    func temperStaff() -> String? {
        guard let staffCost else { return "The staff will take no more heat." }
        guard gold >= staffCost else { return "The pouch needs \(staffCost) coins." }
        gold -= staffCost
        staffRank += 1
        save()
        return nil
    }

    func rivetArmor() -> String? {
        guard let armorCost else { return "The plates will take no more heat." }
        guard gold >= armorCost else { return "The pouch needs \(armorCost) coins." }
        gold -= armorCost
        armorRank += 1
        save()
        return nil
    }

    func setReduceMotionPreference(_ value: Bool) {
        reduceMotionPreference = value
        defaults.set(value, forKey: motionKey)
    }

    func restartExpedition() {
        gold = 0
        gems = 0
        staffRank = 0
        armorRank = 0
        step = .gallery
        save()
    }

    private func advance() {
        switch step {
        case .gallery: step = .sunLatch
        case .sunLatch: step = .kennel
        case .kennel: step = .twinRubies
        case .twinRubies: step = .mirrorHall
        case .mirrorHall: step = .veinSeal
        case .veinSeal: step = .ashBridge
        case .ashBridge: step = .emberLatch
        case .emberLatch: step = .throne
        case .throne: step = .curseSeal
        case .curseSeal: step = .quiet
        case .quiet: break
        }
    }

    private static func migrated(from step: ExpeditionStep) -> ExpeditionStep {
        step
    }

    private func save() {
        let snapshot = Snapshot(gold: gold, gems: gems, staffRank: staffRank, armorRank: armorRank, step: step)
        if let data = try? JSONEncoder().encode(snapshot) {
            defaults.set(data, forKey: key)
        }
    }

    private struct Snapshot: Codable {
        var gold: Int
        var gems: Int
        var staffRank: Int
        var armorRank: Int
        var step: ExpeditionStep
    }
}
