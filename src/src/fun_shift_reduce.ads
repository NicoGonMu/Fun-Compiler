package Fun_Shift_Reduce is

    type Small_Integer is range -32_000 .. 32_000;

    type Shift_Reduce_Entry is record
        T   : Small_Integer;
        Act : Small_Integer;
    end record;
    pragma Pack(Shift_Reduce_Entry);

    subtype Row is Integer range -1 .. Integer'Last;

  --pragma suppress(index_check);

    type Shift_Reduce_Array is array (Row  range <>) of Shift_Reduce_Entry;

    Shift_Reduce_Matrix : constant Shift_Reduce_Array :=
        ( (-1,-1) -- Dummy Entry

-- state  0
,( 7, 13),( 15, 12),( 19, 10),( 20, 11)
,( 21, 9),(-1,-4)
-- state  1
,(-1,-1)
-- state  2
,( 9, 15)
,( 11, 25),( 16, 24),( 22, 29),( 23, 26)
,( 24, 27),( 25, 28),( 28, 17),( 31, 18)
,(-1,-3000)
-- state  3
,( 7, 13),( 15, 12),( 19, 10)
,( 20, 11),( 21, 9),(-1,-4)
-- state  4
,(-1,-5)

-- state  5
,(-1,-6)
-- state  6
,(-1,-7)
-- state  7
,(-1,-8)
-- state  8
,(-1,-9)

-- state  9
,( 22, 32),(-1,-3000)
-- state  10
,( 22, 33),(-1,-3000)

-- state  11
,( 22, 34),(-1,-3000)
-- state  12
,( 22, 35),(-1,-3000)

-- state  13
,( 22, 36),(-1,-3000)
-- state  14
,( 0,-3001),(-1,-3000)

-- state  15
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  16
,( 8, 48),( 26, 45)
,( 27, 46),( 29, 47),( 30, 40),( 31, 41)
,( 32, 42),( 33, 43),( 34, 44),(-1,-2)

-- state  17
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  18
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  19
,(-1,-46)
-- state  20
,(-1,-47)
-- state  21
,(-1,-48)
-- state  22
,(-1,-49)

-- state  23
,(-1,-50)
-- state  24
,( 9, 15),( 11, 25),( 16, 24)
,( 22, 29),( 23, 26),( 24, 27),( 25, 28)
,( 28, 17),( 31, 18),(-1,-3000)
-- state  25
,( 9, 15)
,( 11, 25),( 16, 24),( 22, 29),( 23, 26)
,( 24, 27),( 25, 28),( 28, 17),( 31, 18)
,(-1,-3000)
-- state  26
,(-1,-56)
-- state  27
,(-1,-57)
-- state  28
,(-1,-58)

-- state  29
,( 9, 54),(-1,-23)
-- state  30
,(-1,-3)
-- state  31
,( 13, 56)
,( 14, 57),(-1,-3000)
-- state  32
,(-1,-12)
-- state  33
,( 9, 54)
,(-1,-23)
-- state  34
,( 9, 54),(-1,-23)
-- state  35
,( 2, 60)
,(-1,-3000)
-- state  36
,( 9, 61),(-1,-31)
-- state  37
,(-1,-3000)

-- state  38
,( 8, 48),( 10, 63),( 26, 45),( 27, 46)
,( 29, 47),( 30, 40),( 31, 41),( 32, 42)
,( 33, 43),( 34, 44),(-1,-55)
-- state  39
,( 10, 64)
,( 14, 65),(-1,-3000)
-- state  40
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  41
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  42
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  43
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  44
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  45
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  46
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  47
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  48
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  49
,( 8, 48),( 29, 47),( 30, 40),( 31, 41)
,( 32, 42),( 33, 43),( 34, 44),(-1,-44)

-- state  50
,( 32, 42),( 33, 43),( 34, 44),(-1,-45)

-- state  51
,( 8, 48),( 17, 75),( 26, 45),( 27, 46)
,( 29, 47),( 30, 40),( 31, 41),( 32, 42)
,( 33, 43),( 34, 44),(-1,-3000)
-- state  52
,( 12, 76)
,( 14, 65),(-1,-3000)
-- state  53
,( 8, 48),( 26, 45)
,( 27, 46),( 29, 47),( 30, 40),( 31, 41)
,( 32, 42),( 33, 43),( 34, 44),(-1,-55)

-- state  54
,( 9, 15),( 11, 25),( 16, 24),( 22, 29)
,( 23, 26),( 24, 27),( 25, 28),( 28, 17)
,( 31, 18),(-1,-3000)
-- state  55
,(-1,-21)
-- state  56
,(-1,-10)

-- state  57
,( 22, 79),(-1,-3000)
-- state  58
,( 2, 80),(-1,-3000)

-- state  59
,( 2, 81),(-1,-3000)
-- state  60
,( 9, 85),( 22, 29)
,(-1,-3000)
-- state  61
,( 9, 15),( 11, 25),( 16, 24)
,( 22, 29),( 23, 26),( 24, 27),( 25, 28)
,( 28, 17),( 31, 18),(-1,-3000)
-- state  62
,( 3, 89)
,(-1,-3000)
-- state  63
,(-1,-34)
-- state  64
,(-1,-52)
-- state  65
,( 9, 15)
,( 11, 25),( 16, 24),( 22, 29),( 23, 26)
,( 24, 27),( 25, 28),( 28, 17),( 31, 18)
,(-1,-3000)
-- state  66
,( 32, 42),( 33, 43),( 34, 44)
,(-1,-35)
-- state  67
,( 32, 42),( 33, 43),( 34, 44)
,(-1,-36)
-- state  68
,(-1,-37)
-- state  69
,(-1,-38)
-- state  70
,(-1,-39)

-- state  71
,( 8, 48),( 27, 46),( 29, 47),( 30, 40)
,( 31, 41),( 32, 42),( 33, 43),( 34, 44)
,(-1,-40)
-- state  72
,( 8, 48),( 29, 47),( 30, 40)
,( 31, 41),( 32, 42),( 33, 43),( 34, 44)
,(-1,-41)
-- state  73
,( 8,-3000),( 29,-3000),( 30, 40)
,( 31, 41),( 32, 42),( 33, 43),( 34, 44)
,(-1,-42)
-- state  74
,( 8,-3000),( 29,-3000),( 30, 40)
,( 31, 41),( 32, 42),( 33, 43),( 34, 44)
,(-1,-43)
-- state  75
,( 9, 15),( 11, 25),( 16, 24)
,( 22, 29),( 23, 26),( 24, 27),( 25, 28)
,( 28, 17),( 31, 18),(-1,-3000)
-- state  76
,(-1,-53)

-- state  77
,( 8, 48),( 26, 45),( 27, 46),( 29, 47)
,( 30, 40),( 31, 41),( 32, 42),( 33, 43)
,( 34, 44),(-1,-24)
-- state  78
,( 10, 92),( 14, 93)
,(-1,-3000)
-- state  79
,(-1,-11)
-- state  80
,( 9, 85),( 22, 29)
,(-1,-3000)
-- state  81
,( 22, 29),(-1,-3000)
-- state  82
,( 5, 98)
,( 6, 97),(-1,-27)
-- state  83
,(-1,-18)
-- state  84
,(-1,-19)

-- state  85
,( 9, 85),( 22, 29),(-1,-3000)
-- state  86
,( 13, 100)
,(-1,-3000)
-- state  87
,( 10, 101),( 14, 102),(-1,-3000)

-- state  88
,( 8, 48),( 26, 45),( 27, 46),( 29, 47)
,( 30, 40),( 31, 41),( 32, 42),( 33, 43)
,( 34, 44),(-1,-33)
-- state  89
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  90
,( 8, 48),( 26, 45),( 27, 46),( 29, 47)
,( 30, 40),( 31, 41),( 32, 42),( 33, 43)
,( 34, 44),(-1,-54)
-- state  91
,( 8, 48),( 18, 104)
,( 26, 45),( 27, 46),( 29, 47),( 30, 40)
,( 31, 41),( 32, 42),( 33, 43),( 34, 44)
,(-1,-3000)
-- state  92
,(-1,-22)
-- state  93
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  94
,( 6, 97),( 13, 106),(-1,-3000)
-- state  95
,( 4, 108)
,( 13, 107),(-1,-3000)
-- state  96
,(-1,-16)
-- state  97
,( 9, 85)
,( 22, 29),(-1,-3000)
-- state  98
,( 9, 85),( 22, 29)
,(-1,-3000)
-- state  99
,( 5, 111),( 6, 97),(-1,-3000)

-- state  100
,(-1,-26)
-- state  101
,(-1,-30)
-- state  102
,( 9, 15),( 11, 25)
,( 16, 24),( 22, 29),( 23, 26),( 24, 27)
,( 25, 28),( 28, 17),( 31, 18),(-1,-3000)

-- state  103
,( 8, 48),( 13, 113),( 26, 45),( 27, 46)
,( 29, 47),( 30, 40),( 31, 41),( 32, 42)
,( 33, 43),( 34, 44),(-1,-3000)
-- state  104
,( 9, 15)
,( 11, 25),( 16, 24),( 22, 29),( 23, 26)
,( 24, 27),( 25, 28),( 28, 17),( 31, 18)
,(-1,-3000)
-- state  105
,( 8, 48),( 26, 45),( 27, 46)
,( 29, 47),( 30, 40),( 31, 41),( 32, 42)
,( 33, 43),( 34, 44),(-1,-25)
-- state  106
,(-1,-13)

-- state  107
,(-1,-14)
-- state  108
,( 22, 29),(-1,-3000)
-- state  109
,(-1,-17)

-- state  110
,( 6, 97),(-1,-28)
-- state  111
,( 9, 85),( 22, 29)
,(-1,-3000)
-- state  112
,( 8, 48),( 26, 45),( 27, 46)
,( 29, 47),( 30, 40),( 31, 41),( 32, 42)
,( 33, 43),( 34, 44),(-1,-32)
-- state  113
,(-1,-29)

-- state  114
,( 8,-3000),( 29,-3000),( 30, 40),( 31, 41)
,( 32, 42),( 33, 43),( 34, 44),(-1,-51)

-- state  115
,(-1,-15)
-- state  116
,( 6, 97),( 10, 117),(-1,-3000)

-- state  117
,(-1,-20)
);
--  The offset vector
SHIFT_REDUCE_OFFSET : array (0.. 117) of Integer :=
( 0,
 6, 7, 17, 23, 24, 25, 26, 27, 28, 30,
 32, 34, 36, 38, 40, 50, 60, 70, 80, 81,
 82, 83, 84, 85, 95, 105, 106, 107, 108, 110,
 111, 114, 115, 117, 119, 121, 123, 124, 135, 138,
 148, 158, 168, 178, 188, 198, 208, 218, 228, 236,
 240, 251, 254, 264, 274, 275, 276, 278, 280, 282,
 285, 295, 297, 298, 299, 309, 313, 317, 318, 319,
 320, 329, 337, 345, 353, 363, 364, 374, 377, 378,
 381, 383, 386, 387, 388, 391, 393, 396, 406, 416,
 426, 437, 438, 448, 451, 454, 455, 458, 461, 464,
 465, 466, 476, 487, 497, 507, 508, 509, 511, 512,
 514, 517, 527, 528, 536, 537, 540);
end Fun_Shift_Reduce;
