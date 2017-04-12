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
,(-1,-4)
-- state  1
,(-1,-1)
-- state  2
,( 7, 26),( 9, 4)
,( 11, 18),( 15, 25),( 16, 17),( 19, 24)
,( 20, 23),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  3
,( 0,-3001),(-1,-3000)
-- state  4
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  5
,( 25, 36),( 26, 37),( 28, 38),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-2)
-- state  6
,( 9, 4),( 11, 18),( 16, 17)
,( 21, 22),( 22, 19),( 23, 20),( 24, 21)
,( 27, 6),( 30, 7),(-1,-3000)
-- state  7
,( 9, 4)
,( 11, 18),( 16, 17),( 21, 22),( 22, 19)
,( 23, 20),( 24, 21),( 27, 6),( 30, 7)
,(-1,-3000)
-- state  8
,(-1,-45)
-- state  9
,(-1,-46)
-- state  10
,(-1,-47)

-- state  11
,(-1,-48)
-- state  12
,(-1,-49)
-- state  13
,(-1,-5)
-- state  14
,(-1,-6)

-- state  15
,(-1,-7)
-- state  16
,(-1,-8)
-- state  17
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  18
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  19
,(-1,-55)
-- state  20
,(-1,-56)

-- state  21
,(-1,-57)
-- state  22
,( 9, 44),(-1,-17)
-- state  23
,( 21, 47)
,(-1,-3000)
-- state  24
,( 21, 48),(-1,-3000)
-- state  25
,( 21, 49)
,(-1,-3000)
-- state  26
,( 21, 50),(-1,-3000)
-- state  27
,(-1,-3)

-- state  28
,(-1,-3000)
-- state  29
,( 10, 51),( 25, 36),( 26, 37)
,( 28, 38),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-54)
-- state  30
,( 10, 52)
,( 14, 53),(-1,-3000)
-- state  31
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  32
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  33
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  34
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  35
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  36
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  37
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  38
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  39
,( 28, 38),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-43)
-- state  40
,( 31, 33),( 32, 34),( 33, 35)
,(-1,-44)
-- state  41
,( 17, 62),( 25, 36),( 26, 37)
,( 28, 38),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-3000)
-- state  42
,( 12, 63)
,( 14, 53),(-1,-3000)
-- state  43
,( 25, 36),( 26, 37)
,( 28, 38),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-54)
-- state  44
,( 9, 4)
,( 11, 18),( 16, 17),( 21, 22),( 22, 19)
,( 23, 20),( 24, 21),( 27, 6),( 30, 7)
,(-1,-3000)
-- state  45
,(-1,-15)
-- state  46
,( 13, 66),( 14, 67)
,(-1,-3000)
-- state  47
,(-1,-11)
-- state  48
,( 2, 68),(-1,-3000)

-- state  49
,( 2, 69),(-1,-3000)
-- state  50
,( 9, 70),(-1,-29)

-- state  51
,(-1,-34)
-- state  52
,(-1,-51)
-- state  53
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  54
,( 31, 33),( 32, 34),( 33, 35),(-1,-35)

-- state  55
,( 31, 33),( 32, 34),( 33, 35),(-1,-36)

-- state  56
,(-1,-37)
-- state  57
,(-1,-38)
-- state  58
,(-1,-39)
-- state  59
,( 26, 37)
,( 28, 38),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-40)
-- state  60
,( 28, 38)
,( 29, 31),( 30, 32),( 31, 33),( 32, 34)
,( 33, 35),(-1,-41)
-- state  61
,( 28,-3000),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-42)
-- state  62
,( 9, 4),( 11, 18),( 16, 17)
,( 21, 22),( 22, 19),( 23, 20),( 24, 21)
,( 27, 6),( 30, 7),(-1,-3000)
-- state  63
,(-1,-52)

-- state  64
,( 25, 36),( 26, 37),( 28, 38),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-18)
-- state  65
,( 10, 74),( 14, 75),(-1,-3000)

-- state  66
,(-1,-9)
-- state  67
,( 21, 76),(-1,-3000)
-- state  68
,( 21, 22)
,(-1,-3000)
-- state  69
,( 9, 82),( 21, 22),(-1,-22)

-- state  70
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  71
,( 3, 87),(-1,-3000)

-- state  72
,( 25, 36),( 26, 37),( 28, 38),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-53)
-- state  73
,( 18, 88),( 25, 36),( 26, 37)
,( 28, 38),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-3000)
-- state  74
,(-1,-16)

-- state  75
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  76
,(-1,-10)
-- state  77
,(-1,-13)

-- state  78
,( 4, 91),( 13, 90),(-1,-3000)
-- state  79
,( 6, 92)
,(-1,-21)
-- state  80
,(-1,-23)
-- state  81
,(-1,-25)
-- state  82
,( 21, 22)
,(-1,-3000)
-- state  83
,( 5, 94),(-1,-3000)
-- state  84
,( 10, 95)
,( 14, 96),(-1,-3000)
-- state  85
,( 8, 97),(-1,-31)

-- state  86
,( 25, 36),( 26, 37),( 28, 38),( 29, 31)
,( 30, 32),( 31, 33),( 32, 34),( 33, 35)
,(-1,-32)
-- state  87
,( 9, 4),( 11, 18),( 16, 17)
,( 21, 22),( 22, 19),( 23, 20),( 24, 21)
,( 27, 6),( 30, 7),(-1,-3000)
-- state  88
,( 9, 4)
,( 11, 18),( 16, 17),( 21, 22),( 22, 19)
,( 23, 20),( 24, 21),( 27, 6),( 30, 7)
,(-1,-3000)
-- state  89
,( 25, 36),( 26, 37),( 28, 38)
,( 29, 31),( 30, 32),( 31, 33),( 32, 34)
,( 33, 35),(-1,-19)
-- state  90
,(-1,-12)
-- state  91
,( 21, 22)
,(-1,-3000)
-- state  92
,( 9, 82),( 21, 22),(-1,-3000)

-- state  93
,( 5, 102),(-1,-3000)
-- state  94
,( 9, 82),( 21, 22)
,(-1,-22)
-- state  95
,(-1,-28)
-- state  96
,( 9, 4),( 11, 18)
,( 16, 17),( 21, 22),( 22, 19),( 23, 20)
,( 24, 21),( 27, 6),( 30, 7),(-1,-3000)

-- state  97
,( 9, 4),( 11, 18),( 16, 17),( 21, 22)
,( 22, 19),( 23, 20),( 24, 21),( 27, 6)
,( 30, 7),(-1,-3000)
-- state  98
,( 13, 106),( 25, 36)
,( 26, 37),( 28, 38),( 29, 31),( 30, 32)
,( 31, 33),( 32, 34),( 33, 35),(-1,-3000)

-- state  99
,( 28,-3000),( 29, 31),( 30, 32),( 31, 33)
,( 32, 34),( 33, 35),(-1,-50)
-- state  100
,(-1,-14)

-- state  101
,(-1,-24)
-- state  102
,( 21, 22),(-1,-3000)
-- state  103
,( 13, 108)
,(-1,-3000)
-- state  104
,( 8, 97),(-1,-30)
-- state  105
,( 25, 36)
,( 26, 37),( 28, 38),( 29, 31),( 30, 32)
,( 31, 33),( 32, 34),( 33, 35),(-1,-33)

-- state  106
,(-1,-27)
-- state  107
,( 10, 109),(-1,-3000)
-- state  108
,(-1,-20)

-- state  109
,(-1,-26)
);
--  The offset vector
SHIFT_REDUCE_OFFSET : array (0.. 109) of Integer :=
( 0,
 1, 2, 16, 18, 28, 37, 47, 57, 58, 59,
 60, 61, 62, 63, 64, 65, 66, 76, 86, 87,
 88, 89, 91, 93, 95, 97, 99, 100, 101, 111,
 114, 124, 134, 144, 154, 164, 174, 184, 194, 201,
 205, 215, 218, 227, 237, 238, 241, 242, 244, 246,
 248, 249, 250, 260, 264, 268, 269, 270, 271, 279,
 286, 293, 303, 304, 313, 316, 317, 319, 321, 324,
 334, 336, 345, 355, 356, 366, 367, 368, 371, 373,
 374, 375, 377, 379, 382, 384, 393, 403, 413, 422,
 423, 425, 428, 430, 433, 434, 444, 454, 464, 471,
 472, 473, 475, 477, 479, 488, 489, 491, 492);
end Fun_Shift_Reduce;