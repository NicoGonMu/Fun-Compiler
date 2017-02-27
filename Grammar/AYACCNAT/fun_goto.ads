package Fun_Goto is

    type Small_Integer is range -32_000 .. 32_000;

    type Goto_Entry is record
        Nonterm  : Small_Integer;
        Newstate : Small_Integer;
    end record;

  --pragma suppress(index_check);

    subtype Row is Integer range -1 .. Integer'Last;

    type Goto_Parse_Table is array (Row range <>) of Goto_Entry;

    Goto_Matrix : constant Goto_Parse_Table :=
       ((-1,-1)  -- Dummy Entry.
-- State  0
,(-21, 21),(-20, 20),(-17, 10),(-12, 11)
,(-10, 8),(-9, 7),(-8, 6),(-7, 5)
,(-6, 4),(-5, 3),(-4, 2),(-3, 1)
,(-2, 34)
-- State  1
,(-21, 21),(-20, 20),(-17, 10)
,(-12, 11),(-10, 8),(-9, 7),(-8, 6)
,(-7, 5),(-6, 4),(-5, 3),(-4, 35)

-- State  2

-- State  3

-- State  4

-- State  5

-- State  6

-- State  7

-- State  8

-- State  9

-- State  10

-- State  11

-- State  12

-- State  13

-- State  14

-- State  15

-- State  16
,(-17, 43)
-- State  17
,(-21, 21),(-20, 20),(-12, 44)

-- State  18
,(-21, 21),(-20, 20),(-19, 47),(-12, 46)

-- State  19
,(-21, 21),(-20, 20),(-19, 48),(-12, 46)

-- State  20

-- State  21

-- State  22

-- State  23

-- State  24

-- State  25

-- State  26

-- State  27

-- State  28

-- State  29

-- State  30

-- State  31

-- State  32

-- State  33

-- State  34

-- State  35

-- State  36

-- State  37
,(-17, 51)
-- State  38

-- State  39

-- State  40

-- State  41
,(-21, 21),(-20, 20),(-12, 55)

-- State  42

-- State  43

-- State  44

-- State  45

-- State  46

-- State  47

-- State  48

-- State  49

-- State  50
,(-16, 61),(-15, 62)
-- State  51

-- State  52
,(-21, 21),(-20, 20)
,(-12, 65),(-11, 66)
-- State  53
,(-14, 67),(-13, 68)

-- State  54
,(-14, 67),(-13, 72)
-- State  55

-- State  56
,(-21, 21),(-20, 20)
,(-12, 73)
-- State  57
,(-18, 75)
-- State  58

-- State  59
,(-21, 21),(-20, 20)
,(-12, 76)
-- State  60

-- State  61

-- State  62

-- State  63

-- State  64

-- State  65

-- State  66

-- State  67

-- State  68

-- State  69
,(-14, 84),(-13, 85)
-- State  70

-- State  71
,(-14, 86)

-- State  72

-- State  73

-- State  74

-- State  75

-- State  76

-- State  77

-- State  78
,(-16, 91)
-- State  79
,(-16, 92)
-- State  80
,(-16, 93)
-- State  81
,(-21, 21)
,(-20, 20),(-12, 65),(-11, 94)
-- State  82

-- State  83
,(-14, 96)

-- State  84

-- State  85

-- State  86

-- State  87
,(-14, 100)
-- State  88

-- State  89

-- State  90
,(-21, 21),(-20, 20),(-12, 102)

-- State  91

-- State  92

-- State  93

-- State  94

-- State  95

-- State  96

-- State  97

-- State  98

-- State  99

-- State  100

-- State  101

-- State  102

-- State  103

);
--  The offset vector
GOTO_OFFSET : array (0.. 103) of Integer :=
( 0,
 13, 24, 24, 24, 24, 24, 24, 24, 24, 24,
 24, 24, 24, 24, 24, 24, 25, 28, 32, 36,
 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
 36, 36, 36, 36, 36, 36, 36, 37, 37, 37,
 37, 40, 40, 40, 40, 40, 40, 40, 40, 40,
 42, 42, 46, 48, 50, 50, 53, 54, 54, 57,
 57, 57, 57, 57, 57, 57, 57, 57, 57, 59,
 59, 60, 60, 60, 60, 60, 60, 60, 61, 62,
 63, 67, 67, 68, 68, 68, 68, 69, 69, 69,
 72, 72, 72, 72, 72, 72, 72, 72, 72, 72,
 72, 72, 72);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  55) of Natural := ( 2,
 1, 1, 2, 1, 1, 1, 1, 1,
 1, 4, 1, 3, 4, 1, 3, 3,
 1, 3, 3, 3, 5, 8, 1, 3,
 1, 1, 3, 3, 1, 1, 3, 4,
 3, 4, 3, 3, 1, 1, 1, 1,
 3, 1, 3, 1, 1, 1, 1, 1,
 1, 1, 1, 1, 1, 1, 1);
   Get_LHS_Rule: array (Rule range  0 ..  55) of Nonterminal := (-1,
-2,-3,-3,-4,-4,-4,-5,-5,
-5,-8,-11,-11,-9,-13,-13,-13,
-14,-14,-14,-14,-10,-6,-15,-15,
-16,-16,-16,-16,-7,-7,-17,-12,
-12,-12,-12,-12,-12,-12,-12,-18,
-18,-19,-19,-20,-20,-20,-20,-20,
-20,-20,-20,-20,-21,-21,-21);
end Fun_Goto;
