// Arcana | Card Master
// #ID = 388


// DATA & ADDRESS SETUP===========================================================================================

//Current chapter map exploration bitflags 
MAP_DATA = {
    "map1": range(0x16FF, 0x177E, 0x1),
    "map2": range(0x177F, 0x17FE, 0x1),
    "map3": range(0x17FF, 0x187E, 0x1)
}

//Current chapter treasure chest bitflags
CHEST_DATA = range(0x18E3, 0x18E8, 0x1)

function tiles_explored(map_number) {
    count = 0
    for i in MAP_DATA[map_number] {
        count = count + bitcount(i)
    }
    return count
}

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

// Map tiles unable to be explored without triggering point of no return, do not count in cheevo bitcount total
function ch1_no_return() => bit0(0x1793)
function ch2_no_return() => bit1(0x185d)
function ch3_no_return() => bit0(0x1803)

function enemy1_id() => word(0x000657)
function enemy1_hp() => word(0x0012fb)

// ACHIEVEMENTS ==============================================================================================
True = 1
False = 0
achievement(
    title = "Cartographer I", points = 10,
    description = "Fully explore both floors of Balnia Temple",
    id = 71970, badge = "73265", published = "2/15/2019 8:26:28 AM", modified = "1/2/2021 3:39:15 AM",
    trigger = unless(current_chapter() != 1) && never(outside_town() == False) && ch1_no_return() == False &&
                measured(
                    tally(2,
                        once(tiles_explored("map1") == 292),
                        once(tiles_explored("map2") == 307)
                    )
                ) && 
                prev(tiles_explored("map1") + tiles_explored("map2") == 598)
)

achievement(
    title = "Treasure Hunter I", points = 5,
    description = "Open every chest in Balnia Temple",
    id = 71971, badge = "73270", published = "2/15/2019 8:26:30 AM", modified = "1/2/2021 3:39:11 AM",
    trigger = measured(chests_opened() == 10, current_chapter() == 1) &&
                prev(chests_opened() == 9)
)

achievement(
    title = "Monster Hunter I", points = 10,
    description = "Encounter every normal enemy in Balnia Temple in a single session",
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
    title = "Lower Guardian", points = 5, type="progression",
    description = "Defeat the Stone Guardian",
    id = 71973, badge = "73276", published = "2/15/2019 8:26:35 AM", modified = "10/16/2025 1:53:57 AM",
    trigger = current_chapter() == 1 && outside_town() == 1 && bit0(0x0018df) == 0 && prev(bit0(0x0018df)) == 1
)

achievement(
    title = "Upper Guardian", points = 5, type="progression",
    description = "Defeat the Iron Guardian",
    id = 71974, badge = "73277", published = "2/15/2019 8:26:38 AM", modified = "10/16/2025 1:54:07 AM",
    trigger = current_chapter() == 1 && outside_town() == 1 && bit1(0x0018df) == 0 && prev(bit1(0x0018df)) == 1
)

achievement(
    title = "Card Master I", points = 25,
    description = "Complete Chapter 1 with Rooks at Level 5 or lower",
    id = 71975, badge = "73290", published = "2/15/2019 8:26:41 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 2 && prev(current_chapter()) == 1 && current_rooks_level() <= 5 &&
    current_rooks_level() > 0
)

achievement(
    title = "Cartographer II", points = 10,
    description = "Completely explore the Draven Pass, Forest of Doubt, and Crimson Valley",
    id = 71976, badge = "73266", published = "2/15/2019 8:26:43 AM", modified = "1/2/2021 3:39:05 AM",
    trigger = unless(current_chapter() != 2) && never(outside_town() == False) && ch2_no_return() == False &&
                measured(
                    tally(3,
                        once(tiles_explored("map1") == 106),
                        once(tiles_explored("map2") == 195),
                        once(tiles_explored("map3") == 229)
                    )
                ) && 
                prev(tiles_explored("map1") + tiles_explored("map2") + tiles_explored("map3") == 529)
)

achievement(
    title = "Treasure Hunter II", points = 5,
    description = "Open every chest in the Draven Pass, Forest of Doubt, and Crimson Valley (Chapter 2)",
    id = 71977, badge = "73270", published = "2/15/2019 8:26:46 AM", modified = "1/2/2021 3:39:02 AM",
    trigger = measured(chests_opened() == 34, current_chapter() == 2) &&
                prev(chests_opened() == 33)
)

achievement(
    title = "Monster Hunter II", points = 10,
    description = "Encounter every new enemy in Chapter 2",
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
    title = "Forest Protector", points = 5, type="progression",
    description = "Defeat the Cyclops",
    id = 71979, badge = "73278", published = "2/15/2019 8:26:51 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && outside_town() == 1 && bit0(0x0018df) == 0 && prev(bit0(0x0018df)) == 1
)

achievement(
    title = "Fire Spirit", points = 5,
    description = "Acquire the Fire Spirit",
    id = 71980, badge = "73279", published = "2/15/2019 8:26:53 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && outside_town() == 1 && bit3(0x0013a7) == 0 && prev(bit3(0x0013a7)) == 1
)

achievement(
    title = "First Apprentice", points = 5, type="progression",
    description = "Defeat Zerel",
    id = 71981, badge = "73280", published = "2/15/2019 8:26:56 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 2 && enemy1_id() == 0x2e && enemy1_hp() == 0 && prev(enemy1_hp()) > 0
)

achievement(
    title = "Card Master II", points = 25,
    description = "Complete Chapter 2 with Rooks at Level 10 or lower",
    id = 71982, badge = "73291", published = "2/15/2019 8:26:59 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 3 && prev(current_chapter()) == 2 && current_rooks_level() <= 10 &&
                current_rooks_level() > 0
)

achievement(
    title = "Cartographer III", points = 10,
    description = "Completely explore the Ice Mine, Icicle Dungeon, and Polar Dungeon",
    id = 71983, badge = "73267", published = "2/15/2019 8:27:01 AM", modified = "1/2/2021 3:38:58 AM",
    trigger = unless(current_chapter() != 3) && never(outside_town() == False) && ch3_no_return() == False &&
                measured(
                    tally(3,
                        once(tiles_explored("map1") == 407),
                        once(tiles_explored("map2") == 321),
                        once(tiles_explored("map3") == 404)
                    )
                ) && 
                prev(tiles_explored("map1") + tiles_explored("map2") + tiles_explored("map3") == 1131)
)

achievement(
    title = "Treasure Hunter III", points = 5,
    description = "Open every chest in the Ice Mine, Icicle Dungeon, and Polar Dungeon",
    id = 71984, badge = "73270", published = "2/15/2019 8:27:04 AM", modified = "1/2/2021 3:39:29 AM",
    trigger = measured(chests_opened() == 45, current_chapter() == 3) &&
                prev(chests_opened() == 44)
)

achievement(
    title = "Monster Hunter III", points = 10,
    description = "Encounter every new enemy in Chapter 3",
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
    title = "Water Spirit", points = 5,
    description = "Acquire the Water Spirit",
    id = 71986, badge = "73281", published = "2/15/2019 8:27:09 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 3 && outside_town() == 1 && bit2(0x0013a7) == 0 && prev(bit2(0x0013a7)) == 1
)

achievement(
    title = "Fanatic", points = 5, type="progression",
    description = "Defeat Sauza",
    id = 71987, badge = "73282", published = "2/15/2019 8:27:12 AM", modified = "9/23/2019 9:38:01 AM",
    trigger = current_chapter() == 3 && enemy1_id() == 0x40 && enemy1_hp() == 0 && prev(enemy1_hp()) > 0
)

achievement(
    title = "Card Master III", points = 25,
    description = "Complete Chapter 3 with Rooks at Level 15 or lower",
    id = 71988, badge = "73292", published = "2/15/2019 8:27:14 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = current_chapter() == 4 && prev(current_chapter()) == 3 && current_rooks_level() <= 15 &&
                current_rooks_level() > 0
)

achievement(
    title = "Cartographer IV", points = 10,
    description = "Completely explore Stavery Tower (Chapter 4)",
    id = 71989, badge = "73268", published = "2/15/2019 8:27:16 AM", modified = "1/2/2021 3:39:38 AM",
    trigger = unless(current_chapter() != 4) && never(outside_town() == False) &&
                measured(
                    tally(3,
                        once(tiles_explored("map1") == 450),
                        once(tiles_explored("map2") == 507),
                        once(tiles_explored("map3") == 364)
                    )
                ) && 
                prev(tiles_explored("map1") + tiles_explored("map2") + tiles_explored("map3") == 1320)
)

// Ticket 17482: I'm sure I opened ever treasure chest in Chapter 4 but no cheev yet for this. IF the 11th and 12
//               floors have no chests then I opened them all.
achievement(
    title = "Treasure Hunter IV", points = 5,
    description = "Open every chest in Stavery Tower (Chapter 4)",
    id = 71990, badge = "73270", published = "2/15/2019 8:27:19 AM", modified = "1/2/2021 3:39:34 AM",
    trigger = measured(chests_opened() == 25, current_chapter() == 4) &&
                prev(chests_opened() == 24)
)

achievement(
    title = "Monster Hunter IV", points = 10,
    description = "Encounter every new enemy in Chapter 4 (excluding bosses)",
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
    title = "Earth Spirit", points = 5,
    description = "Acquire the Earth Spirit",
    id = 71992, badge = "73283", published = "2/15/2019 8:27:23 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = byte(0x0018CD) == 4 && bit1(0x0013A7) == 0 && once(bit1(0x0013A7) != prev(bit1(0x0013A7))) &&
              unless(dword(0x0016F7) != 655371)
)

// Ticket 34466: Triggers at beginning of battle.
// Ticket 19718: Relatively minor issue but this triggered at the start of the battle instead of being awarded for
//               winning.
// Ticket 17453: I beat Darah in floor 1 of Chatper 4 and Summoned Evil popped. It's not supposed to yet is it?
achievement(
    title = "Summoned Evil", points = 5, type="progression",
    description = "Defeat Darah and Barah",
    id = 71993, badge = "73284", published = "2/15/2019 8:27:26 AM", modified = "12/12/2021 1:47:39 PM",
    trigger = byte(0x0018CD) == 4 && dword(0x0016F7) == 1507345 && once(word(0x000657) == 80 || word(0x000657) == 81) &&
              once(word(0x000659) == 80 || word(0x000659) == 81) && word(0x0012FB) == 0 && word(0x0012FD) == 0 &&
              never((word(0x0012F3) == 0 && byte(0x001064) == 55)) && bit1(0x0013A7) == 1
)

achievement(
    title = "The Betrayer", points = 5, type="progression",
    description = "Defeat Galneon's pawn on the seventh floor of Stavery Tower",
    id = 71994, badge = "73295", published = "2/15/2019 8:27:28 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = byte(0x0018CD) == 4 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 82)
)

achievement(
    title = "Spellbound", points = 5, type="progression",
    description = "Defeat Galneon's pawn on the eleventh floor of Stavery Tower",
    id = 71995, badge = "73296", published = "2/15/2019 8:27:30 AM", modified = "2/15/2019 8:29:41 AM",
    trigger = byte(0x0018CD) == 4 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 83)
)

achievement(
    title = "Card Master IV", points = 25,
    description = "Complete Chapter 4 with Rooks at Level 20 or lower",
    id = 71996, badge = "73293", published = "2/15/2019 8:27:33 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = byte(0x00137B) < 21 && once(byte(0x0018CD) == 4) && once(byte(0x0018CD) == 5) &&
              never(byte(0x001064) == 53) && never(byte(0x001064) == 55) && never(byte(0x00137B) == 0)
)

achievement(
    title = "Cartographer V", points = 10,
    description = "Completely explore Bintel Castle, the Tunnel, and Stavery Tower",
    id = 71997, badge = "73269", published = "2/15/2019 8:27:36 AM", modified = "1/2/2021 3:39:25 AM",
    trigger = unless(current_chapter() != 4) && never(outside_town() == False) &&
                measured(
                    tally(3,
                        once(tiles_explored("map1") == 455),
                        once(tiles_explored("map2") == 229),
                        once(tiles_explored("map3") == 262)
                    )
                ) && 
                prev(tiles_explored("map1") + tiles_explored("map2") + tiles_explored("map3") == 945)
)

achievement(
    title = "Treasure Hunter V", points = 5,
    description = "Open every chest in Bintel Castle, the Tunnel, and Stavery Tower",
    id = 71998, badge = "73270", published = "2/15/2019 8:27:38 AM", modified = "1/2/2021 3:39:22 AM",
    trigger = measured(chests_opened() == 23, current_chapter() == 5) &&
                prev(chests_opened() == 22)
)

achievement(
    title = "Monster Hunter V", points = 10,
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
    title = "Last Man Standing", points = 5, type="progression",
    description = "Defeat Karul",
    id = 72000, badge = "73287", published = "2/15/2019 8:27:44 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = byte(0x0018CD) == 5 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 99)
)

achievement(
    title = "Usurper", points = 5, type="progression",
    description = "Defeat Galneon",
    id = 72001, badge = "73288", published = "2/15/2019 8:27:47 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = byte(0x0018CD) == 5 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 101)
)

achievement(
    title = "Trusted Circle", points = 10, type="win_condition",
    description = "Complete Chapter 5",
    id = 72002, badge = "73289", published = "2/15/2019 8:27:49 AM", modified = "10/2/2019 10:46:01 AM",
    trigger = byte(0x0018CD) == 5 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 103)
)

achievement(
    title = "Card Master V", points = 50,
    description = "Complete Chapter 5 with Rooks at Level 25 or lower",
    id = 72003, badge = "73294", published = "2/15/2019 8:27:52 AM", modified = "10/11/2019 12:51:01 PM",
    trigger = byte(0x00137B) < 26 && byte(0x0018CD) == 5 && once(word(0x0012FB) == 0) && unless(word(0x000657) != 103) &&
              never(byte(0x001064) == 55) && never(byte(0x00137B) == 0)
)

achievement(
    title = "Lower Guardian", points = 5,
    description = "Defeat the Stone Guardian",
    id = 71822, badge = "73276", published = "2/11/2019 9:47:48 AM", modified = "2/12/2019 8:16:05 AM",
    trigger = byte(0x0018CD) == 1 && byte(0x0018DF) == 1 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 393231)
)

achievement(
    title = "Upper Guardian", points = 5,
    description = "Defeat the Iron Guardian",
    id = 71823, badge = "73277", published = "2/11/2019 10:26:55 AM", modified = "2/12/2019 8:24:12 AM",
    trigger = byte(0x0018CD) == 1 && byte(0x0018DF) == 3 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 589839)
)

achievement(
    title = "Forest Protector", points = 5,
    description = "Defeat the Cyclops",
    id = 71846, badge = "73278", published = "2/11/2019 7:39:55 PM", modified = "2/12/2019 8:18:53 AM",
    trigger = byte(0x0018CD) == 2 && byte(0x0018DF) == 1 && once(byte(0x0018DF) != prev(byte(0x0018DF))) &&
              unless(dword(0x0016F7) != 1572872)
)

achievement(
    title = "Fire Spirit", points = 5,
    description = "Acquire the Fire Spirit",
    id = 71858, badge = "73279", published = "2/11/2019 10:41:38 PM", modified = "2/12/2019 8:20:12 AM",
    trigger = byte(0x0018CD) == 2 && bit3(0x0013A7) == 0 && once(bit3(0x0013A7) != prev(bit3(0x0013A7))) &&
              unless(dword(0x0016F7) != 786461)
)

achievement(
    title = "Cartographer I", points = 15,
    description = "Completely explore Balnia Temple (Chapter 1)",
    id = 71887, badge = "73265", published = "2/13/2019 6:21:04 AM", modified = "2/14/2019 9:46:02 PM",
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
