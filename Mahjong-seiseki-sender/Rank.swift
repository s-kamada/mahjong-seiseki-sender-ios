//
//  Rank.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/10.
//

import Foundation

enum Rank: Int, CaseIterable, Identifiable {
    case first = 1
    case second = 2
    case third = 3
    case forth = 4

    var id: Int { rawValue }
}
