CLEAR SCREEN

ACCEPT selected_state PROMPT 'Enter State Name: '
ACCEPT selected_year CHAR PROMPT 'Enter Year (YYYY): '

SET LINESIZE 200
SET PAGESIZE 100
SET VERIFY OFF

TTITLE CENTER 'Top 5 Cinemas in &selected_state - Yearly Food Revenue' SKIP 2

COLUMN TotalEarnings HEADING 'Revenue' FORMAT $999,999.99
COLUMN CinemaId HEADING 'Cinema ID' FORMAT 9999
COLUMN CityName HEADING 'City' FORMAT A40

BREAK ON CityName SKIP 1 ON CinemaId SKIP 1

SELECT TO_CHAR(TotalEarnings, '$999,999.99') AS "Revenue", CinemaId, CityName
FROM (
    SELECT 
        SUM(fo.Quantity * m.Price) AS TotalEarnings,
        c.CinemaId,
        ci.CityName
    FROM Menu m
    JOIN FoodOrder fo ON fo.MenuId = m.MenuId
    JOIN Customer cus ON fo.CustomerId = cus.CustomerId
    JOIN Ticket t ON t.CustomerId = cus.CustomerId
    JOIN Showing sh ON t.ShowingId = sh.ShowingId
    JOIN Hall h ON sh.HallId = h.HallId
    JOIN Cinema c ON h.CinemaId = c.CinemaId
    JOIN City ci ON c.CityId = ci.CityId
    JOIN State s ON ci.StateId = s.StateId
    WHERE UPPER(s.StateName) = UPPER('&selected_state')
    AND EXTRACT(YEAR FROM sh.MovieDate) = '&selected_year'
    GROUP BY c.CinemaId, ci.CityName
    ORDER BY TotalEarnings DESC
) WHERE ROWNUM <= 5;

SET PAGESIZE 1000 

TTITLE CENTER 'Bottom 5 Cinemas in &selected_state - Yearly Food Revenue' SKIP 2

SELECT TO_CHAR(TotalEarnings, '$999,999.99') AS "Revenue", CinemaId, CityName
FROM (
    SELECT 
        SUM(fo.Quantity * m.Price) AS TotalEarnings,
        c.CinemaId,
        ci.CityName
    FROM Menu m
    JOIN FoodOrder fo ON fo.MenuId = m.MenuId
    JOIN Customer cus ON fo.CustomerId = cus.CustomerId
    JOIN Ticket t ON t.CustomerId = cus.CustomerId
    JOIN Showing sh ON t.ShowingId = sh.ShowingId
    JOIN Hall h ON sh.HallId = h.HallId
    JOIN Cinema c ON h.CinemaId = c.CinemaId
    JOIN City ci ON c.CityId = ci.CityId
    JOIN State s ON ci.StateId = s.StateId
    WHERE UPPER(s.StateName) = UPPER('&selected_state')
    AND EXTRACT(YEAR FROM sh.MovieDate) = '&selected_year'
    GROUP BY c.CinemaId, ci.CityName
    ORDER BY TotalEarnings ASC
) WHERE ROWNUM <= 5;
