-- Normalized Customer Satisfaction
CREATE OR REPLACE FUNCTION normalized_cs()
RETURNS TABLE
            (
                id INT,
                normalized_cs NUMERIC
            )
AS $$
BEGIN
RETURN QUERY
    SELECT
    x.id, 1.00*(sample-min_metric)/range_metric
    FROM
        (
        SELECT
               cs.id,
               metric AS sample,
               MIN(metric) OVER () AS min_metric,
               MAX(metric) OVER () - MIN(metric) OVER () AS range_metric
        FROM
             (SELECT property.property_id as id, cs.score as metric
                FROM cs
                    INNER JOIN listings
                        ON cs.review_id = listings.review_id
                    INNER JOIN property
                        ON listings.property_id = property.property_id
                ) as cs
        ) x ;

END;
$$ LANGUAGE plpgsql;

-- Normalized Profit per Property
CREATE OR REPLACE FUNCTION normalized_profit()
RETURNS TABLE
            (
                id INT,
                normalized_profit NUMERIC
            )
AS $$
BEGIN
RETURN QUERY
    SELECT
    x.id, 1.00*(sample-min_metric)/range_metric as normalized_profit
    FROM
        (
        SELECT
               cs.id,
               metric AS sample,
               MIN(metric) OVER () AS min_metric,
               MAX(metric) OVER () - MIN(metric) OVER () AS range_metric
        FROM
             (SELECT p.id, AVG(rented_days * avg_price_per_night)/30 as metric
                FROM (
                     SELECT CAST(count(*) as NUMERIC) as rented_days, booking.property_id as id, AVG(booking.price_per_night) as avg_price_per_night
                     FROM booking
                              INNER JOIN date
                                         ON booking.date_id = date.date_id
                     GROUP BY property_id, month, year
                     ) as p
                GROUP BY p.id
             ) as cs
        ) x ;

END;
$$ LANGUAGE plpgsql;

-- Create View
DROP MATERIALIZED VIEW IF EXISTS metrics;
CREATE MATERIALIZED VIEW IF NOT EXISTS metrics AS
    SELECT normalized_cs.id, normalized_cs as cs, normalized_profit as profit, (normalized_cs + normalized_profit) as score
    FROM normalized_cs(), normalized_profit()
    WHERE normalized_cs.id = normalized_profit.id;

--TEST
SELECT * from metrics;

-- KPI's
-- Customer Satisfaction
select round(avg(cs) * 100, 2) as Customer_Satisfaction from metrics;
-- Monthly Profit Per Property
select round(avg(profit) * 100, 2) as Monthly_Profit_Per_Property from metrics;
-- Companies Performance
select round((avg(score)/2) * 100, 2) as Companies_Performance from metrics;

--Ranking Top 10 Properties
CREATE OR REPLACE FUNCTION topN(N int)
RETURNS TABLE
            (
                id INT,
                score NUMERIC,
                property_type_category VARCHAR,
                property_type VARCHAR,
                room_type VARCHAR,
                accommodates VARCHAR,
                bathrooms VARCHAR,
                bedrooms VARCHAR,
                beds VARCHAR,
                bed_type VARCHAR
            )
AS $$
BEGIN
RETURN QUERY
    SELECT metrics.id, metrics.score, property.property_type_category, property.property_type,
           property.room_type, property.accommodates, property.bathrooms, property.bedrooms,
           property.beds, property.bed_type
    FROM metrics
    INNER JOIN property
        ON metrics.id = property.property_id
    ORDER BY score desc
    LIMIT N;
END;
$$ LANGUAGE plpgsql;

-- TOP 10
SELECT * FROM topN(10);