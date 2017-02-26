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
,(-20, 20),(-17, 10),(-12, 11),(-10, 8)
,(-9, 7),(-8, 6),(-7, 5),(-6, 4)
,(-5, 3),(-4, 2),(-3, 1),(-2, 24)

-- State  1
,(-20, 20),(-17, 10),(-12, 11),(-10, 8)
,(-9, 7),(-8, 6),(-7, 5),(-6, 4)
,(-5, 3),(-4, 25)
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
,(-20, 20),(-19, 34)
,(-12, 32)
-- State  17
,(-17, 36)
-- State  18
,(-20, 20),(-12, 37)

-- State  19
,(-20, 20),(-19, 39),(-12, 38)
-- State  20

-- State  21

-- State  22

-- State  23

-- State  24

-- State  25

-- State  26

-- State  27
,(-17, 42)

-- State  28

-- State  29

-- State  30

-- State  31
,(-20, 20),(-12, 46)
-- State  32

-- State  33

-- State  34

-- State  35

-- State  36

-- State  37

-- State  38

-- State  39

-- State  40

-- State  41
,(-16, 53),(-15, 54)

-- State  42

-- State  43
,(-20, 20),(-12, 57),(-11, 58)
-- State  44
,(-14, 59)
,(-13, 60)
-- State  45
,(-14, 59),(-13, 64)
-- State  46

-- State  47

-- State  48

-- State  49
,(-20, 20)
,(-12, 65)
-- State  50
,(-20, 20),(-12, 66)
-- State  51
,(-18, 68)

-- State  52

-- State  53

-- State  54

-- State  55

-- State  56

-- State  57

-- State  58

-- State  59

-- State  60

-- State  61
,(-14, 76),(-13, 77)
-- State  62

-- State  63
,(-14, 78)
-- State  64

-- State  65

-- State  66

-- State  67

-- State  68

-- State  69

-- State  70
,(-16, 83)

-- State  71
,(-16, 84)
-- State  72
,(-16, 85)
-- State  73
,(-20, 20),(-12, 57)
,(-11, 86)
-- State  74

-- State  75
,(-14, 88)
-- State  76

-- State  77

-- State  78

-- State  79
,(-14, 92)
-- State  80

-- State  81

-- State  82
,(-20, 20)
,(-12, 94)
-- State  83

-- State  84

-- State  85

-- State  86

-- State  87

-- State  88

-- State  89

-- State  90

-- State  91

-- State  92

-- State  93

-- State  94

-- State  95

);
--  The offset vector
GOTO_OFFSET : array (0.. 95) of Integer :=
( 0,
 12, 22, 22, 22, 22, 22, 22, 22, 22, 22,
 22, 22, 22, 22, 22, 22, 25, 26, 28, 31,
 31, 31, 31, 31, 31, 31, 31, 32, 32, 32,
 32, 34, 34, 34, 34, 34, 34, 34, 34, 34,
 34, 36, 36, 39, 41, 43, 43, 43, 43, 45,
 47, 48, 48, 48, 48, 48, 48, 48, 48, 48,
 48, 50, 50, 51, 51, 51, 51, 51, 51, 51,
 52, 53, 54, 57, 57, 58, 58, 58, 58, 59,
 59, 59, 61, 61, 61, 61, 61, 61, 61, 61,
 61, 61, 61, 61, 61);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  46) of Natural := ( 2,
 1, 1, 2, 1, 1, 1, 1, 1,
 1, 4, 1, 3, 4, 1, 3, 3,
 1, 3, 3, 3, 5, 8, 1, 3,
 1, 1, 3, 3, 1, 1, 3, 3,
 4, 3, 4, 3, 3, 1, 1, 1,
 3, 1, 3, 1, 1, 1);
   Get_LHS_Rule: array (Rule range  0 ..  46) of Nonterminal := (-1,
-2,-3,-3,-4,-4,-4,-5,-5,
-5,-8,-11,-11,-9,-13,-13,-13,
-14,-14,-14,-14,-10,-6,-15,-15,
-16,-16,-16,-16,-7,-7,-17,-12,
-12,-12,-12,-12,-12,-12,-12,-18,
-18,-19,-19,-20,-20,-20);
end Fun_Goto;
