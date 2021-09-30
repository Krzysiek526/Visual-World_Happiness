CREATE SCHEMA ssis_sample

-- Landing table
DROP TABLE IF EXISTS ssis_sample.[World Happiness DB table];
CREATE TABLE ssis_sample.[World Happiness DB table] (
    [Country name] varchar(50),
    [Regional indicator] varchar(50),
    [Ladder score] varchar(50),
    [Standard error of ladder score] varchar(50),
    [upperwhisker] varchar(50),
    [lowerwhisker] varchar(50),
    [Logged GDP per capita] varchar(50),
    [Social support] varchar(50),
    [Healthy life expectancy] varchar(50),
    [Freedom to make life choices] varchar(50),
    [Generosity] varchar(50),
    [Perceptions of corruption] varchar(50),
    [Ladder score in Dystopia] varchar(50),
    [Explained by Log GDP per capita] varchar(50),
    [Explained by Social support] varchar(50),
    [Explained by Healthy life expectancy] varchar(50),
    [Explained by Freedom to make life choices] varchar(50),
    [Explained by Generosity] varchar(50),
    [Explained by Perceptions of corruption] varchar(50),
    [Dystopia + residual] varchar(50)
)

select * from ssis_sample.[World Happiness DB table]

-- Staging table
CREATE TABLE ssis_sample.[Staging World Happiness DB table] (
    [Country name] nvarchar(50),
    [Regional indicator] nvarchar(50),
    [Ladder score] decimal(6,3),
    [Standard error of ladder score] decimal(6,3),
    [upperwhisker] decimal(6,3),
    [lowerwhisker] decimal(6,3),
    [Logged GDP per capita] decimal(6,3),
    [Social support] decimal(6,3),
    [Healthy life expectancy] decimal(6,3),
    [Freedom to make life choices] decimal(6,3),
    [Generosity] decimal(6,3),
    [Perceptions of corruption] decimal(6,3),
    [Ladder score in Dystopia] decimal(6,3),
    [Explained by Log GDP per capita] decimal(6,3),
    [Explained by Social support] decimal(6,3),
    [Explained by Healthy life expectancy] decimal(6,3),
    [Explained by Freedom to make life choices] decimal(6,3),
    [Explained by Generosity] decimal(6,3),
    [Explained by Perceptions of corruption] decimal(6,3),
    [Dystopia + residual] decimal(6,3)
)
SELECT * FROM ssis_sample.[World Happiness DB table]

SELECT * FROM ssis_sample.[Staging World Happiness DB table]

DROP TABLE IF EXISTS [ssis_sample].[DimCountry]
CREATE TABLE [ssis_sample].[DimCountry]
(
	CountryId INT IDENTITY(1,1),
	CountryName NVARCHAR(50),
	RegionalIndicatorId INT FOREIGN KEY REFERENCES [ssis_sample].[DimRegionalIndicator](RegionalIndicatorId),
	CONSTRAINT [PK_DimCountry_CountryId] PRIMARY KEY CLUSTERED 
	(
		[CountryId] ASC
	),
	CONSTRAINT [UK_DimCountry_CountryName] UNIQUE
	(
		[CountryName]
	)
)

DROP TABLE IF EXISTS [ssis_sample].[DimRegionalIndicator]
CREATE TABLE [ssis_sample].[DimRegionalIndicator]
(
	RegionalIndicatorId INT IDENTITY(1,1),
	RegionalIndicator NVARCHAR(50),
	CONSTRAINT [PK_DimRegionalIndicator_RegionalIndicatorId] PRIMARY KEY CLUSTERED 
	(
		[RegionalIndicatorId] ASC
	),
	CONSTRAINT [UK_DimRegionalIndicator_RegionalIndicator] UNIQUE
	(
		[RegionalIndicator]
	)
)

DROP TABLE IF EXISTS [ssis_sample].[FactWorldHappiness]
CREATE TABLE [ssis_sample].[FactWorldHappiness]
(
	[Id] INT IDENTITY(1,1),
	[Year] INT,
	[CountryId] INT FOREIGN KEY REFERENCES [ssis_sample].[DimCountry](CountryId),
	[LadderScore] decimal(6,3),
    [StandardErrorOfLadder score] decimal(6,3),
    [Upperwhisker] decimal(6,3),
    [Lowerwhisker] decimal(6,3),
    [LoggedGDPPerCapita] decimal(6,3),
    [SocialSupport] decimal(6,3),
    [HealthyLifeExpectancy] decimal(6,3),
    [FreedomToMakeLifeChoices] decimal(6,3),
    [Generosity] decimal(6,3),
    [PerceptionsOfCorruption] decimal(6,3),
    [LadderScoreInDystopia] decimal(6,3),
    [ExplainedbyLogGDPPerCapita] decimal(6,3),
    [ExplainedbySocialSupport] decimal(6,3),
    [ExplainedbyHealthyLifeExpectancy] decimal(6,3),
    [ExplainedbyFreedomToMakeLifeChoices] decimal(6,3),
    [ExplainedbyGenerosity] decimal(6,3),
    [ExplainedbyPerceptionsOfCorruption] decimal(6,3),
    [DystopiaResidual] decimal(6,3),
	CONSTRAINT [PK_FactWorldHappiness_Id] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),
	CONSTRAINT [UK_FactWorldHappiness_Year_CountryId] UNIQUE
	(
		[Year],
		[CountryId]
	)
)
GO

CREATE OR ALTER PROCEDURE [ssis_sample].[LS_FactWorldHappiness] AS
BEGIN TRY
	BEGIN TRANSACTION
		TRUNCATE TABLE ssis_sample.[Staging World Happiness DB table];

		INSERT INTO [ssis_sample].[Staging World Happiness DB table]
		(
			[Country name]
			,[Regional indicator]
			,[Ladder score]
			,[Standard error of ladder score]
			,[upperwhisker]
			,[lowerwhisker]
			,[Logged GDP per capita]
			,[Social support]
			,[Healthy life expectancy]
			,[Freedom to make life choices]
			,[Generosity]
			,[Perceptions of corruption]
			,[Ladder score in Dystopia]
			,[Explained by  Log GDP per capita]
			,[Explained by  Social support]
			,[Explained by  Healthy life expectancy]
			,[Explained by  Freedom to make life choices]
			,[Explained by  Generosity]
			,[Explained by  Perceptions of corruption]
			,[Dystopia + residual]
		)
		SELECT
			[Country name]
			,[Regional indicator]
			,[Ladder score]
			,[Standard error of ladder score]
			,[upperwhisker]
			,[lowerwhisker]
			,[Logged GDP per capita]
			,[Social support]
			,[Healthy life expectancy]
			,[Freedom to make life choices]
			,[Generosity]
			,[Perceptions of corruption]
			,[Ladder score in Dystopia]
			,[Explained by  Log GDP per capita]
			,[Explained by  Social support]
			,[Explained by  Healthy life expectancy]
			,[Explained by  Freedom to make life choices]
			,[Explained by  Generosity]
			,[Explained by  Perceptions of corruption]
			,[Dystopia + residual]
		FROM
			[ssis_sample].[World Happiness DB table]

		SELECT @@ROWCOUNT AS RowsAffected
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH

EXEC [ssis_sample].[LS_FactWorldHappiness]

SELECT * FROM [ssis_sample].[Staging World Happiness DB table]
GO

CREATE OR ALTER PROCEDURE [ssis_sample].[LR_DimRegionalIndicator] AS
BEGIN TRY
	BEGIN TRANSACTION
		DROP TABLE IF EXISTS #tmpDim

		SELECT DISTINCT
			[Regional Indicator]
		INTO
			#tmpDim
		FROM
			[ssis_sample].[Staging World Happiness DB table]

		INSERT INTO [ssis_sample].[DimRegionalIndicator] (RegionalIndicator)
		SELECT
			[Regional Indicator]
		FROM
			#tmpDim
		EXCEPT
		SELECT
			RegionalIndicator
		FROM
			[ssis_sample].[DimRegionalIndicator]

		SELECT @@ROWCOUNT AS RowsAffected
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH

SELECT * FROM [ssis_sample].[DimRegionalIndicator]
EXEC [ssis_sample].[LR_DimRegionalIndicator]
GO

CREATE OR ALTER PROCEDURE [ssis_sample].[LR_DimCountry] AS
BEGIN TRY
	BEGIN TRANSACTION
		DROP TABLE IF EXISTS #tmpDim

		SELECT DISTINCT
			stg.[Country name],
			reg.RegionalIndicatorId
		INTO
			#tmpDim
		FROM
			[ssis_sample].[Staging World Happiness DB table] stg
		JOIN
			[ssis_sample].[DimRegionalIndicator] reg
			ON reg.RegionalIndicator = stg.[Regional Indicator]

		INSERT INTO [ssis_sample].[DimCountry] (CountryName, RegionalIndicatorId)
		SELECT
			[Country name],
			[RegionalIndicatorId]
		FROM
			#tmpDim
		EXCEPT
		SELECT
			CountryName,
			RegionalIndicatorId
		FROM
			[ssis_sample].[DimCountry]

		SELECT @@ROWCOUNT AS RowsAffected
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH

SELECT * FROM [ssis_sample].[DimCountry]
EXEC [ssis_sample].[LR_DimCountry]
GO

CREATE OR ALTER PROCEDURE [ssis_sample].[LF_FactWorldHappiness] AS
BEGIN TRY
	BEGIN TRANSACTION
		DROP TABLE IF EXISTS #tmpDim

		SELECT
			cntr.CountryId,
			YEAR(CURRENT_TIMESTAMP) AS Year
		  ,stg.[Ladder score]
		  ,stg.[Standard error of ladder score]
		  ,stg.[upperwhisker]
		  ,stg.[lowerwhisker]
		  ,stg.[Logged GDP per capita]
		  ,stg.[Social support]
		  ,stg.[Healthy life expectancy]
		  ,stg.[Freedom to make life choices]
		  ,stg.[Generosity]
		  ,stg.[Perceptions of corruption]
		  ,stg.[Ladder score in Dystopia]
		  ,stg.[Explained by  Log GDP per capita]
		  ,stg.[Explained by  Social support]
		  ,stg.[Explained by  Healthy life expectancy]
		  ,stg.[Explained by  Freedom to make life choices]
		  ,stg.[Explained by  Generosity]
		  ,stg.[Explained by  Perceptions of corruption]
		  ,stg.[Dystopia + residual]
		INTO
			#tmpDim
		FROM
			[ssis_sample].[Staging World Happiness DB table] stg
		JOIN
			[ssis_sample].[DimCountry] cntr
			ON cntr.CountryName = stg.[Country name]
		
		DELETE [ssis_sample].[FactWorldHappiness]
		FROM (
			SELECT DISTINCT
				Year,
				CountryId
			FROM 
				#tmpDim
		) tmp
		WHERE
			[ssis_sample].[FactWorldHappiness].[Year] = tmp.[Year]
			AND [ssis_sample].[FactWorldHappiness].[CountryId] = tmp.[CountryId]
		
		INSERT INTO [ssis_sample].[FactWorldHappiness]
           ([Year]
           ,[CountryId]
           ,[LadderScore]
           ,[StandardErrorOfLadder score]
           ,[Upperwhisker]
           ,[Lowerwhisker]
           ,[LoggedGDPPerCapita]
           ,[SocialSupport]
           ,[HealthyLifeExpectancy]
           ,[FreedomToMakeLifeChoices]
           ,[Generosity]
           ,[PerceptionsOfCorruption]
           ,[LadderScoreInDystopia]
           ,[ExplainedbyLogGDPPerCapita]
           ,[ExplainedbySocialSupport]
           ,[ExplainedbyHealthyLifeExpectancy]
           ,[ExplainedbyFreedomToMakeLifeChoices]
           ,[ExplainedbyGenerosity]
           ,[ExplainedbyPerceptionsOfCorruption]
           ,[DystopiaResidual])
		SELECT
			[Year]
			,[CountryId]
			,[Ladder score]
			,[Standard error of ladder score]
			,[upperwhisker]
			,[lowerwhisker]
			,[Logged GDP per capita]
			,[Social support]
			,[Healthy life expectancy]
			,[Freedom to make life choices]
			,[Generosity]
			,[Perceptions of corruption]
			,[Ladder score in Dystopia]
			,[Explained by  Log GDP per capita]
			,[Explained by  Social support]
			,[Explained by  Healthy life expectancy]
			,[Explained by  Freedom to make life choices]
			,[Explained by  Generosity]
			,[Explained by  Perceptions of corruption]
			,[Dystopia + residual]
		FROM
			#tmpDim

		SELECT @@ROWCOUNT AS RowsAffected
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH

EXEC [ssis_sample].[LF_FactWorldHappiness]

SELECT * FROM [ssis_sample].[FactWorldHappiness]
GO

CREATE VIEW [ssis_sample].[v_FactWorldHappiness] AS
SELECT
	fct.[Year],
    cntr.[CountryName],
	reg.[RegionalIndicator],
    fct.[LadderScore],
    fct.[StandardErrorOfLadder score],
    fct.[Upperwhisker],
    fct.[Lowerwhisker],
    fct.[LoggedGDPPerCapita],
    fct.[SocialSupport],
    fct.[HealthyLifeExpectancy],
    fct.[FreedomToMakeLifeChoices],
    fct.[Generosity],
    fct.[PerceptionsOfCorruption],
    fct.[LadderScoreInDystopia],
    fct.[ExplainedbyLogGDPPerCapita],
    fct.[ExplainedbySocialSupport],
    fct.[ExplainedbyHealthyLifeExpectancy],
    fct.[ExplainedbyFreedomToMakeLifeChoices],
    fct.[ExplainedbyGenerosity],
    fct.[ExplainedbyPerceptionsOfCorruption],
    fct.[DystopiaResidual]
FROM
	[ssis_sample].[FactWorldHappiness] fct
JOIN
	[ssis_sample].[DimCountry] cntr
	ON cntr.CountryId = fct.CountryId
JOIN
	[ssis_sample].[DimRegionalIndicator] reg
	ON reg.[RegionalIndicatorId] = cntr.[RegionalIndicatorId]

SELECT * FROM [ssis_sample].[v_FactWorldHappiness]