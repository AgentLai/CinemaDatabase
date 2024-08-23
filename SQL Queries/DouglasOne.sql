CLEAR SCREEN

ACCEPT selected_state PROMPT 'Enter State Name: '
ACCEPT selected_year CHAR PROMPT 'Enter Year (YYYY): '

SET LINESIZE 200
SET PAGESIZE 100
SET VERIFY OFF

TTITLE LEFT SKIP 2 -
 '      Summary Report of Revenue for Booking Halls in &selected_state - &selected_year'

COLUMN TotalRevenue HEADING 'Total Revenue' FORMAT $999,999,999.99
COLUMN CinemaId HEADING 'Cinema ID' FORMAT 9999
COLUMN CityName HEADING 'City' FORMAT A40

COMPUTE SUM LABEL '' OF "TotalRevenue" ON REPORT
BREAK ON REPORT

SELECT c.CinemaId, ci.CityName, SUM(NVL(rt.RentalRate, 0)) AS "TotalRevenue"
FROM Cinema c
JOIN City ci ON c.CityId = ci.CityId
JOIN State s ON ci.StateId = s.StateId
LEFT JOIN Hall h ON c.CinemaId = h.CinemaId
LEFT JOIN Hosting ho ON h.HallId = ho.HallId
LEFT JOIN RentalType rt ON h.RentalId = rt.RentalId
LEFT JOIN Cancellation ca ON ho.HostingId = ca.HostingId
WHERE UPPER(s.StateName) = UPPER('&selected_state')
  AND EXTRACT(YEAR FROM ho.EventDate) = '&selected_year'
  AND (ca.HostingId IS NULL OR ca.Reason IS NULL)
GROUP BY c.CinemaId, ci.CityName
ORDER BY SUM(NVL(rt.RentalRate, 0)) DESC;

SET PAGESIZE 1000;
