//
//  QuestModels.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import Foundation

enum ExpeditionStep: String, Codable, CaseIterable {
    case gallery
    case sunLatch
    case kennel
    case twinRubies
    case mirrorHall
    case veinSeal
    case ashBridge
    case emberLatch
    case throne
    case curseSeal
    case quiet
}

enum Offering: String, Codable, Equatable {
    case coin
    case gem
}

enum FoeKind: String, Codable {
    case boneCat
    case hound
    case emberKing
    case coinWraith
    case mirrorSerpent
    case veinBat
    case ashGolem
    case latchImp
}

struct Foe: Equatable, Identifiable {
    var id: String
    var kind: FoeKind
    var name: String
    var threat: String
    var maxHealth: Int
    var power: Int
    var gold: Int
    var gems: Int
    var victoryLine: String
}

struct Seal: Identifiable, Equatable {
    var id: String
    var step: ExpeditionStep
    var title: String
    var inscription: String
    var pattern: [Offering]
}

struct LoreEntry: Identifiable, Equatable {
    var id: String
    var title: String
    var body: String
    var unlocksAt: ExpeditionStep
}

enum SpellKind: String, CaseIterable, Identifiable {
    case emberJab
    case goldArc
    case lapisBolt
    case ward
    case cleave
    case rubyShard
    case caveBreathe

    var id: String { rawValue }

    var title: String {
        switch self {
        case .emberJab: "Ember Jab"
        case .goldArc: "Gold Arc"
        case .lapisBolt: "Lapis Bolt"
        case .ward: "Stone Ward"
        case .cleave: "Staff Cleave"
        case .rubyShard: "Ruby Shard"
        case .caveBreathe: "Cave Breathe"
        }
    }

    var symbol: String {
        switch self {
        case .emberJab: "flame.fill"
        case .goldArc: "sparkles"
        case .lapisBolt: "bolt.fill"
        case .ward: "shield.fill"
        case .cleave: "wand.and.stars"
        case .rubyShard: "diamond.fill"
        case .caveBreathe: "wind"
        }
    }

    var baseDamage: Int {
        switch self {
        case .emberJab: 5
        case .goldArc: 7
        case .lapisBolt: 9
        case .ward: 0
        case .cleave: 4
        case .rubyShard: 8
        case .caveBreathe: 3
        }
    }

    var detail: String {
        switch self {
        case .ward: "Raise a ward"
        case .caveBreathe: "Light harm, draws a card of heat"
        default: "\(baseDamage) harm, plus the staff"
        }
    }
}

enum QuestCatalog {
    static let boneCat = Foe(
        id: "bone-cat",
        kind: .boneCat,
        name: "Bone-cat",
        threat: "Blue bone-cats clutch the coins in the first gallery.",
        maxHealth: 22,
        power: 4,
        gold: 12,
        gems: 1,
        victoryLine: "The bone-cat falls apart. Coins and a ruby spill out of the curse."
    )

    static let boneLitter = Foe(
        id: "bone-litter",
        kind: .boneCat,
        name: "Bone litter",
        threat: "A litter of bone-cats spills through the mirror hall.",
        maxHealth: 28,
        power: 5,
        gold: 16,
        gems: 2,
        victoryLine: "The litter scatters. The mirrors give up coins and rubies."
    )

    static let hound = Foe(
        id: "grave-hound",
        kind: .hound,
        name: "Grave hound",
        threat: "A grave hound blocks the ash kennel.",
        maxHealth: 32,
        power: 6,
        gold: 18,
        gems: 2,
        victoryLine: "The hound slumps. The kennel gives up its coins and two rubies."
    )

    static let bridgeHound = Foe(
        id: "bridge-hound",
        kind: .hound,
        name: "Ash-bridge hound",
        threat: "A second hound waits on the ash bridge.",
        maxHealth: 38,
        power: 7,
        gold: 22,
        gems: 2,
        victoryLine: "The bridge clears. Coins and rubies cool in the ash."
    )

    static let king = Foe(
        id: "ember-crown",
        kind: .emberKing,
        name: "Ember crown",
        threat: "The crowned ember waits beside the brazier.",
        maxHealth: 48,
        power: 9,
        gold: 34,
        gems: 3,
        victoryLine: "The crown drops its torch. The brazier leaves gold and three rubies."
    )

    static let coinWraith = Foe(
        id: "coin-wraith",
        kind: .coinWraith,
        name: "Coin wraith",
        threat: "A hood of lapis gathers around the sun latch coins.",
        maxHealth: 26,
        power: 5,
        gold: 14,
        gems: 1,
        victoryLine: "The wraith thins to dust. Coins ring on the stone."
    )

    static let mirrorSerpent = Foe(
        id: "mirror-serpent",
        kind: .mirrorSerpent,
        name: "Mirror serpent",
        threat: "A serpent of reflections coils through the mirror hall.",
        maxHealth: 34,
        power: 6,
        gold: 20,
        gems: 2,
        victoryLine: "The serpent shatters. Rubies glint in the glass dust."
    )

    static let veinBat = Foe(
        id: "vein-bat",
        kind: .veinBat,
        name: "Vein bat",
        threat: "Ruby-veined bats cling above the vein seal.",
        maxHealth: 30,
        power: 6,
        gold: 17,
        gems: 2,
        victoryLine: "The bat drops. A warm ruby sticks to the floor."
    )

    static let ashGolem = Foe(
        id: "ash-golem",
        kind: .ashGolem,
        name: "Ash golem",
        threat: "A golem of riveted ash blocks the cooled halls.",
        maxHealth: 42,
        power: 8,
        gold: 26,
        gems: 2,
        victoryLine: "The golem cracks open. Coins spill from the seams."
    )

    static let latchImp = Foe(
        id: "latch-imp",
        kind: .latchImp,
        name: "Latch imp",
        threat: "An imp dances on the ember latch with a stolen key.",
        maxHealth: 28,
        power: 7,
        gold: 19,
        gems: 2,
        victoryLine: "The imp drops the key. Rubies roll from its pouch."
    )

    static let curseWarden = Foe(
        id: "curse-warden",
        kind: .ashGolem,
        name: "Curse warden",
        threat: "A heavier golem still guards the last seal.",
        maxHealth: 44,
        power: 8,
        gold: 28,
        gems: 3,
        victoryLine: "The warden falls. The last seal is free to turn."
    )

    static let seals: [Seal] = [
        Seal(
            id: "sun",
            step: .sunLatch,
            title: "Sun Latch",
            inscription: "A ruby sits between two coins.",
            pattern: [.coin, .gem, .coin]
        ),
        Seal(
            id: "twins",
            step: .twinRubies,
            title: "Twin Rubies",
            inscription: "Rubies guard a pair of coins.",
            pattern: [.gem, .coin, .coin, .gem]
        ),
        Seal(
            id: "vein",
            step: .veinSeal,
            title: "Vein Seal",
            inscription: "Three coins, then a ruby.",
            pattern: [.coin, .coin, .coin, .gem]
        ),
        Seal(
            id: "ember",
            step: .emberLatch,
            title: "Ember Latch",
            inscription: "Ruby, coin, ruby.",
            pattern: [.gem, .coin, .gem]
        ),
        Seal(
            id: "curse",
            step: .curseSeal,
            title: "Curse Seal",
            inscription: "Gold and ruby alternate. Gold is at both ends.",
            pattern: [.coin, .gem, .coin, .gem, .coin]
        )
    ]

    static let lore: [LoreEntry] = [
        LoreEntry(
            id: "fire",
            title: "Campfire",
            body: "The tiger mage rests here between halls. Gold stays in the pouch; it never leaves the caves.",
            unlocksAt: .gallery
        ),
        LoreEntry(
            id: "gallery",
            title: "First Gallery",
            body: "Bone-cats nest in the coin piles. A short strike with the staff clears a path to the sun latch.",
            unlocksAt: .gallery
        ),
        LoreEntry(
            id: "kennel",
            title: "Ash Kennel",
            body: "The grave hound learns the smell of tempered metal. Armor plates blunt its bite.",
            unlocksAt: .kennel
        ),
        LoreEntry(
            id: "mirror",
            title: "Mirror Hall",
            body: "Reflections multiply the bone litter. Count the seals twice before you turn them.",
            unlocksAt: .mirrorHall
        ),
        LoreEntry(
            id: "bridge",
            title: "Ash Bridge",
            body: "Heat rises through the stones. The second hound never leaves the span.",
            unlocksAt: .ashBridge
        ),
        LoreEntry(
            id: "throne",
            title: "Brazier Throne",
            body: "The crowned ember holds the last torch. When it falls, the curse seal can finally turn.",
            unlocksAt: .throne
        ),
        LoreEntry(
            id: "quiet",
            title: "Quiet Cave",
            body: "The gold stays where it belongs. Patrols still wander, but the seals ask for nothing more.",
            unlocksAt: .quiet
        ),
        LoreEntry(
            id: "wraith",
            title: "Coin Wraith",
            body: "Where coins pile deepest, a lapis hood forms. It spends nothing; it only gathers.",
            unlocksAt: .sunLatch
        ),
        LoreEntry(
            id: "serpent",
            title: "Mirror Serpent",
            body: "Each reflection grows a new coil. Break the head, and the copies fade with it.",
            unlocksAt: .mirrorHall
        ),
        LoreEntry(
            id: "golem",
            title: "Ash Golem",
            body: "Rivets hold heat inside dead stone. Ember cracks show where the staff should strike.",
            unlocksAt: .ashBridge
        )
    ]

    static func openingDeck() -> [SpellKind] {
        SpellKind.allCases.flatMap { spell in [spell, spell] }
    }

    static func lore(unlockedBy step: ExpeditionStep) -> [LoreEntry] {
        guard let current = ExpeditionStep.allCases.firstIndex(of: step) else { return [] }
        return lore.filter { entry in
            guard let unlock = ExpeditionStep.allCases.firstIndex(of: entry.unlocksAt) else { return false }
            return unlock <= current
        }
    }
}

struct FightOffer: Identifiable, Equatable {
    let id = UUID()
    var foe: Foe
    var advances: Bool
    var staffRank: Int
    var armorRank: Int
    var playerMax: Int
}
