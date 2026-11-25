// Arcana | Card Master
// #ID = 388


// DATA & ADDRESS SETUP===========================================================================================

//Current chapter treasure chest bitflags
CHEST_DATA = range(0x18E3, 0x18E8, 0x1)

function chests_opened() {
    count = 0
    for i in CHEST_DATA {
        count = count + bitcount(i)
    }
    return count
}

function outside_town() => byte(0x1574)
function current_chapter() => byte(0x18cd)
function current_rooks_level() => byte(0x137b)

// Point-of-no-return tiles (bits inside the map bitmaps); 0 in FULLY_EXPLORED
function ch1_no_return() => bit0(0x1793)
function ch2_no_return() => bit1(0x185d)
function ch3_no_return() => bit0(0x1803)

function enemy1_id() => word(0x000657)
function enemy1_hp() => word(0x0012fb)

// MAP EXPLORATION ================================================================================================
// Map exploration bitmaps, one bit per tile, reused by every chapter:
//   map1 $16FF-$177E, map2 $177F-$17FE, map3 $17FF-$187E
// The game keeps no explored-tile counter, so completion is checked against the bitmap itself.
// FULLY_EXPLORED[chapter] lists, per map, each 32-bit word that holds explorable tiles and its value once
// that map is fully explored. Unlisted words hold no explorable tiles. Point-of-no-return tiles are 0 in
// these values, so they never count towards completion and a word holding one only matches while it is unexplored.
// Values are the original exact-value Cartographer logic of each chapter, decoded to bitmaps. Each also matches
// a fully explored save state where one exists, and the per-map tile counts of the previous bitcount logic.
//   Ch1: same bitmap as unofficial 71887                                                292/307
//   Ch2: no-return tile $185D bit 1 is 0                                                106/195/229
//   Ch3: no-return tile $1803 bit 0 is in an unlisted word, so only ch3_no_return()
//        enforces it                                                                    407/321/404
//   Ch4: plus $170E bit 4, which the original logic never checked                       450/507/364
//   Ch5:                                                                                455/229/262
FULLY_EXPLORED = {
    1: [
        {   // map1: 30 words
            0x1703: 0x00000001, 0x1707: 0xF700015F, 0x170B: 0x35000158, 0x170F: 0x35000158,
            0x1713: 0xF500015F, 0x1717: 0x05000141, 0x171B: 0x7D000177, 0x171F: 0x55000154,
            0x1723: 0x55000144, 0x1727: 0xFD00017F, 0x172B: 0x01000101, 0x172F: 0xFD00017D,
            0x1733: 0x05000154, 0x1737: 0xF500017F, 0x173B: 0xF500017F, 0x173F: 0x05000155,
            0x1743: 0x7D00017D, 0x1747: 0x05000101, 0x174B: 0xF50001FF, 0x174F: 0x15000141,
            0x1753: 0x7500015D, 0x1757: 0x75000155, 0x175B: 0x05000151, 0x175F: 0xFD000177,
            0x1763: 0x01000151, 0x1767: 0xFD000155, 0x176B: 0xFD00015D, 0x176F: 0x0D000140,
            0x1773: 0xFD00017F, 0x1777: 0x7D00017D
        },
        {   // map2: 30 words
            0x1783: 0xF000001F, 0x1787: 0x10000011, 0x178B: 0xD0000017, 0x178F: 0x50000014,
            0x1793: 0x50000014, 0x1797: 0xD0000017, 0x179B: 0x10000010, 0x179F: 0xF000001F,
            0x17A3: 0x00000001, 0x17A7: 0x7D54739D, 0x17AB: 0x45545EF5, 0x17AF: 0x5554739D,
            0x17B3: 0x5554739D, 0x17B7: 0x55545EF5, 0x17BB: 0xDFFC739D, 0x17BF: 0x00040004,
            0x17C3: 0xFFFC7FFF, 0x17C7: 0x40004000, 0x17CB: 0x7FFC5FFF, 0x17CF: 0x44445555,
            0x17D3: 0x55545555, 0x17D7: 0x55545D55, 0x17DB: 0x51144155, 0x17DF: 0x7FFC7F75,
            0x17E3: 0x00000001, 0x17E7: 0x00000001, 0x17EB: 0x80000003, 0x17EF: 0x80000002,
            0x17F3: 0x80000003, 0x17F7: 0x00000001
        }
    ],
    2: [
        {   // map1: 14 words
            0x173B: 0x00007FFE, 0x173F: 0x00000202, 0x1743: 0x000072FA, 0x1747: 0x000052AA,
            0x174B: 0x000072AA, 0x174F: 0x000012AA, 0x1753: 0x00007282, 0x1757: 0x000012FE,
            0x175B: 0x00005280, 0x175F: 0x000052BC, 0x1763: 0x000072A4, 0x1767: 0x000072AC,
            0x176B: 0x000052A8, 0x176F: 0x00005EEE
        },
        {   // map2: 14 words
            0x1783: 0xFDE81FFE, 0x1787: 0x81081000, 0x178B: 0xFDE81FFF, 0x178F: 0x81081000,
            0x1793: 0xFDE81FFE, 0x1797: 0x81081000, 0x179B: 0xFDF81FFE, 0x179F: 0x81081000,
            0x17A3: 0xFFE81FFE, 0x17A7: 0x81081000, 0x17AB: 0xFDE81FFE, 0x17AF: 0x810E7000,
            0x17B3: 0xFDE25FFE, 0x17B7: 0x00024000
        },
        {   // map3: 14 words
            0x1843: 0xBCFA4EEF, 0x1847: 0xA8824AAA, 0x184B: 0xECFE7BBB, 0x184F: 0x04800000,
            0x1853: 0xFCB87FFF, 0x1857: 0xFCA87FFF, 0x185B: 0x04AC0088, 0x185F: 0xFCA07AAB,
            0x1863: 0x00BE4AA0, 0x1867: 0x7CA27FFF, 0x186B: 0x10A20005, 0x186F: 0x54A27DD5,
            0x1873: 0x54A21551, 0x1877: 0xFCFE777F
        }
    ],
    3: [
        {   // map1: 30 words
            0x1703: 0x5DF83BB5, 0x1707: 0x75782A17, 0x170B: 0x354823B5, 0x170F: 0x87583EFD,
            0x1713: 0xB1481240, 0x1717: 0xBF7812E7, 0x171B: 0xE27833BD, 0x171F: 0x00002000,
            0x1723: 0x08802A20, 0x1727: 0xFEF82EBF, 0x172B: 0x02083880, 0x172F: 0xD2F82297,
            0x1733: 0x7E882EBD, 0x1737: 0x02A82A80, 0x173B: 0x0AB83AA1, 0x173F: 0xFE8002BF,
            0x1743: 0x00F83A80, 0x1747: 0xFE803ABF, 0x174B: 0x02F03E80, 0x174F: 0x3E1038F8,
            0x1753: 0xA0B83A0A, 0x1757: 0xFFB83BFE, 0x175B: 0x20383808, 0x175F: 0xBF3839FA,
            0x1763: 0xA128390A, 0x1767: 0xFD38397E, 0x176B: 0x01101100, 0x176F: 0x45501544,
            0x1773: 0xFDD0177F, 0x1777: 0x00000001
        },
        {   // map2: 27 words
            0x1787: 0xFFF83FFF, 0x178B: 0x00082000, 0x178F: 0x00282800, 0x1793: 0x00383801,
            0x1797: 0xA010100B, 0x179B: 0xA210108A, 0x179F: 0xAF9013EB, 0x17A3: 0x28901229,
            0x17A7: 0xE010100F, 0x17AB: 0x28F01E29, 0x17AF: 0xAC00006B, 0x17B3: 0xA7B83BCA,
            0x17B7: 0xAC282A6B, 0x17BB: 0x08083E21, 0x17BF: 0x03E83B80, 0x17C3: 0xFFA82BFB,
            0x17C7: 0x00283800, 0x17CB: 0x0E3838E0, 0x17CF: 0xEFA02BEE, 0x17D3: 0xAEB83AEA,
            0x17D7: 0x20082008, 0x17DB: 0x6000200C, 0x17DF: 0x44482444, 0x17E3: 0xEEE82EEE,
            0x17E7: 0xAAB82AAA, 0x17EB: 0xEEE82EEE, 0x17EF: 0x44482444
        },
        {   // map3: 29 words
            0x1807: 0xBF8003FB, 0x180B: 0xA038380A, 0x180F: 0xBE2828FB, 0x1813: 0x20082009,
            0x1817: 0x3BC827B8, 0x181B: 0xE248248F, 0x181F: 0x00E82E01, 0x1823: 0x00482401,
            0x1827: 0xFEE82EFF, 0x182B: 0x0A4824A0, 0x182F: 0x02E82E80, 0x1833: 0xFA4824BF,
            0x1837: 0xFAE82EBF, 0x183B: 0xFA4824BF, 0x183F: 0xFA0820BF, 0x1843: 0xFBE82FBF,
            0x1847: 0x00082008, 0x184B: 0xFFF82FFB, 0x184F: 0x0000200A, 0x1853: 0xFFF83FFB,
            0x1857: 0x00080002, 0x185B: 0xBDE03DFB, 0x185F: 0x1540250A, 0x1863: 0x0500216A,
            0x1867: 0xF5783D2A, 0x186B: 0x9548252A, 0x186F: 0xD5583DEA, 0x1873: 0x1540200A,
            0x1877: 0xFFF83FFB
        }
    ],
    4: [
        {   // map1: 28 words
            0x1703: 0x513C77DC, 0x1707: 0x71E45554, 0x170B: 0x10045554, 0x170F: 0x71C45554,
            0x1713: 0x51545554, 0x1717: 0x505C5454, 0x171B: 0x11445FF4, 0x171F: 0x7F544020,
            0x1723: 0x50547FBC, 0x1727: 0x7F7C1290, 0x172B: 0x010076DC, 0x172F: 0x7D7C4444,
            0x1733: 0x555457D4, 0x1737: 0x45C4755C, 0x1743: 0x7DDC7D7C, 0x1747: 0x45547FFC,
            0x174B: 0x7D546FEC, 0x174F: 0x47747FFC, 0x1753: 0x500457D4, 0x1757: 0x5FFC47C4,
            0x175B: 0x40007EFC, 0x175F: 0x40007EFC, 0x1763: 0x5FFC47C4, 0x1767: 0x500457D4,
            0x176B: 0x47747FFC, 0x176F: 0x7D546FEC, 0x1773: 0x45547FFC, 0x1777: 0x7DDC7D7C
        },
        {   // map2: 28 words
            0x1783: 0x7FFC7D7C, 0x1787: 0x7FFC7D7C, 0x178B: 0x7FFC6DEC, 0x178F: 0x7FFC7D7C,
            0x1793: 0x7FFC5554, 0x1797: 0x7FFC4544, 0x179B: 0x63FC7D7C, 0x179F: 0x6BCC7D7C,
            0x17A3: 0x7BDC4544, 0x17A7: 0x73D45554, 0x17AB: 0x7FC47D7C, 0x17AF: 0x7FFC6F6C,
            0x17B3: 0x7FFC7D7C, 0x17B7: 0x7FFC7D7C, 0x17C3: 0x7FFC783C, 0x17C7: 0x55544824,
            0x17CB: 0x55544824, 0x17CF: 0x7FF44924, 0x17D3: 0x40047BBC, 0x17D7: 0x7FBC4284,
            0x17DB: 0x61207AA4, 0x17DF: 0x090C4AE4, 0x17E3: 0x7BFC4204, 0x17E7: 0x40047BBC,
            0x17EB: 0x5FFC4924, 0x17EF: 0x55544FE4, 0x17F3: 0x55544924, 0x17F7: 0x7FFC7BBC
        },
        {   // map3: 28 words
            0x1803: 0x54540000, 0x1807: 0x55547FFC, 0x180B: 0x7FFC5554, 0x180F: 0x40047FFC,
            0x1813: 0x7EFC5554, 0x1817: 0x022077FC, 0x181B: 0x7EFC5D54, 0x181F: 0x7EFC49FC,
            0x1823: 0x42404154, 0x1827: 0x7EFC7FFC, 0x182B: 0x08085554, 0x182F: 0x7FFC7C7C,
            0x1833: 0x55545554, 0x1837: 0x54547FFC, 0x1843: 0x00007FFC, 0x1847: 0x00006D6C,
            0x184B: 0x00006C6C, 0x184F: 0x00006FEC, 0x1853: 0x0300600C, 0x1857: 0x02007FFC,
            0x185B: 0x03000100, 0x185F: 0x01000100, 0x1863: 0x01007FFC, 0x1867: 0x0180600C,
            0x186B: 0x00806FEC, 0x186F: 0x01806C6C, 0x1873: 0x01006D6C, 0x1877: 0x00007FFC
        }
    ],
    5: [
        {   // map1: 30 words
            0x1703: 0x00000001, 0x1707: 0xBBB83BBB, 0x170B: 0xEEE82AEE, 0x170F: 0xBBB83BBB,
            0x1713: 0x00001110, 0x1717: 0xBBB83BBB, 0x171B: 0xEEE82AAE, 0x171F: 0xBBB83BBB,
            0x1723: 0x01101000, 0x1727: 0xBBB83BBB, 0x172B: 0xAEA82EEE, 0x172F: 0xBBB83BBB,
            0x1733: 0x00100001, 0x1737: 0x00100000, 0x173B: 0x0FFC7FE1, 0x173F: 0x8FFC5FA3,
            0x1743: 0xDBFC5FB6, 0x1747: 0x8FFC5FA3, 0x174B: 0x0FFC7FE1, 0x174F: 0x00000001,
            0x1753: 0x8AAC6EE3, 0x1757: 0xDAA82AA2, 0x175B: 0x8AA82AB6, 0x175F: 0x8FFC7BA3,
            0x1763: 0x00000001, 0x1767: 0x0FFC7FE1, 0x176B: 0x88047FE3, 0x176F: 0xDBFC4036,
            0x1773: 0x88047FE3, 0x1777: 0x0FFC7FE1
        },
        {   // map2: 30 words
            0x1783: 0x00007D3E, 0x1787: 0x000045A0, 0x178B: 0x000044AE, 0x178F: 0x00007CAA,
            0x1793: 0x000040AA, 0x1797: 0x00007EAA, 0x179B: 0x000002AA, 0x179F: 0x00007ABA,
            0x17A3: 0x00007B92, 0x17A7: 0x00006112, 0x17AB: 0x00007F70, 0x17AF: 0x000061C0,
            0x17B3: 0x00006C8E, 0x17B7: 0x000068AA, 0x17BB: 0x00006BBA, 0x17BF: 0x00006A0A,
            0x17C3: 0x00006AEA, 0x17C7: 0x00006A2A, 0x17CB: 0x00006AAA, 0x17CF: 0x00006EBA,
            0x17D3: 0x00006492, 0x17D7: 0x00006596, 0x17DB: 0x00000510, 0x17DF: 0x00007F7C,
            0x17E3: 0x00004144, 0x17E7: 0x00005D44, 0x17EB: 0x000055CE, 0x17EF: 0x0000548A,
            0x17F3: 0x000045EA, 0x17F7: 0x00007D3A
        },
        {   // map3: 27 words
            0x1803: 0x0000701C, 0x1807: 0xE0384384, 0x180B: 0xA1285294, 0x180F: 0x2720721C,
            0x1813: 0xA4382284, 0x1817: 0xA708229C, 0x181B: 0xA1382290, 0x181F: 0xE538339C,
            0x1823: 0xA5381294, 0x1827: 0xA7205294, 0x182B: 0xA4387290, 0x182F: 0x8708121C,
            0x1833: 0xA1283284, 0x1837: 0xE0382380, 0x1847: 0x00380380, 0x184B: 0x00284280,
            0x184F: 0x00387080, 0x1853: 0x00381380, 0x1857: 0x07387200, 0x185B: 0x25384380,
            0x185F: 0xE4385080, 0x1863: 0x84385380, 0x1867: 0xE4387200, 0x186B: 0x24201384,
            0x186F: 0x0438709C, 0x1873: 0x05084290, 0x1877: 0x07000380
        }
    ]
}

// True while every explorable tile of one map is explored (and its no-return tile, if any, is not)
function map_explored(chapter, map) {
    words = FULLY_EXPLORED[chapter][map]
    result = always_true()
    for addr in words {
        result = result && dword(addr) == words[addr]
    }
    return result
}

// Progress: how many of the chapter's maps are fully explored (latched per map)
function maps_explored(chapter) {
    maps = FULLY_EXPLORED[chapter]
    explored = []
    for map in range(0, length(maps) - 1) {
        array_push(explored, once(map_explored(chapter, map)))
    }
    return measured(tally(length(maps), explored))
}

// A tile in one of the chapter's maps was revealed since the last reset, so a save that is
// already fully explored doesn't trigger on load
function tile_revealed(chapter) {
    changed = always_false()
    for words in FULLY_EXPLORED[chapter] {
        for addr in words {
            changed = changed || dword(addr) != prev(dword(addr))
        }
    }
    return once(changed)
}

// ACHIEVEMENTS ==============================================================================================
True = 1
False = 0
achievement(
    title = "Ruins of the Past", points = 10,
    description = "Completely explore both floors of Balnia Temple",
    id = 71970, badge = "73265", published = "2/15/2019 8:26:28 AM", modified = "1/2/2021 3:39:15 AM",
    trigger = unless(current_chapter() != 1) && never(outside_town() == False) && ch1_no_return() == False &&
                maps_explored(1) && tile_revealed(1)
)

achievement(
    title = "Relics of Balnia", points = 5,
    description = "Open every chest in Balnia Temple",
    id = 71971, badge = "630741", published = "2/15/2019 8:26:30 AM", modified = "1/2/2021 3:39:11 AM",
    trigger = measured(chests_opened() == 10, current_chapter() == 1) &&
                prev(chests_opened() == 9)
)

achievement(
    title = "Temple Bestiary", points = 10,
    description = "Encounter every non-boss enemy in Chapter 1 in one session",
    id = 71972, badge = "73271", published = "2/15/2019 8:26:33 AM", modified = "2/15/2019 8:28:39 AM",
    trigger = measured(
                tally(11, 
                    once(word(0x000657) == 24 || word(0x000659) == 24 || word(0x00065B) == 24 || word(0x00065D) == 24 ||
                        word(0x00065F) == 24 || word(0x000661) == 24 || word(0x000663) == 24 || word(0x000665) == 24),
                    once(word(0x000657) == 25 || word(0x000659) == 25 || word(0x00065B) == 25 || word(0x00065D) == 25 ||
                        word(0x00065F) == 25 || word(0x000661) == 25 || word(0x000663) == 25 || word(0x000665) == 25),
                    once(word(0x000657) == 26 || word(0x000659) == 26 || word(0x00065B) == 26 || word(0x00065D) == 26 ||
                        word(0x00065F) == 26 || word(0x000661) == 26 || word(0x000663) == 26 || word(0x000665) == 26),
                    once(word(0x000657) == 27 || word(0x000659) == 27 || word(0x00065B) == 27 || word(0x00065D) == 27 ||
                        word(0x00065F) == 27 || word(0x000661) == 27 || word(0x000663) == 27 || word(0x000665) == 27),
                    once(word(0x000657) == 28 || word(0x000659) == 28 || word(0x00065B) == 28 || word(0x00065D) == 28 ||
                        word(0x00065F) == 28 || word(0x000661) == 28 || word(0x000663) == 28 || word(0x000665) == 28),
                    once(word(0x000657) == 29 || word(0x000659) == 29 || word(0x00065B) == 29 || word(0x00065D) == 29 ||
                        word(0x00065F) == 29 || word(0x000661) == 29 || word(0x000663) == 29 || word(0x000665) == 29),
                    once(word(0x000657) == 30 || word(0x000659) == 30 || word(0x00065B) == 30 || word(0x00065D) == 30 ||
                        word(0x00065F) == 30 || word(0x000661) == 30 || word(0x000663) == 30 || word(0x000665) == 30),
                    once(word(0x000657) == 31 || word(0x000659) == 31 || word(0x00065B) == 31 || word(0x00065D) == 31 ||
                        word(0x00065F) == 31 || word(0x000661) == 31 || word(0x000663) == 31 || word(0x000665) == 31),
                    once(word(0x000657) == 32 || word(0x000659) == 32 || word(0x00065B) == 32 || word(0x00065D) == 32 ||
                        word(0x00065F) == 32 || word(0x000661) == 32 || word(0x000663) == 32 || word(0x000665) == 32),
                    once(word(0x000657) == 33 || word(0x000659) == 33 || word(0x00065B) == 33 || word(0x00065D) == 33 ||
                        word(0x00065F) == 33 || word(0x000661) == 33 || word(0x000663) == 33 || word(0x000665) == 33),
                    once(word(0x000657) == 34 || word(0x000659) == 34 || word(0x00065B) == 34 || word(0x00065D) == 34 ||
                        word(0x00065F) == 34 || word(0x000661) == 34 || word(0x000663) == 34 || word(0x000665) == 34)
                )
            ) && unless(current_chapter() != 1) && never(current_rooks_level() == 0) && word(0x657) != prev(word(0x657))
)

achievement(
    title = "Chiseled in Stone", points = 5, type="progression",
    description = "Defeat the Stone Guardian",
    id = 71973, badge = "73276", published = "2/15/2019 8:26:35 AM", modified = "10/16/2025 1:53:57 AM",
    trigger = current_chapter() == 1 && outside_town() == 1 && prev(bit0(0x0018df)) == 0 && bit0(0x0018df) == 1
)

achievement(
    title = "Rusted Resolve", points = 5, type="progression",
    description = "Defeat the Iron Guardian",
    id = 71974, badge = "73277", published = "2/15/2019 8:26:38 AM", modified = "10/16/2025 1:54:07 AM",
    trigger = current_chapter() == 1 && outside_town() == 1 && prev(bit1(0x0018df)) == 0 && bit1(0x0018df) == 1
)

achievement(
    title = "Novice of the Deck", points = 25,
    description = "Complete Chapter 1 with Rooks at Level 5 or lower",
    id = 71975, badge = "73290", published = "2/15/2019 8:26:41 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 2 && prev(current_chapter()) == 1 && current_rooks_level() <= 5 &&
    current_rooks_level() > 0
)

achievement(
    title = "Through Doubt and Crimson", points = 10,
    description = "Completely explore Draven Pass, Forest of Doubt, and Crimson Valley",
    id = 71976, badge = "73266", published = "2/15/2019 8:26:43 AM", modified = "1/2/2021 3:39:05 AM",
    trigger = unless(current_chapter() != 2) && never(outside_town() == False) && ch2_no_return() == False &&
                maps_explored(2) && tile_revealed(2)
)

achievement(
    title = "Spoils of the Pass", points = 5,
    description = "Open every chest in Draven Pass, Forest of Doubt, and Crimson Valley",
    id = 71977, badge = "630742", published = "2/15/2019 8:26:46 AM", modified = "1/2/2021 3:39:02 AM",
    trigger = measured(chests_opened() == 34, current_chapter() == 2) &&
                prev(chests_opened() == 33)
)

achievement(
    title = "Wilderness Warden", points = 10,
    description = "Encounter every new non-boss enemy in Chapter 2 in one session",
    id = 71978, badge = "73272", published = "2/15/2019 8:26:48 AM", modified = "2/15/2019 8:28:55 AM",
    trigger = measured(
                tally(7, 
                    once(word(0x000657) == 37 || word(0x000659) == 37 || word(0x00065B) == 37 || word(0x00065D) == 37 ||
                        word(0x00065F) == 37 || word(0x000661) == 37 || word(0x000663) == 37 || word(0x000665) == 37),
                    once(word(0x000657) == 38 || word(0x000659) == 38 || word(0x00065B) == 38 || word(0x00065D) == 38 ||
                        word(0x00065F) == 38 || word(0x000661) == 38 || word(0x000663) == 38 || word(0x000665) == 38),
                    once(word(0x000657) == 39 || word(0x000659) == 39 || word(0x00065B) == 39 || word(0x00065D) == 39 ||
                        word(0x00065F) == 39 || word(0x000661) == 39 || word(0x000663) == 39 || word(0x000665) == 39),
                    once(word(0x000657) == 40 || word(0x000659) == 40 || word(0x00065B) == 40 || word(0x00065D) == 40 ||
                        word(0x00065F) == 40 || word(0x000661) == 40 || word(0x000663) == 40 || word(0x000665) == 40),
                    once(word(0x000657) == 41 || word(0x000659) == 41 || word(0x00065B) == 41 || word(0x00065D) == 41 ||
                        word(0x00065F) == 41 || word(0x000661) == 41 || word(0x000663) == 41 || word(0x000665) == 41),
                    once(word(0x000657) == 42 || word(0x000659) == 42 || word(0x00065B) == 42 || word(0x00065D) == 42 ||
                        word(0x00065F) == 42 || word(0x000661) == 42 || word(0x000663) == 42 || word(0x000665) == 42),
                    once(word(0x000657) == 43 || word(0x000659) == 43 || word(0x00065B) == 43 || word(0x00065D) == 43 ||
                        word(0x00065F) == 43 || word(0x000661) == 43 || word(0x000663) == 43 || word(0x000665) == 43)
                )
            ) && unless(current_chapter() != 2) && never(current_rooks_level() == 0) && word(0x657) != prev(word(0x657))
)

achievement(
    title = "One-Eyed Watcher", points = 5, type="progression",
    description = "Defeat the Cyclops",
    id = 71979, badge = "73278", published = "2/15/2019 8:26:51 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && outside_town() == 1 && prev(bit0(0x0018df)) == 0 && bit0(0x0018df) == 1
)

achievement(
    title = "Pact of Flame", points = 5,
    description = "Acquire the Fire Spirit",
    id = 71980, badge = "73279", published = "2/15/2019 8:26:53 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && outside_town() == 1 && bit3(0x0013a7) == 0 && prev(bit3(0x0013a7)) == 1
)

achievement(
    title = "Acolyte's Fall", points = 5, type="progression",
    description = "Defeat Zerel",
    id = 71981, badge = "73280", published = "2/15/2019 8:26:56 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && enemy1_id() == 0x2e && enemy1_hp() == 0 && prev(enemy1_hp()) > 0
)

achievement(
    title = "Apprentice of the Arcana", points = 25,
    description = "Complete Chapter 2 with Rooks at Level 10 or lower",
    id = 71982, badge = "73291", published = "2/15/2019 8:26:59 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 3 && prev(current_chapter()) == 2 && current_rooks_level() <= 10 &&
                current_rooks_level() > 0
)

achievement(
    title = "Permafrost Pioneer", points = 10,
    description = "Completely explore the Ice Mine, Icicle Dungeon, and Polar Dungeon",
    id = 71983, badge = "73267", published = "2/15/2019 8:27:01 AM", modified = "1/2/2021 3:38:58 AM",
    trigger = unless(current_chapter() != 3) && never(outside_town() == False) && ch3_no_return() == False &&
                maps_explored(3) && tile_revealed(3)
)

achievement(
    title = "Frozen Assets", points = 5,
    description = "Open every chest in the Ice Mine, Icicle Dungeon, and Polar Dungeon",
    id = 71984, badge = "630743", published = "2/15/2019 8:27:04 AM", modified = "1/2/2021 3:39:29 AM",
    trigger = measured(chests_opened() == 41, current_chapter() == 3) &&
                prev(chests_opened() == 40)
)

achievement(
    title = "Sub-Zero Safari", points = 10,
    description = "Encounter every new standard enemy in Chapter 3 in one session",
    id = 71985, badge = "73273", published = "2/15/2019 8:27:06 AM", modified = "10/5/2019 11:25:01 AM",
    trigger = measured(
                tally(15, 
                    once(word(0x000657) == 47 || word(0x000659) == 47 || word(0x00065B) == 47 || word(0x00065D) == 47 ||
                        word(0x00065F) == 47 || word(0x000661) == 47 || word(0x000663) == 47 || word(0x000665) == 47),
                    once(word(0x000657) == 48 || word(0x000659) == 48 || word(0x00065B) == 48 || word(0x00065D) == 48 ||
                        word(0x00065F) == 48 || word(0x000661) == 48 || word(0x000663) == 48 || word(0x000665) == 48),
                    once(word(0x000657) == 49 || word(0x000659) == 49 || word(0x00065B) == 49 || word(0x00065D) == 49 ||
                        word(0x00065F) == 49 || word(0x000661) == 49 || word(0x000663) == 49 || word(0x000665) == 49),
                    once(word(0x000657) == 50 || word(0x000659) == 50 || word(0x00065B) == 50 || word(0x00065D) == 50 ||
                        word(0x00065F) == 50 || word(0x000661) == 50 || word(0x000663) == 50 || word(0x000665) == 50),
                    once(word(0x000657) == 51 || word(0x000659) == 51 || word(0x00065B) == 51 || word(0x00065D) == 51 ||
                        word(0x00065F) == 51 || word(0x000661) == 51 || word(0x000663) == 51 || word(0x000665) == 51),
                    once(word(0x000657) == 52 || word(0x000659) == 52 || word(0x00065B) == 52 || word(0x00065D) == 52 ||
                        word(0x00065F) == 52 || word(0x000661) == 52 || word(0x000663) == 52 || word(0x000665) == 52),
                    once(word(0x000657) == 53 || word(0x000659) == 53 || word(0x00065B) == 53 || word(0x00065D) == 53 ||
                        word(0x00065F) == 53 || word(0x000661) == 53 || word(0x000663) == 53 || word(0x000665) == 53),
                    once(word(0x000657) == 54 || word(0x000659) == 54 || word(0x00065B) == 54 || word(0x00065D) == 54 ||
                        word(0x00065F) == 54 || word(0x000661) == 54 || word(0x000663) == 54 || word(0x000665) == 54),
                    once(word(0x000657) == 55 || word(0x000659) == 55 || word(0x00065B) == 55 || word(0x00065D) == 55 ||
                        word(0x00065F) == 55 || word(0x000661) == 55 || word(0x000663) == 55 || word(0x000665) == 55),
                    once(word(0x000657) == 56 || word(0x000659) == 56 || word(0x00065B) == 56 || word(0x00065D) == 56 ||
                        word(0x00065F) == 56 || word(0x000661) == 56 || word(0x000663) == 56 || word(0x000665) == 56),
                    once(word(0x000657) == 57 || word(0x000659) == 57 || word(0x00065B) == 57 || word(0x00065D) == 57 ||
                        word(0x00065F) == 57 || word(0x000661) == 57 || word(0x000663) == 57 || word(0x000665) == 57),
                    once(word(0x000657) == 58 || word(0x000659) == 58 || word(0x00065B) == 58 || word(0x00065D) == 58 ||
                        word(0x00065F) == 58 || word(0x000661) == 58 || word(0x000663) == 58 || word(0x000665) == 58),
                    once(word(0x000657) == 59 || word(0x000659) == 59 || word(0x00065B) == 59 || word(0x00065D) == 59 ||
                        word(0x00065F) == 59 || word(0x000661) == 59 || word(0x000663) == 59 || word(0x000665) == 59),
                    once(word(0x000657) == 60 || word(0x000659) == 60 || word(0x00065B) == 60 || word(0x00065D) == 60 ||
                        word(0x00065F) == 60 || word(0x000661) == 60 || word(0x000663) == 60 || word(0x000665) == 60),
                    once(word(0x000657) == 61 || word(0x000659) == 61 || word(0x00065B) == 61 || word(0x00065D) == 61 ||
                        word(0x00065F) == 61 || word(0x000661) == 61 || word(0x000663) == 61 || word(0x000665) == 61)
                )
            ) && unless(current_chapter() != 3) && never(current_rooks_level() == 0) && word(0x657) != prev(word(0x657))
)

achievement(
    title = "Blessing of the Tides", points = 5,
    description = "Acquire the Water Spirit",
    id = 71986, badge = "73281", published = "2/15/2019 8:27:09 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 3 && outside_town() == 1 && bit2(0x0013a7) == 0 && prev(bit2(0x0013a7)) == 1
)

achievement(
    title = "Zealot's End", points = 5, type="progression",
    description = "Defeat Sauza",
    id = 71987, badge = "73282", published = "2/15/2019 8:27:12 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 3 && enemy1_id() == 0x40 && enemy1_hp() == 0 && prev(enemy1_hp()) > 0
)

achievement(
    title = "Adept of the Elements", points = 25,
    description = "Complete Chapter 3 with Rooks at Level 15 or lower",
    id = 71988, badge = "73292", published = "2/15/2019 8:27:14 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 4 && prev(current_chapter()) == 3 && current_rooks_level() <= 15 &&
                current_rooks_level() > 0
)

achievement(
    title = "Scaling the Spire", points = 10,
    description = "Completely explore floors 1-4, 5-8,and 9-12 of the Stavery Tower in Chapter 4",
    id = 71989, badge = "73268", published = "2/15/2019 8:27:16 AM", modified = "1/2/2021 3:39:38 AM",
    trigger = unless(current_chapter() != 4) && never(outside_town() == False) &&
                maps_explored(4) && tile_revealed(4)
)

// Ticket 17482: I'm sure I opened ever treasure chest in Chapter 4 but no cheev yet for this. IF the 11th and 12
//               floors have no chests then I opened them all.
achievement(
    title = "Tower Plunderer", points = 5,
    description = "Open every chest in Stavery Tower",
    id = 71990, badge = "630744", published = "2/15/2019 8:27:19 AM", modified = "1/2/2021 3:39:34 AM",
    trigger = measured(chests_opened() == 25, current_chapter() == 4) &&
                prev(chests_opened() == 24)
)

achievement(
    title = "Menagerie of the Spire", points = 10,
    description = "Encounter every new standard enemy in Chapter 4 in one session",
    id = 71991, badge = "73274", published = "2/15/2019 8:27:21 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = measured(
                tally(15, 
                    once(word(0x000657) == 65 || word(0x000659) == 65 || word(0x00065B) == 65 || word(0x00065D) == 65 ||
                        word(0x00065F) == 65 || word(0x000661) == 65 || word(0x000663) == 65 || word(0x000665) == 65),
                    once(word(0x000657) == 66 || word(0x000659) == 66 || word(0x00065B) == 66 || word(0x00065D) == 66 ||
                        word(0x00065F) == 66 || word(0x000661) == 66 || word(0x000663) == 66 || word(0x000665) == 66),
                    once(word(0x000657) == 67 || word(0x000659) == 67 || word(0x00065B) == 67 || word(0x00065D) == 67 ||
                        word(0x00065F) == 67 || word(0x000661) == 67 || word(0x000663) == 67 || word(0x000665) == 67),
                    once(word(0x000657) == 68 || word(0x000659) == 68 || word(0x00065B) == 68 || word(0x00065D) == 68 ||
                        word(0x00065F) == 68 || word(0x000661) == 68 || word(0x000663) == 68 || word(0x000665) == 68),
                    once(word(0x000657) == 69 || word(0x000659) == 69 || word(0x00065B) == 69 || word(0x00065D) == 69 ||
                        word(0x00065F) == 69 || word(0x000661) == 69 || word(0x000663) == 69 || word(0x000665) == 69),
                    once(word(0x000657) == 70 || word(0x000659) == 70 || word(0x00065B) == 70 || word(0x00065D) == 70 ||
                        word(0x00065F) == 70 || word(0x000661) == 70 || word(0x000663) == 70 || word(0x000665) == 70),
                    once(word(0x000657) == 71 || word(0x000659) == 71 || word(0x00065B) == 71 || word(0x00065D) == 71 ||
                        word(0x00065F) == 71 || word(0x000661) == 71 || word(0x000663) == 71 || word(0x000665) == 71),
                    once(word(0x000657) == 72 || word(0x000659) == 72 || word(0x00065B) == 72 || word(0x00065D) == 72 ||
                        word(0x00065F) == 72 || word(0x000661) == 72 || word(0x000663) == 72 || word(0x000665) == 72),
                    once(word(0x000657) == 73 || word(0x000659) == 73 || word(0x00065B) == 73 || word(0x00065D) == 73 ||
                        word(0x00065F) == 73 || word(0x000661) == 73 || word(0x000663) == 73 || word(0x000665) == 73),
                    once(word(0x000657) == 74 || word(0x000659) == 74 || word(0x00065B) == 74 || word(0x00065D) == 74 ||
                        word(0x00065F) == 74 || word(0x000661) == 74 || word(0x000663) == 74 || word(0x000665) == 74),
                    once(word(0x000657) == 75 || word(0x000659) == 75 || word(0x00065B) == 75 || word(0x00065D) == 75 ||
                        word(0x00065F) == 75 || word(0x000661) == 75 || word(0x000663) == 75 || word(0x000665) == 75),
                    once(word(0x000657) == 76 || word(0x000659) == 76 || word(0x00065B) == 76 || word(0x00065D) == 76 ||
                        word(0x00065F) == 76 || word(0x000661) == 76 || word(0x000663) == 76 || word(0x000665) == 76),
                    once(word(0x000657) == 77 || word(0x000659) == 77 || word(0x00065B) == 77 || word(0x00065D) == 77 ||
                        word(0x00065F) == 77 || word(0x000661) == 77 || word(0x000663) == 77 || word(0x000665) == 77),
                    once(word(0x000657) == 78 || word(0x000659) == 78 || word(0x00065B) == 78 || word(0x00065D) == 78 ||
                        word(0x00065F) == 78 || word(0x000661) == 78 || word(0x000663) == 78 || word(0x000665) == 78),
                    once(word(0x000657) == 79 || word(0x000659) == 79 || word(0x00065B) == 79 || word(0x00065D) == 79 ||
                        word(0x00065F) == 79 || word(0x000661) == 79 || word(0x000663) == 79 || word(0x000665) == 79)
                )
            ) && unless(current_chapter() != 4) && never(current_rooks_level() == 0) && word(0x657) != prev(word(0x657))
)

achievement(
    title = "Strength of Stone", points = 5,
    description = "Acquire the Earth Spirit",
    id = 71992, badge = "73283", published = "2/15/2019 8:27:23 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = current_chapter() == 4 && outside_town() == 1 && bit1(0x0013A7) == 0 && prev(bit1(0x0013A7)) == 1
)

// Ticket 34466: Triggers at beginning of battle.
// Ticket 19718: Relatively minor issue but this triggered at the start of the battle instead of being awarded for
//               winning.
// Ticket 17453: I beat Darah in floor 1 of Chatper 4 and Summoned Evil popped. It's not supposed to yet is it?
achievement(
    title = "Twin Terrors", points = 5, type="progression",
    description = "Defeat Darah and Barah",
    id = 71993, badge = "73284", published = "2/15/2019 8:27:26 AM", modified = "12/12/2021 1:47:39 PM",
    trigger = current_chapter() == 4 &&
              __ornext(prev(enemy1_id()) == 80 || prev(enemy1_id()) == 81 || prev(word(0x000659)) == 80 || prev(word(0x000659)) == 81) &&
              enemy1_hp() == 0 && word(0x0012FD) == 0 && __ornext(prev(enemy1_hp()) > 0 || prev(word(0x0012FD)) > 0)
)

achievement(
    title = "A Broken Oath", points = 5, type="progression",
    description = "Defeat Galneon's pawn on the seventh floor of Stavery Tower",
    id = 71994, badge = "73295", published = "2/15/2019 8:27:28 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = current_chapter() == 4 && enemy1_hp() == 0 && prev(enemy1_hp()) > 0 && enemy1_id() == 82
)

achievement(
    title = "Shattered Trance", points = 5, type="progression",
    description = "Defeat Galneon's pawn on the eleventh floor of Stavery Tower",
    id = 71995, badge = "73296", published = "2/15/2019 8:27:30 AM", modified = "2/15/2019 8:29:41 AM",
    trigger = current_chapter() == 4 && enemy1_hp() == 0 && prev(enemy1_hp()) != 0 && enemy1_id() == 83
)

achievement(
    title = "Sovereign of the Cards", points = 25,
    description = "Complete Chapter 4 with Rooks at Level 20 or lower",
    id = 71996, badge = "73293", published = "2/15/2019 8:27:33 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_rooks_level() < 21 && current_rooks_level() > 0 && prev(current_chapter()) == 4 && current_chapter() == 5
)

achievement(
    title = "Reclaiming the Realm", points = 10,
    description = "Completely explore Bintel Castle, the Tunnel, and Stavery Tower in Chapter 5",
    id = 71997, badge = "73269", published = "2/15/2019 8:27:36 AM", modified = "1/2/2021 3:39:25 AM",
    trigger = unless(current_chapter() != 5) && never(outside_town() == False) &&
                maps_explored(5) && tile_revealed(5)
)

achievement(
    title = "Royal Hoard", points = 5,
    description = "Open every chest in Bintel Castle, the Tunnel, and Stavery Tower",
    id = 71998, badge = "630745", published = "2/15/2019 8:27:38 AM", modified = "1/2/2021 3:39:22 AM",
    trigger = measured(chests_opened() == 23, current_chapter() == 5) &&
                prev(chests_opened() == 22)
)

achievement(
    title = "Lexicon of Elemen", points = 10,
    description = "Encounter every new standard enemy in Chapter 5 in one session",
    id = 71999, badge = "73275", published = "2/15/2019 8:27:41 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = measured(
                tally(15, 
                    once(word(0x000657) == 84 || word(0x000659) == 84 || word(0x00065B) == 84 || word(0x00065D) == 84 ||
                        word(0x00065F) == 84 || word(0x000661) == 84 || word(0x000663) == 84 || word(0x000665) == 84),
                    once(word(0x000657) == 85 || word(0x000659) == 85 || word(0x00065B) == 85 || word(0x00065D) == 85 ||
                        word(0x00065F) == 85 || word(0x000661) == 85 || word(0x000663) == 85 || word(0x000665) == 85),
                    once(word(0x000657) == 86 || word(0x000659) == 86 || word(0x00065B) == 86 || word(0x00065D) == 86 ||
                        word(0x00065F) == 86 || word(0x000661) == 86 || word(0x000663) == 86 || word(0x000665) == 86),
                    once(word(0x000657) == 87 || word(0x000659) == 87 || word(0x00065B) == 87 || word(0x00065D) == 87 ||
                        word(0x00065F) == 87 || word(0x000661) == 87 || word(0x000663) == 87 || word(0x000665) == 87),
                    once(word(0x000657) == 88 || word(0x000659) == 88 || word(0x00065B) == 88 || word(0x00065D) == 88 ||
                        word(0x00065F) == 88 || word(0x000661) == 88 || word(0x000663) == 88 || word(0x000665) == 88),
                    once(word(0x000657) == 89 || word(0x000659) == 89 || word(0x00065B) == 89 || word(0x00065D) == 89 ||
                        word(0x00065F) == 89 || word(0x000661) == 89 || word(0x000663) == 89 || word(0x000665) == 89),
                    once(word(0x000657) == 90 || word(0x000659) == 90 || word(0x00065B) == 90 || word(0x00065D) == 90 ||
                        word(0x00065F) == 90 || word(0x000661) == 90 || word(0x000663) == 90 || word(0x000665) == 90),
                    once(word(0x000657) == 91 || word(0x000659) == 91 || word(0x00065B) == 91 || word(0x00065D) == 91 ||
                        word(0x00065F) == 91 || word(0x000661) == 91 || word(0x000663) == 91 || word(0x000665) == 91),
                    once(word(0x000657) == 92 || word(0x000659) == 92 || word(0x00065B) == 92 || word(0x00065D) == 92 ||
                        word(0x00065F) == 92 || word(0x000661) == 92 || word(0x000663) == 92 || word(0x000665) == 92),
                    once(word(0x000657) == 93 || word(0x000659) == 93 || word(0x00065B) == 93 || word(0x00065D) == 93 ||
                        word(0x00065F) == 93 || word(0x000661) == 93 || word(0x000663) == 93 || word(0x000665) == 93),
                    once(word(0x000657) == 94 || word(0x000659) == 94 || word(0x00065B) == 94 || word(0x00065D) == 94 ||
                        word(0x00065F) == 94 || word(0x000661) == 94 || word(0x000663) == 94 || word(0x000665) == 94),
                    once(word(0x000657) == 95 || word(0x000659) == 95 || word(0x00065B) == 95 || word(0x00065D) == 95 ||
                        word(0x00065F) == 95 || word(0x000661) == 95 || word(0x000663) == 95 || word(0x000665) == 95),
                    once(word(0x000657) == 96 || word(0x000659) == 96 || word(0x00065B) == 96 || word(0x00065D) == 96 ||
                        word(0x00065F) == 96 || word(0x000661) == 96 || word(0x000663) == 96 || word(0x000665) == 96),
                    once(word(0x000657) == 97 || word(0x000659) == 97 || word(0x00065B) == 97 || word(0x00065D) == 97 ||
                        word(0x00065F) == 97 || word(0x000661) == 97 || word(0x000663) == 97 || word(0x000665) == 97),
                    once(word(0x000657) == 98 || word(0x000659) == 98 || word(0x00065B) == 98 || word(0x00065D) == 98 ||
                        word(0x00065F) == 98 || word(0x000661) == 98 || word(0x000663) == 98 || word(0x000665) == 98)
                )
            ) && unless(current_chapter() != 5) && never(current_rooks_level() == 0) && word(0x657) != prev(word(0x657))
)

achievement(
    title = "The General's Stand", points = 5, type="progression",
    description = "Defeat Karul",
    id = 72000, badge = "73287", published = "2/15/2019 8:27:44 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = current_chapter() == 5 && enemy1_hp() == 0 && prev(enemy1_hp()) != 0 && enemy1_id() == 99
)

achievement(
    title = "Fall of the False King", points = 5, type="progression",
    description = "Defeat Galneon",
    id = 72001, badge = "73288", published = "2/15/2019 8:27:47 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = current_chapter() == 5 && enemy1_hp() == 0 && prev(enemy1_hp()) != 0 && enemy1_id() == 101
)

achievement(
    title = "Hero of Elemen", points = 10, type="win_condition",
    description = "Complete Chapter 5",
    id = 72002, badge = "73289", published = "2/15/2019 8:27:49 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = current_chapter() == 5 && enemy1_hp() == 0 && prev(enemy1_hp()) != 0 && enemy1_id() == 103
)

achievement(
    title = "True Card Master", points = 50,
    description = "Complete Chapter 5 with Rooks at Level 25 or lower",
    id = 72003, badge = "73294", published = "2/15/2019 8:27:52 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_rooks_level() < 26 && current_chapter() == 5 && prev(enemy1_hp()) != 0 && enemy1_hp() == 0 && enemy1_id() == 103
)

achievement(
    title = "Lower Guardian", points = 5,
    description = "Defeat the Stone Guardian",
    id = 71822, badge = "00000", published = "2/11/2019 9:47:48 AM", modified = "2/12/2019 8:16:05 AM",
    trigger = byte(0x0018CD) == 1 && byte(0x0018DF) == 1 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 393231)
)

achievement(
    title = "Upper Guardian", points = 5,
    description = "Defeat the Iron Guardian",
    id = 71823, badge = "00000", published = "2/11/2019 10:26:55 AM", modified = "2/12/2019 8:24:12 AM",
    trigger = byte(0x0018CD) == 1 && byte(0x0018DF) == 3 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 589839)
)

achievement(
    title = "Forest Protector", points = 5,
    description = "Defeat the Cyclops",
    id = 71846, badge = "00000", published = "2/11/2019 7:39:55 PM", modified = "2/12/2019 8:18:53 AM",
    trigger = byte(0x0018CD) == 2 && byte(0x0018DF) == 1 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 1572872)
)

achievement(
    title = "Fire Spirit", points = 5,
    description = "Acquire the Fire Spirit",
    id = 71858, badge = "00000", published = "2/11/2019 10:41:38 PM", modified = "2/12/2019 8:20:12 AM",
    trigger = byte(0x0018CD) == 2 && bit3(0x0013A7) == 0 && once(bit3(0x0013A7) != prev(bit3(0x0013A7))) &&
              unless(dword(0x0016F7) != 786461)
)

achievement(
    title = "Cartographer I", points = 10,
    description = "Completely explore Balnia Temple (Chapter 1)",
    id = 71887, badge = "00000", published = "2/13/2019 6:21:04 AM", modified = "2/14/2019 9:46:02 PM",
    trigger = byte(0x001703) == 1 && word(0x001707) == 351 && byte(0x00170A) == 247 && dword(0x00170B) == 889192792 &&
              dword(0x00170F) == dword(0x00170B) && word(0x001713) == 351 && byte(0x001716) == 245 &&
              dword(0x001717) == 83886401 && dword(0x00171B) == 2097152375 && dword(0x00171F) == 1426063700 &&
              dword(0x001723) == 1426063684 && word(0x001727) == 383 && byte(0x00172A) == 253 &&
              dword(0x00172B) == 16777473 && word(0x00172F) == 381 && byte(0x001732) == 253 &&
              dword(0x001733) == 83886420 && word(0x001737) == 383 && byte(0x00173A) == 245 && word(0x00173B) == 383 &&
              byte(0x00173E) == 245 && dword(0x00173F) == 83886421 && dword(0x001743) == 2097152381 &&
              dword(0x001747) == 83886337 && word(0x00174B) == 511 && byte(0x00174E) == 245 &&
              dword(0x00174F) == 352321857 && dword(0x001753) == 1962934621 && dword(0x001757) == 1962934613 &&
              dword(0x00175B) == 83886417 && word(0x00175F) == 375 && byte(0x001762) == 253 &&
              dword(0x001763) == 16777553 && word(0x001767) == 341 && byte(0x00176A) == 253 && word(0x00176B) == 349 &&
              byte(0x00176E) == 253 && dword(0x00176F) == 218104128 && word(0x001773) == 383 && byte(0x001776) == 253 &&
              dword(0x001777) == dword(0x001743) && byte(0x001783) == 31 && byte(0x001786) == 240 &&
              dword(0x001787) == 268435473 && byte(0x00178B) == 23 && byte(0x00178E) == 208 &&
              dword(0x00178F) == 1342177300 && dword(0x001793) == dword(0x00178F) && byte(0x001797) == 23 &&
              byte(0x00179A) == 208 && dword(0x00179B) == 268435472 && byte(0x00179F) == 31 && byte(0x0017A2) == 240 &&
              byte(0x0017A3) == 1 && dword(0x0017A7) == 2102686621 && dword(0x0017AB) == 1163157237 &&
              dword(0x0017AF) == 1431597981 && dword(0x0017B3) == dword(0x0017AF) && dword(0x0017B7) == 1431592693 &&
              word(0x0017BB) == 29597 && word(0x0017BD) == 57340 && dword(0x0017BF) == 262148 && word(0x0017C3) == 32767 &&
              word(0x0017C5) == 65532 && dword(0x0017C7) == 1073758208 && dword(0x0017CB) == 2147246079 &&
              dword(0x0017CF) == 1145328981 && dword(0x0017D3) == 1431590229 && dword(0x0017D7) == 1431592277 &&
              dword(0x0017DB) == 1360281941 && dword(0x0017DF) == 2147254133 && byte(0x0017E3) == 1 &&
              byte(0x0017E7) == 1 && byte(0x0017EB) == 3 && byte(0x0017EE) == 128 && byte(0x0017EF) == 2 &&
              byte(0x0017F2) == 128 && byte(0x0017F3) == 3 && byte(0x0017F6) == 128 && byte(0x0017F7) == 1 &&
              bit0(0x001793) == 0 &&
              (always_false() || (tally(1, byte(0x001703) != prev(byte(0x001703)), word(0x001707) != prev(word(0x001707)),
                    byte(0x00170A) != prev(byte(0x00170A)), dword(0x00170B) != prev(dword(0x00170B)),
                    dword(0x00170F) != prev(dword(0x00170F)), word(0x001713) != prev(word(0x001713)),
                    byte(0x001716) != prev(byte(0x001716)), dword(0x001717) != prev(dword(0x001717)),
                    dword(0x00171B) != prev(dword(0x00171B)), dword(0x00171F) != prev(dword(0x00171F)),
                    dword(0x001723) != prev(dword(0x001723)), word(0x001727) != prev(word(0x001727)),
                    byte(0x00172A) != prev(byte(0x00172A)), dword(0x00172B) != prev(dword(0x00172B)),
                    word(0x00172F) != prev(word(0x00172F)), byte(0x001732) != prev(byte(0x001732)),
                    dword(0x001733) != prev(dword(0x001733)), word(0x001737) != prev(word(0x001737)),
                    byte(0x00173A) != prev(byte(0x00173A)), word(0x00173B) != prev(word(0x00173B)),
                    byte(0x00173E) != prev(byte(0x00173E)), dword(0x00173F) != prev(dword(0x00173F)),
                    dword(0x001743) != prev(dword(0x001743)), dword(0x001747) != prev(dword(0x001747)),
                    word(0x00174B) != prev(word(0x00174B)), byte(0x00174E) != prev(byte(0x00174E)),
                    dword(0x00174F) != prev(dword(0x00174F)), dword(0x001753) != prev(dword(0x001753)),
                    dword(0x001757) != prev(dword(0x001757)), dword(0x00175B) != prev(dword(0x00175B)),
                    word(0x00175F) != prev(word(0x00175F)), byte(0x001762) != prev(byte(0x001762)),
                    dword(0x001763) != prev(dword(0x001763)), word(0x001767) != prev(word(0x001767)),
                    byte(0x00176A) != prev(byte(0x00176A)), word(0x00176B) != prev(word(0x00176B)),
                    byte(0x00176E) != prev(byte(0x00176E)), dword(0x00176F) != prev(dword(0x00176F)),
                    word(0x001773) != prev(word(0x001773)), byte(0x001776) != prev(byte(0x001776)),
                    dword(0x001777) != prev(dword(0x001777)), byte(0x001783) != prev(byte(0x001783)),
                    byte(0x001786) != prev(byte(0x001786)), dword(0x001787) != prev(dword(0x001787)),
                    byte(0x00178B) != prev(byte(0x00178B)), byte(0x00178E) != prev(byte(0x00178E)),
                    dword(0x00178F) != prev(dword(0x00178F)), dword(0x001793) != prev(dword(0x001793)),
                    byte(0x001797) != prev(byte(0x001797)), byte(0x00179A) != prev(byte(0x00179A)),
                    dword(0x00179B) != prev(dword(0x00179B)), byte(0x00179F) != prev(byte(0x00179F)),
                    byte(0x0017A2) != prev(byte(0x0017A2)), byte(0x0017A3) != prev(byte(0x0017A3)),
                    dword(0x0017A7) != prev(dword(0x0017A7)), dword(0x0017AB) != prev(dword(0x0017AB)),
                    dword(0x0017AF) != prev(dword(0x0017AF)), dword(0x0017B3) != prev(dword(0x0017B3)),
                    dword(0x0017B7) != prev(dword(0x0017B7)), word(0x0017BB) != prev(word(0x0017BB)),
                    word(0x0017BD) != prev(word(0x0017BD)), dword(0x0017BF) != prev(dword(0x0017BF)),
                    word(0x0017C3) != prev(word(0x0017C3)), word(0x0017C5) != prev(word(0x0017C5)),
                    dword(0x0017C7) != prev(dword(0x0017C7)), dword(0x0017CB) != prev(dword(0x0017CB)),
                    dword(0x0017CF) != prev(dword(0x0017CF)), dword(0x0017D3) != prev(dword(0x0017D3)),
                    dword(0x0017D7) != prev(dword(0x0017D7)), dword(0x0017DB) != prev(dword(0x0017DB)),
                    dword(0x0017DF) != prev(dword(0x0017DF)), byte(0x0017E3) != prev(byte(0x0017E3)),
                    byte(0x0017E7) != prev(byte(0x0017E7)), byte(0x0017EB) != prev(byte(0x0017EB)),
                    byte(0x0017EE) != prev(byte(0x0017EE)), byte(0x0017EF) != prev(byte(0x0017EF)),
                    byte(0x0017F2) != prev(byte(0x0017F2)), byte(0x0017F3) != prev(byte(0x0017F3)),
                    byte(0x0017F6) != prev(byte(0x0017F6)), byte(0x0017F7) != prev(byte(0x0017F7))
                ) && never(byte(0x001064) != 75)))
)
