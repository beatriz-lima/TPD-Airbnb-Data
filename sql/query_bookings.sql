DROP FUNCTION query_bookings();
CREATE OR REPLACE FUNCTION query_bookings()
RETURNS TABLE(date_id integer, season varchar(10), count bigint, coastal varchar(20)) AS $$
BEGIN
	RETURN QUERY SELECT b.date_id, d.season, count(*), l.coastal_area
	FROM date d, booking b, location l
	WHERE b.date_id = d.date_id
	AND b.location_id = l.location_id
	AND l.coastal_area = 'Not Coastal Area'
	GROUP BY b.date_id, d.season, l.coastal_area
	ORDER BY count DESC
	LIMIT 50;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM query_bookings();