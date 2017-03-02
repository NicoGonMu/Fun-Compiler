package Funv2_Goto is

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
,(-3, 1),(-2, 2)
-- State  1
,(-8, 6),(-7, 5)
,(-6, 4),(-5, 3),(-4, 11)
-- State  2

-- State  3

-- State  4

-- State  5

-- State  6

-- State  7
,(-9, 14)

-- State  8

-- State  9

-- State  10

-- State  11

-- State  12

-- State  13

-- State  14

-- State  15

-- State  16

-- State  17

-- State  18

-- State  19

-- State  20
,(-11, 24),(-10, 26)
-- State  21
,(-13, 27),(-12, 28)

-- State  22
,(-16, 32),(-14, 33)
-- State  23

-- State  24

-- State  25

-- State  26

-- State  27

-- State  28

-- State  29
,(-13, 27),(-12, 42)

-- State  30

-- State  31

-- State  32

-- State  33

-- State  34

-- State  35

-- State  36
,(-11, 24),(-10, 47)
-- State  37
,(-9, 48)
-- State  38

-- State  39

-- State  40

-- State  41
,(-13, 50)

-- State  42

-- State  43

-- State  44

-- State  45

-- State  46
,(-16, 56)
-- State  47

-- State  48

-- State  49

-- State  50

-- State  51

-- State  52

-- State  53

-- State  54

-- State  55
,(-21, 65),(-20, 63),(-15, 59)

-- State  56

-- State  57

-- State  58
,(-17, 79)
-- State  59

-- State  60
,(-21, 65),(-20, 63),(-15, 82)

-- State  61
,(-21, 65),(-20, 63),(-19, 84),(-15, 83)

-- State  62
,(-21, 65),(-20, 63),(-19, 85),(-15, 83)

-- State  63

-- State  64

-- State  65

-- State  66

-- State  67

-- State  68

-- State  69

-- State  70

-- State  71

-- State  72

-- State  73

-- State  74

-- State  75

-- State  76

-- State  77

-- State  78

-- State  79

-- State  80

-- State  81
,(-17, 88)
-- State  82

-- State  83

-- State  84

-- State  85

-- State  86
,(-21, 65),(-20, 63),(-15, 93)

-- State  87
,(-21, 65),(-20, 63),(-15, 94)
-- State  88

-- State  89
,(-18, 96)

-- State  90

-- State  91
,(-21, 65),(-20, 63),(-15, 97)
-- State  92

-- State  93

-- State  94

-- State  95

-- State  96

-- State  97

-- State  98

-- State  99

);
--  The offset vector
GOTO_OFFSET : array (0.. 99) of Integer :=
( 0,
 2, 7, 7, 7, 7, 7, 7, 8, 8, 8,
 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
 10, 12, 14, 14, 14, 14, 14, 14, 14, 16,
 16, 16, 16, 16, 16, 16, 18, 19, 19, 19,
 19, 20, 20, 20, 20, 20, 21, 21, 21, 21,
 21, 21, 21, 21, 21, 24, 24, 24, 25, 25,
 28, 32, 36, 36, 36, 36, 36, 36, 36, 36,
 36, 36, 36, 36, 36, 36, 36, 36, 36, 36,
 36, 37, 37, 37, 37, 37, 40, 43, 43, 44,
 44, 47, 47, 47, 47, 47, 47, 47, 47);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  54) of Natural := ( 2,
 1, 2, 0, 1, 1, 1, 1, 3,
 1, 3, 5, 1, 3, 1, 4, 5,
 1, 3, 3, 1, 3, 3, 8, 1,
 3, 1, 1, 3, 3, 4, 3, 4,
 3, 3, 1, 1, 1, 3, 1, 3,
 1, 3, 1, 1, 1, 1, 1, 1,
 1, 1, 1, 1, 1, 1);
   Get_LHS_Rule: array (Rule range  0 ..  54) of Nonterminal := (-1,
-2,-3,-3,-4,-4,-4,-4,-5,
-9,-9,-6,-10,-10,-11,-11,-7,
-12,-12,-12,-13,-13,-13,-8,-14,
-14,-16,-16,-16,-16,-15,-15,-15,
-15,-15,-15,-15,-15,-17,-18,-18,
-19,-19,-20,-20,-20,-20,-20,-20,
-20,-20,-20,-21,-21,-21);
end Funv2_Goto;
