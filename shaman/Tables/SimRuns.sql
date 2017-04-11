CREATE TABLE [shaman].[SimRuns] (
    [RunId]             INT           IDENTITY (1, 1) NOT NULL,
    [SimRefId]          INT           NOT NULL,
    [SimRunSource]      VARCHAR (255) NULL,
    [SimRunDestination] VARCHAR (255) NULL,
    [SimRunResult]      FLOAT (53)    NULL,
    [SimProgress]       VARCHAR (25)  NOT NULL,
    [SimStart]          DATETIME2 (7) NULL,
    [SimEnd]            DATETIME2 (7) NULL,
    [Version]           VARCHAR (20)  NULL
);



