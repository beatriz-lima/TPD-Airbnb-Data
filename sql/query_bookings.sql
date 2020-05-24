CREATE OR REPLACE FUNCTION query_bookings ()
RETURNS TABLE(season integer, count bigint) AS $$
BEGIN
	RETURN QUERY SELECT date_id, COUNT(*)
	FROM booking 
	GROUP BY date_id
	ORDER BY count DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * from query_bookings ();
