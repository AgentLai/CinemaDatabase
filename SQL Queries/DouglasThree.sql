CLEAR SCREEN

ACCEPT selected_state PROMPT 'Enter State Name: '
ACCEPT selected_year PROMPT 'Enter Year (YYYY): '

SET LINESIZE 300
SET PAGESIZE 100
SET VERIFY OFF

TTITLE LEFT SKIP 2 - 
'                                               Detailed Report on Movie Tickets Sold in &selected_state for &selected_year  '

COLUMN TicketsSold HEADING 'Tickets Sold' FORMAT 99999
COLUMN Revenue HEADING 'Revenue' FORMAT $999,999.99
COLUMN MovieName HEADING 'Movie Name' FORMAT A40
COLUMN Genre HEADING 'Genre' FORMAT A40
COLUMN RatingType HEADING 'Rating Type' FORMAT A5
COLUMN Language HEADING 'Language' FORMAT A15
COLUMN Duration HEADING 'Duration' FORMAT A20

COLUMN Temporary NOPRINT
COMPUTE SUM OF "Tickets Sold" ON Temporary
COMPUTE SUM OF "Revenue" ON Temporary
BREAK ON Temporary

SELECT
NULL Temporary,
    m.MovieName,
    m.Genre,
    m.RatingType,
    m.MovieLanguage AS "Language",
    m.Duration,
    COUNT(t.TicketId) AS "Tickets Sold",
    SUM(t.Price) AS "Revenue"
FROM Ticket t
JOIN Showing sh ON t.ShowingId = sh.ShowingId
JOIN Movie m ON sh.MovieId = m.MovieId
JOIN Hall h ON sh.HallId = h.HallId
JOIN Cinema c ON h.CinemaId = c.CinemaId
JOIN City ci ON c.CityId = ci.CityId
JOIN State s ON ci.StateId = s.StateId
WHERE UPPER(s.StateName) = UPPER('&selected_state')
AND EXTRACT(YEAR FROM sh.MovieDate) = &selected_year
GROUP BY m.MovieName, m.Genre, m.RatingType, m.MovieLanguage, m.Duration
ORDER BY COUNT(t.TicketId) DESC;

SET PAGESIZE 1000;