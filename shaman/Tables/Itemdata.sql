CREATE TABLE [shaman].[ItemData] (
    [RefId]      INT           NOT NULL,
    [ItemSlot]   VARCHAR (25)  NULL,
    [ItemString] VARCHAR (512) NOT NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-RefId]
    ON [shaman].[ItemData]([RefId] ASC);

