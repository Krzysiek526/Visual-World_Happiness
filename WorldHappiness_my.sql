/*

Czêœæ projektowa

*/



--1) od tego zaczynamy schematu
CREATE SCHEMA ssis_sample

--2) tabela landingowa dodajemy nazwy kolumn cos tam, czyscimy z ' : ' 
CREATE TABLE ssis_sample.[World Happiness DB table]
(
[Country name] VARCHAR(50),
[Regional indicator] VARCHAR(50),
[Ladder score] VARCHAR(50),
[Standard error of ladder score] VARCHAR(50),
[upperwhisker] VARCHAR(50),
[lowerwhisker] VARCHAR(50),
[Logged GDP per capita] VARCHAR(50),
[Social support] VARCHAR(50),
[Healthy life expectancy]VARCHAR(50),
[Freedom to make life choices] VARCHAR(50),
[Generosity] VARCHAR(50),
[Perceptions of corruption] VARCHAR(50),
[Ladder score in Dystopia] VARCHAR(50),
[Explained by Log GDP per capita] VARCHAR(50),
[Explained by Social support] VARCHAR(50),
[Explained by Healthy life expectancy] VARCHAR(50),
[Explained by Freedom to make life choices] VARCHAR(50),
[Explained by Generosity] VARCHAR(50),
[Explained by Perceptions of corruption] VARCHAR(50),
[Dystopia + residual] VARCHAR(50)
)

--3 to piszemy i kopuiujemy i wklejamy w SSIS - fota
TRUNCATE TABLE ssis_sample.[World Happiness DB table]

--4 test insert
INSERT INTO ssis_sample.[World Happiness DB table]
(
[Country name]
)
Values
(1)

SELECT * FROM ssis_sample.[World Happiness DB table]



--5 po uzyciu data flow task

SELECT * FROM ssis_sample.[World Happiness DB table]



-------------------------------------------------------------------
--6 tworzenie tabeli stangingowa / zmieniamy tylko typy
-- sckryotujemy landing (script table as CREATE TO - ctrl F itp dla ulatwienia


/****** Object:  Table [ssis_sample].[World Happiness DB table]    Script Date: 09.09.2021 09:51:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ssis_sample].[Staging World Happiness DB table](
	[Country name] [varchar](50) NULL,
	[Regional indicator] [varchar](50) NULL,
	[Ladder score] DECIMAL (6, 3),
	[Standard error of ladder score] DECIMAL (6, 3),
	[upperwhisker] DECIMAL (6, 3),
	[lowerwhisker] DECIMAL (6, 3),
	[Logged GDP per capita] DECIMAL (6, 3),
	[Social support] DECIMAL (6, 3),
	[Healthy life expectancy] DECIMAL (6, 3),
	[Freedom to make life choices] DECIMAL (6, 3),
	[Generosity] DECIMAL (6, 3),
	[Perceptions of corruption] DECIMAL (6, 3),
	[Ladder score in Dystopia] DECIMAL (6, 3),
	[Explained by Log GDP per capita] DECIMAL (6, 3),
	[Explained by Social support] DECIMAL (6, 3),
	[Explained by Healthy life expectancy] DECIMAL (6, 3),
	[Explained by Freedom to make life choices] DECIMAL (6, 3),
	[Explained by Generosity] DECIMAL (6, 3),
	[Explained by Perceptions of corruption] DECIMAL (6, 3),
	[Dystopia + residual] DECIMAL (6, 3)
) ON [PRIMARY]
GO


-- 7 procedura 

CREATE OR ALTER PROCEDURE ssis_sample.LS_FactWorldHappiness AS
BEGIN TRY
	BEGIN TRANSACTION
		TRUNCATE TABLE [ssis_sample].[Staging World Happiness DB table];

		INSERT INTO [ssis_sample].[Staging World Happiness DB table]
		(
		  [Country name]
		, [Regional indicator]
		, [Ladder score] 
		, [Standard error of ladder score] 
		, [upperwhisker] 
		, [lowerwhisker] 
		, [Logged GDP per capita] 
		, [Social support] 
		, [Healthy life expectancy] 
		, [Freedom to make life choices] 
		, [Generosity] 
		, [Perceptions of corruption] 
		, [Ladder score in Dystopia] 
		, [Explained by Log GDP per capita] 
		, [Explained by Social support] 
		, [Explained by Healthy life expectancy] 
		, [Explained by Freedom to make life choices] 
		, [Explained by Generosity] 
		, [Explained by Perceptions of corruption] 
		, [Dystopia + residual]
		)
		SELECT
		  [Country name]
		, [Regional indicator]
		, CAST([Ladder score] AS DECIMAL(6,3))
		, CAST([Standard error of ladder score] AS DECIMAL(6,3))
		, CAST([upperwhisker] AS DECIMAL(6,3))
		, CAST([lowerwhisker] AS DECIMAL(6,3))
		, CAST([Logged GDP per capita] AS DECIMAL(6,3))
		, CAST([Social support] AS DECIMAL(6,3))
		, CAST([Healthy life expectancy] AS DECIMAL(6,3))
		, CAST([Freedom to make life choices] AS DECIMAL(6,3))
		, CAST([Generosity] AS DECIMAL(6,3))
		, CAST([Perceptions of corruption] AS DECIMAL(6,3))
		, CAST([Ladder score in Dystopia] AS DECIMAL(6,3))
		, CAST([Explained by Log GDP per capita] AS DECIMAL(6,3))
		, CAST([Explained by Social support] AS DECIMAL(6,3))
		, CAST([Explained by Healthy life expectancy] AS DECIMAL(6,3))
		, CAST([Explained by Freedom to make life choices] AS DECIMAL(6,3))
		, CAST([Explained by Generosity] AS DECIMAL(6,3))
		, CAST([Explained by Perceptions of corruption] AS DECIMAL(6,3))
		, CAST([Dystopia + residual] AS DECIMAL(6,3))
		FROM [ssis_sample].[World Happiness DB table]
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH

--7.1 odpalenie 
EXEC ssis_sample.LS_FactWorldHappiness

-- 7.2 zaladowanie
SELECT * FROM [ssis_sample].[Staging World Happiness DB table]

SELECT * FROM [ssis_sample].[World Happiness DB table]




---- 7.3
-- sp[rawadzamy czy proces SSIS dziala czysczac staging
TRUNCATE TABLE [ssis_sample].[Staging World Happiness DB table]

SELECT * FROM [ssis_sample].[Staging World Happiness DB table]
-- ma byc pusty

-- a teraz w VisualStudio odpalamy to i ma byc zapelniona


SELECT * FROM [ssis_sample].[Staging World Happiness DB table]

--------------------------------------------------------------------------------------------------------


-- 8 Tworzymy Dim RegionalInd
--
--PK RegionalID
--RegionalIndecitaro

CREATE TABLE ssis_sample.DimRegionalIndicator
(
RegionalIndicatorId INT IDENTITY(1,1),
RegionalIndicator NVARCHAR(50),
CONSTRAINT PK_DimRegionalIndicator_RegionalIndicatorId PRIMARY KEY CLUSTERED --klucz glowny klastrowany
(
RegionalIndicatorId ASC  --posortowany
),
CONSTRAINT UK_DimRegionalIndicator_RegionalIndicator UNIQUE --wartosci nie moga sie powatrzaC
(
RegionalIndicator
)

)

-- 8.1 procedura ladujaca tabele
-- fota
-- wpierw selektujemy wartosci - fota
-- tabela tymczasowa - fota trzyma unikatowe wartosci of regional indicator from staging
-- chcemy cos zainsertowac - fota


CREATE OR ALTER PROCEDURE ssis_sample.LD_DimRegionalIndicator AS

BEGIN TRY
    BEGIN TRANSACTION

        --CREATE TEMPORARY TABLE WHICH HOLDS THE DISTINCT VALUES OF RegionalIndicator FROM STAGING
        SELECT DISTINCT
            [Regional Indicator]
        INTO 
            #tmpDim
        FROM
            [ssis_sample].[Staging World Happiness DB table]


        INSERT INTO ssis_sample.DimRegionalIndicator (RegionalIndicator)
        SELECT
            [Regional Indicator]
        FROM #tmpDim

        EXCEPT

        SELECT [RegionalIndicator]
        FROM
        [ssis_sample].[DimRegionalIndicator]

        DROP TABLE #tmpDim
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT ERROR_MESSAGE();
END CATCH

-- odpalamy proc
EXEC [ssis_sample].[LD_DimRegionalIndicator]
-- sprawdzamy
SELECT * FROM [ssis_sample].[DimRegionalIndicator]


-- przechodzimy SSIS i budujemy kolejny cykl FOTA jak git to zielono bedzie

/*
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
 9. TWORZENIE TABELI COUNTRY
DIM COUNTRY
PK CountryId
   Country Name
FK RegionalIndicatorId i tam dopisac na dole foreigin key, references (do dokad odwoluje sie) nazwa tabeli(i nazwa kolumny do ktorej sie odwoluje)
(CONSTRAINT nie robiony poniewaz zdefiniowalsimy obok nazwy czy cos tam)
*/

CREATE TABLE ssis_sample.DimCountry
(
	CountryId INT IDENTITY(1,1),
	CountryName NVARCHAR(50),
	RegionalIndicatorId INT FOREIGN KEY REFERENCES ssis_sample.DimRegionalIndicator(RegionalIndicatorId),
	CONSTRAINT PK_DimCountry_CountryId PRIMARY KEY CLUSTERED
	(
	CountryId ASC
	),
	CONSTRAINT UK_DimCountry_CountryName UNIQUE
	(
	CountryName
	)
)


-- PISANIE PROC
/* co chcemy zrobic na poczatek
SELECT DISTINCT
	CountryName
FROM
[ssis_sample].[Staging World Happiness DB table]
############### dodajemy joina
SELECT DISTINCT
	stg.[Country Name],
	stg.[Regional Indicator], -- to se mozna usunac
	reg.RegionalIndicatorId
FROM
[ssis_sample].[Staging World Happiness DB table] stg
JOIN
[ssis_sample].[DimRegionalIndicator] reg
ON stg.[Regional Indicator] = reg.[RegionalIndicator]

FOTA

tworzymy tab tym i dodajemy wartosci



*/

CREATE OR ALTER PROCEDURE ssis_sample.LD_DimCountry AS

BEGIN TRY
    BEGIN TRANSACTION
		
		SELECT DISTINCT
			stg.[Country Name],
			reg.RegionalIndicatorId
		
		INTO
			#tmpDim

		FROM
			[ssis_sample].[Staging World Happiness DB table] stg
		JOIN
			[ssis_sample].[DimRegionalIndicator] reg
			ON stg.[Regional Indicator] = reg.[RegionalIndicator]

		INSERT INTO ssis_sample.DimCountry(CountryName, RegionalIndicatorId)
		SELECT
			[Country name],
			RegionalIndicatorId
		FROM
			#tmpDim
		EXCEPT
		SELECT
			CountryName,
			RegionalIndicatorId
		FROM ssis_sample.DimCountry

		DROP TABLE #tmpDim
        
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT ERROR_MESSAGE();
END CATCH

-- sprawdzamy czy dziala procedura

EXEC ssis_sample.LD_DimCountry

-- dziala select
SELECT * FROM ssis_sample.DimCountry

--- w SSIS ROBIMY KOLEJNY KROK

-------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- 10
-- zaladowanie Finalnej Tabeli glownej faktowej oraz stworzenie jej


CREATE TABLE ssis_sample.FactWorldHappiness
(
	  Id INT IDENTITY(1,1)
	, CountryId INT FOREIGN KEY REFERENCES ssis_sample.DimCountry(CountryId)
	, Year INT
	, [Ladderscore] DECIMAL (6,3)
    , [StandardErrorOfLadderScore]DECIMAL (6,3) 
    , [Upperwhisker] DECIMAL (6,3)
    , [Lowerwhisker] DECIMAL (6,3)
    , [LoggedGDPPerCapita] DECIMAL (6,3)
    , [SocialSupport] DECIMAL (6,3)
    , [HealthyLifeExpectancy] DECIMAL (6,3)
    , [FreedomToMakeLifechoices] DECIMAL (6,3)
    , [Generosity] DECIMAL (6,3)
    , [PerceptionsOfCorruption] DECIMAL (6,3)
    , [LadderScoreInDystopia] DECIMAL (6,3)
    , [ExplainedbyLogGDPPerCapita] DECIMAL (6,3)
    , [ExplainedbySocialSupport] DECIMAL (6,3)
    , [ExplainedbyHealthyLifeExpectancy] DECIMAL (6,3)
    , [ExplainedbyFreedomToMakeLifeChoices] DECIMAL (6,3)
    , [ExplainedbyGenerosity] DECIMAL (6,3)
    , [ExplainedbyPerceptionsOfCorruption] DECIMAL (6,3)
    , [DystopiaResidual] DECIMAL (6,3)
	, CONSTRAINT PK_FactWorldHappiness_Id PRIMARY KEY CLUSTERED
	(
	Id ASC
	)
)
----------------------------------------------------------------------------------------------------------------------
-- 11 procedura ladujaca dane
-- mozemy truncetowac tabele faktowa - szkielet fota
-- dodajemy inserta fota
-- przykladowy select co mamy dac i dodajemy zaawansowanego co dodajemy FOTA
/*
SELECT
	YEAR(CURRENT_TIMESTAMP) AS Year,
	cntry.CountryId

FROM
	[ssis_sample].[Staging World Happiness DB table] stg
JOIN
	ssis_sample.DimCountry cntry
ON cntry.CountryName = stg.[Country Name]
-- p[otem select i exec
*/

CREATE OR ALTER PROCEDURE ssis_sample.LF_FactWorldHappiness
AS
BEGIN TRY
	BEGIN TRANSACTION

		TRUNCATE TABLE [ssis_sample].[FactWorldHappiness]
	
		INSERT INTO [ssis_sample].[FactWorldHappiness]
		(
			  [Year]
			, [CountryId]
			, [Ladderscore]
			, [StandardErrorOfLadderScore]
			, [Upperwhisker]
			, [Lowerwhisker]
			, [LoggedGDPPerCapita]
			, [SocialSupport]
			, [HealthyLifeExpectancy]
			, [FreedomToMakeLifechoices]
			, [Generosity]
			, [PerceptionsOfCorruption]
			, [LadderScoreInDystopia]
			, [ExplainedbyLogGDPPerCapita]
			, [ExplainedbySocialSupport]
			, [ExplainedbyHealthyLifeExpectancy]
			, [ExplainedbyFreedomToMakeLifeChoices]
			, [ExplainedbyGenerosity]
			, [ExplainedbyPerceptionsOfCorruption]
			, [DystopiaResidual]
		)
		SELECT 
          YEAR(CURRENT_TIMESTAMP) AS Year
        , cntry.CountryId
        , stg.[Ladder score]
        , stg.[Standard error of ladder score]
        , stg.[upperwhisker]
        , stg.[lowerwhisker]
        , stg.[Logged GDP per capita]
        , stg.[Social support]
        , stg.[Healthy life expectancy]
        , stg.[Freedom to make life choices]
        , stg.[Generosity]
        , stg.[Perceptions of corruption]
        , stg.[Ladder score in Dystopia]
        , stg.[Explained by Log GDP per capita]
        , stg.[Explained by Social support]
        , stg.[Explained by Healthy life expectancy]
        , stg.[Explained by Freedom to make life choices]
        , stg.[Explained by Generosity]
        , stg.[Explained by Perceptions of corruption]
        , stg.[Dystopia + residual]
        FROM
          [ssis_sample].[Staging World Happiness DB table] stg
        JOIN
			ssis_sample.DimCountry cntry
			ON cntry.CountryName = stg.[Country Name]
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT ERROR_MESSAGE();
END CATCH


SELECT * FROM [ssis_sample].[FactWorldHappiness] 

EXEC [ssis_sample].[LF_FactWorldHappiness]


-- SSIS dolaczamy loada FOTA
-----------------------------------------

-----------------------------------------
-----------------------------------------
-----------------------------------------
-- 12 NIby usuwamy wszystkie dane i sprawdzamy SSIS czy wszystkod dziala



-- 13 TWORZENIE WIDOKU DO UZYWANIA DANYCH z tabel wymiarowych

CREATE OR ALTER VIEW ssis_sample.vw_FactWorldHappiness AS
SELECT
	cntry.CountryName
	,reg.RegionalIndicator
	,fct.[Year]
    ,fct.[Ladderscore]
    ,fct.[StandardErrorOfLadderScore]
    ,fct.[Upperwhisker]
    ,fct.[Lowerwhisker]
    ,fct.[LoggedGDPPerCapita]
    ,fct.[SocialSupport]
    ,fct.[HealthyLifeExpectancy]
    ,fct.[FreedomToMakeLifechoices]
    ,fct.[Generosity]
    ,fct.[PerceptionsOfCorruption]
    ,fct.[LadderScoreInDystopia]
    ,fct.[ExplainedbyLogGDPPerCapita]
    ,fct.[ExplainedbySocialSupport]
    ,fct.[ExplainedbyHealthyLifeExpectancy]
    ,fct.[ExplainedbyFreedomToMakeLifeChoices]
    ,fct.[ExplainedbyGenerosity]
    ,fct.[ExplainedbyPerceptionsOfCorruption]
    ,fct.[DystopiaResidual]

FROM
[ssis_sample].[FactWorldHappiness] fct
JOIN
[ssis_sample].[DimCountry] cntry
ON cntry.CountryId = fct.CountryId
JOIN
[ssis_sample].[DimRegionalIndicator] reg
ON
cntry.RegionalIndicatorId = reg.RegionalIndicatorId

SELECT * FROM ssis_sample.vw_FactWorldHappiness
-- z widoku wywalamy Id i CountryId i zastepujemy country name i regionalIndicator










