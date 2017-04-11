--CREATE PROCEDURE GenerateNextSimRun 
--AS
--BEGIN

DECLARE @SimRef INT;
DECLARE @RunId INT;
DECLARE @Version VARCHAR(20);
SELECT TOP 1 @Version = [Version]
FROM shaman.SimVersions ORDER BY RefId DESC;
SELECT TOP 1 @SimRef = SimSetId
FROM shaman.SimRefLookup
WHERE SimSetId NOT IN
(
    SELECT SimRefId
    FROM shaman.SimRuns
    WHERE SimProgress <> @Version
          AND SimProgress <> 'Invalid'
);

--INSERT INTO shaman.SimRuns (
--	SimRefId, 
--	SimProgress, 
--	[Version], 
--	SimRunSource, 
--	SimRunDestination
--) OUTPUT @RunId
--VALUES (
--	@SimRef, 
--	'Preparing', 
--	@Version,
--	N'C:\Users\kevin.gray\Documents\Personal\Theorycrafting\SimSource\shaman - ' + @SimRef + ' (' + @Version + ').simc',
--	N'C:\Users\kevin.gray\Documents\Personal\Theorycrafting\SimDest\shaman - ' + @SimRef + ' (' + @Version + ').simc'
--);

WITH ItemRefs
     AS (SELECT [desc],
                ref,
                EnchantSet,
                GemSet
         FROM shaman.SimRefLookup
              CROSS APPLY(VALUES
                         ('Back',
                          [Back]
                         ),
                         ('Feet',
                          [Feet]
                         ),
                         ('Finger1',
                          [Finger1]
                         ),
                         ('Finger2',
                          [Finger2]
                         ),
                         ('Hands',
                          [Hands]
                         ),
                         ('Head',
                          [Head]
                         ),
                         ('Legs',
                          [Legs]
                         ),
                         ('Neck',
                          [Neck]
                         ),
                         ('Chest',
                          [Chest]
                         ),
                         ('Shoulders',
                          [Shoulders]
                         ),
                         ('Trinket1',
                          [Trinket1]
                         ),
                         ('Trinket2',
                          [Trinket2]
                         ),
                         ('Waist',
                          [Waist]
                         ),
                         ('Wrist',
                          [Wrist]
                         ),
                         ('Main_Hand',
                          [Main_Hand]
                         )) AS A([desc], ref)
         WHERE SimRefLookup.SimSetId = 148--@SimRef
         ),
     EnrichedLines
     AS (
     --,
     SELECT(CASE
                WHEN CONTAINS(items.ItemString, '=1808')
                THEN ROW_NUMBER() OVER(PARTITION BY(CASE
                                                        WHEN CONTAINS(ItemString, '=1808')
                                                        THEN 1
                                                        WHEN CONTAINS(ItemString, '/1808')
                                                        THEN 1
                                                        ELSE 0
                                                    END) ORDER BY ref)
                WHEN CONTAINS(items.ItemString, '/1808')
                THEN ROW_NUMBER() OVER(PARTITION BY(CASE
                                                        WHEN CONTAINS(ItemString, '/1808')
                                                        THEN 1
                                                        WHEN CONTAINS(ItemString, '/1808')
                                                        THEN 1
                                                        ELSE 0
                                                    END) ORDER BY ref)
                ELSE 0
            END) AS Socketed,
           (CASE
                WHEN CONTAINS(items.ItemString, 'trinket=')
                THEN ROW_NUMBER() OVER(PARTITION BY(CASE
                                                        WHEN CONTAINS(ItemString, 'trinket=')
                                                        THEN 1
                                                        ELSE 0
                                                    END) ORDER BY ref)
                ELSE 0
            END) AS TrinketNum,
           (CASE
                WHEN CONTAINS(items.ItemString, 'finger=')
                THEN ROW_NUMBER() OVER(PARTITION BY(CASE
                                                        WHEN CONTAINS(ItemString, 'finger=')
                                                        THEN 1
                                                        ELSE 0
                                                    END) ORDER BY ref)
                ELSE 0
            END) AS FingerNum,
           (CASE
                WHEN CONTAINS(items.ItemString, 'neck=')
                THEN 1
                ELSE 0
            END) AS IsNeck,
           (CASE
                WHEN CONTAINS(items.ItemString, 'back=')
                THEN 1
                ELSE 0
            END) AS IsBack,
           items.RefId AS ItemSet,
           items.ItemSlot,
           items.ItemString,
           CONVERT( VARCHAR(10), enchants.Finger) AS FingerEnchant,
           CONVERT( VARCHAR(10), enchants.Back) AS BackEnchant,
           CONVERT( VARCHAR(10), enchants.Neck) AS NeckEnchant,
           CONVERT( VARCHAR(10), gems.GemId) AS GemId,
           CONVERT( VARCHAR(10), gems.[Unique]) AS UniqueGem,
           refs.*
     FROM ItemRefs AS refs
          INNER JOIN shaman.ItemData AS items ON refs.ref = items.RefId
          INNER JOIN shaman.EnchantSet AS enchants ON EnchantSet = enchants.RefId
          INNER JOIN shaman.GemSet AS gems ON GemSet = gems.RefId),
     GemmedLines
     AS (SELECT CASE
                    WHEN IsBack > 0
                    THEN ItemString+',enchant='+BackEnchant
                    WHEN FingerNum > 0
                    THEN ItemString+',enchant='+FingerEnchant
                    WHEN IsNeck > 0
                    THEN ItemString+',enchant='+NeckEnchant
                    ELSE ItemString
                END AS ItemString,
                GemId,
                UniqueGem,
                Socketed,
                FingerNum,
                TrinketNum
         FROM EnrichedLines),
     EnchantedLines
     AS (SELECT CASE
                    WHEN Socketed = 1
                    THEN ItemString+',gem='+ISNULL(UniqueGem, GemId)
                    WHEN Socketed > 1
                    THEN ItemString+',gem='+GemId
                    ELSE ItemString
                END AS ItemString,
                FingerNum,
                TrinketNum
         FROM GemmedLines)
     ,EnrichedGearLines AS (SELECT CASE
                WHEN TrinketNum > 0
                THEN REPLACE(ItemString, 'trinket=', 'trinket'+CONVERT( VARCHAR(10), TrinketNum)+'=')
                WHEN FingerNum > 0
                THEN REPLACE(ItemString, 'finger=', 'finger'+CONVERT(VARCHAR(10), FingerNum)+'=')
                ELSE ItemString
            END AS ItemString
     FROM EnchantedLines)
SELECT
;
     --END
     --GO