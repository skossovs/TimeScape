DECLARE @newYear Date
SET @newYear = '20160101'

;WITH allDates as (
	SELECT 	n-1 as day_id
	,		DateAdd(day, n-1, @newYear) as today
	FROM dbo.ufnSequencialNumbersTable (dbo.ufnNumberOfDaysInYear(Year(@newYear)))
)
, skipDays as (
	SELECT today as skipDay
	FROM   allDates
	WHERE  datepart(dw, today) in (1,7)
	UNION
	SELECT Date as skipDay
	FROM   Holidays
)
, precalc_shifts as (
	SELECT a.day_id
	,		a.today
	,	   (CASE WHEN s.skipDay is NULL THEN 0 ELSE 1 END) as single_shift
	FROM allDates a
	LEFT JOIN skipDays s ON a.today = s.skipDay
)
, shifts as (
	SELECT a.day_id
	,	a.today as today
	,	SUM(b.single_shift) as shift
	FROM precalc_shifts a
	INNER JOIN precalc_shifts b ON
		b.day_id <= a.day_id
	GROUP BY a.day_id, a.today
)
, pre_calc as (
	SELECT allDates.today, noHD.businessDate
	,	bd_count = ROW_NUMBER() OVER (PARTITION BY allDates.today ORDER BY noHD.businessDate)
	,	today_bucket = ROW_NUMBER() OVER (PARTITION BY noHD.businessDate ORDER BY allDates.today)
	,	sh.shift
	FROM allDates
	CROSS JOIN (
		SELECT allDates.today businessDate
		FROM   allDates
		EXCEPT SELECT skipDay as businessDate FROM skipDays h
	) noHD
	INNER JOIN shifts sh ON
		sh.day_id = allDates.day_id
)
INSERT INTO DateDim(id, Today, BusinessDate, [Index])
SELECT CONVERT(bigint, CONVERT(varchar(8), today, 112) + CONVERT(varchar(8), businessDate, 112))
,		today
,		businessDate
,		shift + bd_count - today_bucket
FROM    pre_calc
ORDER BY today, businessDate