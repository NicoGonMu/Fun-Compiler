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
,( 8, 9),( 11, 16),( 13, 19),( 17, 14)
,( 18, 17),( 21, 18),( 24, 12),( 25, 13)
,( 26, 15),( 27, 21),( 28, 22),( 29, 23)
,(-1,-3000)
-- state  1
,( 8, 9),( 11, 16),( 13, 19)
,( 17, 14),( 18, 17),( 21, 18),( 24, 12)
,( 25, 13),( 26, 15),( 27, 21),( 28, 22)
,( 29, 23),(-1,-1)
-- state  2
,(-1,-2)
-- state  3
,(-1,-4)

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
,( 26, 26),(-1,-3000)
-- state  10
,(-1,-29)

-- state  11
,( 20, 27),(-1,-30)
-- state  12
,( 26, 28),(-1,-3000)

-- state  13
,( 26, 29),(-1,-3000)
-- state  14
,( 26, 30),(-1,-3000)

-- state  15
,( 3, 31),(-1,-38)
-- state  16
,( 11, 16),( 13, 19)
,( 18, 17),( 21, 18),( 26, 33),( 27, 21)
,( 28, 22),( 29, 23),(-1,-3000)
-- state  17
,( 26, 35)
,(-1,-3000)
-- state  18
,( 11, 16),( 13, 19),( 18, 17)
,( 21, 18),( 26, 33),( 27, 21),( 28, 22)
,( 29, 23),(-1,-3000)
-- state  19
,( 11, 16),( 13, 19)
,( 18, 17),( 21, 18),( 26, 33),( 27, 21)
,( 28, 22),( 29, 23),(-1,-3000)
-- state  20
,(-1,-39)

-- state  21
,(-1,-44)
-- state  22
,(-1,-45)
-- state  23
,(-1,-46)
-- state  24
,( 0,-3001)
,(-1,-3000)
-- state  25
,(-1,-3)
-- state  26
,( 11, 41),(-1,-3000)

-- state  27
,( 26, 35),(-1,-3000)
-- state  28
,( 2, 43),(-1,-3000)

-- state  29
,( 2, 44),(-1,-3000)
-- state  30
,( 2, 45),(-1,-3000)

-- state  31
,( 11, 16),( 13, 19),( 18, 17),( 21, 18)
,( 26, 33),( 27, 21),( 28, 22),( 29, 23)
,(-1,-3000)
-- state  32
,( 12, 47),( 20, 27),(-1,-42)

-- state  33
,(-1,-38)
-- state  34
,( 12, 48),( 16, 49),(-1,-3000)

-- state  35
,( 3, 31),(-1,-3000)
-- state  36
,( 19, 50),(-1,-3000)

-- state  37
,( 20, 27),( 22, 51),(-1,-3000)
-- state  38
,( 20, 27)
,(-1,-42)
-- state  39
,( 14, 52),( 16, 49),(-1,-3000)

-- state  40
,(-1,-3000)
-- state  41
,( 10, 56),( 26, 55),(-1,-3000)

-- state  42
,(-1,-34)
-- state  43
,( 11, 16),( 13, 19),( 18, 17)
,( 21, 18),( 26, 33),( 27, 21),( 28, 22)
,( 29, 23),(-1,-3000)
-- state  44
,( 11, 61),( 13, 63)
,( 26, 62),(-1,-3000)
-- state  45
,( 11, 61),( 13, 63)
,( 26, 62),(-1,-3000)
-- state  46
,( 20, 27),(-1,-31)

-- state  47
,(-1,-32)
-- state  48
,(-1,-37)
-- state  49
,( 11, 16),( 13, 19)
,( 18, 17),( 21, 18),( 26, 33),( 27, 21)
,( 28, 22),( 29, 23),(-1,-3000)
-- state  50
,( 11, 16)
,( 13, 19),( 18, 17),( 21, 18),( 26, 33)
,( 27, 21),( 28, 22),( 29, 23),(-1,-3000)

-- state  51
,( 26, 67),(-1,-3000)
-- state  52
,(-1,-36)
-- state  53
,(-1,-23)

-- state  54
,( 12, 69),( 16, 70),(-1,-3000)
-- state  55
,( 9, 71)
,(-1,-25)
-- state  56
,( 9, 72),(-1,-26)
-- state  57
,( 4, 73)
,( 20, 27),(-1,-11)
-- state  58
,(-1,-10)
-- state  59
,( 7, 74)
,(-1,-14)
-- state  60
,( 5, 75),(-1,-13)
-- state  61
,( 11, 61)
,( 13, 63),( 26, 62),(-1,-3000)
-- state  62
,(-1,-17)

-- state  63
,( 11, 79),( 13, 63),( 26, 62),(-1,-3000)

-- state  64
,( 5, 75),( 15, 80),(-1,-3000)
-- state  65
,( 20, 27)
,(-1,-43)
-- state  66
,( 20, 27),(-1,-33)
-- state  67
,( 23, 81)
,(-1,-40)
-- state  68
,(-1,-35)
-- state  69
,( 3, 82),(-1,-3000)

-- state  70
,( 10, 56),( 26, 55),(-1,-3000)
-- state  71
,( 10, 56)
,( 26, 55),(-1,-3000)
-- state  72
,( 10, 56),( 26, 55)
,(-1,-3000)
-- state  73
,( 11, 16),( 13, 19),( 18, 17)
,( 21, 18),( 26, 33),( 27, 21),( 28, 22)
,( 29, 23),(-1,-3000)
-- state  74
,( 26, 87),(-1,-3000)

-- state  75
,( 11, 79),( 13, 63),( 26, 62),(-1,-3000)

-- state  76
,( 7, 74),( 12, 89),(-1,-14)
-- state  77
,( 5, 75)
,( 11, 90),(-1,-3000)
-- state  78
,( 7, 74),( 13, 91)
,(-1,-3000)
-- state  79
,( 11, 79),( 13, 63),( 26, 62)
,(-1,-3000)
-- state  80
,(-1,-21)
-- state  81
,( 26, 93),(-1,-3000)

-- state  82
,( 11, 16),( 13, 19),( 18, 17),( 21, 18)
,( 26, 33),( 27, 21),( 28, 22),( 29, 23)
,(-1,-3000)
-- state  83
,(-1,-24)
-- state  84
,(-1,-27)
-- state  85
,(-1,-28)

-- state  86
,(-1,-12)
-- state  87
,(-1,-18)
-- state  88
,( 7, 74),(-1,-15)

-- state  89
,(-1,-19)
-- state  90
,(-1,-16)
-- state  91
,(-1,-20)
-- state  92
,( 7, 74)
,( 12, 89),(-1,-3000)
-- state  93
,(-1,-41)
-- state  94
,( 15, 95)
,( 20, 27),(-1,-3000)
-- state  95
,(-1,-22)
);
--  The offset vector
SHIFT_REDUCE_OFFSET : array (0.. 95) of Integer :=
( 0,
 13, 26, 27, 28, 29, 30, 31, 32, 33, 35,
 36, 38, 40, 42, 44, 46, 55, 57, 66, 75,
 76, 77, 78, 79, 81, 82, 84, 86, 88, 90,
 92, 101, 104, 105, 108, 110, 112, 115, 117, 120,
 121, 124, 125, 134, 138, 142, 144, 145, 146, 155,
 164, 166, 167, 168, 171, 173, 175, 178, 179, 181,
 183, 187, 188, 192, 195, 197, 199, 201, 202, 204,
 207, 210, 213, 222, 224, 228, 231, 234, 237, 241,
 242, 244, 253, 254, 255, 256, 257, 258, 260, 261,
 262, 263, 266, 267, 270);
end Fun_Shift_Reduce;