CREATE TABLE [shaman].[SimRefLookup] (
    [SimSetId]   INT IDENTITY (1, 1) NOT NULL,
    [Metadata]   INT NOT NULL,
    [Back]       INT NOT NULL,
    [Feet]       INT NOT NULL,
    [Finger1]    INT NOT NULL,
    [Finger2]    INT NOT NULL,
    [Hands]      INT NOT NULL,
    [Head]       INT NOT NULL,
    [Legs]       INT NOT NULL,
    [Neck]       INT NOT NULL,
    [Chest]      INT NOT NULL,
    [Shoulders]  INT NOT NULL,
    [Trinket1]   INT NOT NULL,
    [Trinket2]   INT NOT NULL,
    [Waist]      INT NOT NULL,
    [Wrist]      INT NOT NULL,
    [Main_Hand]  INT NOT NULL,
    [GemSet]     INT NULL,
    [EnchantSet] INT NULL
);



