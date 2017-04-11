
CREATE PROCEDURE GenerateNextSimRun 
AS
BEGIN
	
	DECLARE @SimRef int;
	DECLARE @RunId int;
	DECLARE @Version varchar(20);

	SELECT TOP 1 [Version] = @Version FROM shaman.SimVersions ORDER BY RefId DESC
	
	SELECT TOP 1 SimSetId = @SimRef 
	FROM shaman.SimRefLookup 
	WHERE SimSetId NOT IN (
		SELECT SimRefId 
		FROM shaman.SimRuns 
		WHERE SimProgress <> @Version AND SimProgress <> 'Invalid'
	);

	INSERT INTO shaman.SimRuns (
		SimRefId, 
		SimProgress, 
		[Version], 
		SimRunSource, 
		SimRunDestination
	) OUTPUT @RunId
	VALUES (
		@SimRef, 
		'Preparing', 
		@Version,
		N'C:\Users\kevin.gray\Documents\Personal\Theorycrafting\SimSource\shaman - ' + @SimRef + ' (' + @Version + ').simc',
		N'C:\Users\kevin.gray\Documents\Personal\Theorycrafting\SimDest\shaman - ' + @SimRef + ' (' + @Version + ').simc'
	);

	With ItemRefs AS (
		SELECT [desc], ref
		FROM shaman.SimRefLookup
		CROSS APPLY (VALUES
			('Back', [Back]),
			('Feet', [Feet]),
			('Finger1', [Finger1]),
			('Finger2', [Finger2]),
			('Hands', [Hands]),
			('Head', [Head]),
			('Legs', [Legs]),
			('Neck', [Neck]),
			('Chest', [Chest]),
			('Shoulders', [Shoulders]),
			('Trinket1', [Trinket1]),
			('Trinket2', [Trinket2]),
			('Waist', [Waist]),
			('Wrist', [Wrist]),
			('Main_Hand', [Main_Hand])
		) AS A([desc], ref)
		WHERE SimRefLookup.SimSetId = '1'--@SimRef
	)	
	select * from ItemRefs as refs INNER JOIN shaman.ItemData AS items ON refs.ref = items.ItemString

END