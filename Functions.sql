CREATE FUNCTION ufnNumberOfDaysInYear(@year int)
RETURNS INT
AS
BEGIN
	DECLARE @days INT;
	SELECT @days = CASE WHEN (@year % 4 = 0 AND @year % 100 <> 0) OR @year % 400 = 0 
						THEN 366 
						ELSE 365 
					END;
	RETURN @days;
END

GO

CREATE FUNCTION ufnSequencialNumbersTable (@max int)
RETURNS @numbers Table (n int)
AS
BEGIN
	;WITH n(n) AS
	(
		SELECT 1
		UNION ALL
		SELECT n + 1 FROM n WHERE n < @max
	)
	-- set limit for recursion to be 1000
	INSERT INTO @numbers(n) 
	SELECT n FROM n ORDER BY n OPTION (MAXRECURSION 1000)
	RETURN

END
GO

-- TEST:
-- select * from dbo.ufnSequencialNumbersTable (dbo.ufnNumberOfDaysInYear(2016))