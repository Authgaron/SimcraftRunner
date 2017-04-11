CREATE FULLTEXT INDEX ON [shaman].[ItemData]
    ([ItemString] LANGUAGE 1033)
    KEY INDEX [ClusteredIndex-RefId]
    ON [ItemStringIndex];

