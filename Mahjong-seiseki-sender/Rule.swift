//
//  Rule.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/10.
//

/**
 * 記録するゲームのルール。
 */
enum Rule: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    // Mリーグ
    /** 赤あり、10-30、オカあり */
    case M_REAGUE = "Mリーグルール"

    // 最高位戦
    // https://saikouisen.com/about/rules/
    /** 赤なし、10-30 */
    case SAIKOUISEN = "最高位戦ルール"
    /** 赤即裏なし、ﾃﾝﾊﾟｲ連ﾃﾝﾊﾟｲ料なし、切り上げ満貫なし、食い変えあり、ﾘｰﾁ後暗槓なし、4-12 */
    case SAIKOUISEN_CLASSIC = "最高位戦Classicルール"

    // 麻雀連盟
    // https://www.ma-jan.or.jp/guide/game_rule.html
    /** 赤即裏なし、4-8 or 1-3-8 */
    case RENMEI = "連盟公式ルール"
    /** 赤なし、10-30 */
    case WRC = "WRCルール"
    /** 赤あり、10-30 */
    case WRC_R = "WRC-Rルール"

    // 協会
    // https://npm2001.com/about/rule/
    /** 赤なし、10-30、オカあり */
    case KYOKAI = "協会ルール"

    // RMU
    // https://rmu.jp/rule
    /** 赤なし、5-15 */
    case RMU_A = "RMU Aルール"
    /** 赤即裏なし、5-15 */
    case RMU_B = "RMU Bルール"
    /** 赤あり、10-30、オカあり */
    case RMU_M = "RMU Mルール"

    // 麻将連合
    // https://mu-mahjong.jp/tournament/%E7%AB%B6%E6%8A%80%E8%A6%8F%E5%AE%9A/
    /** 赤なし、テンパイ料なし、本場なし、4-12 */
    case MU = "ミューリーグ・将王決定戦ルール"
    /** 赤なし、本場なし、4-12 */
    case MU_CUP = "ミューカップルール"
    /** 赤なし、テンパイ料なし、本場なし、4-12 */
    case MU_TOUR = "ツアーランキングルール"
}

