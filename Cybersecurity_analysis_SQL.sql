
-- CYBERSECURITY ANALYSIS PROJECT 
-- Author: Mxolisi Dlamini
-- Description: SQL analysis with subqueries, window functions, and time-based insight


--Employee distribution by industry and role

SELECT u.role, o.industry, count(*) total_employees
FROM users u
JOIN organizations o
ON u.org_id = o.org_id
GROUP BY  u.role, o.industry
ORDER BY total_employees DESC


--What are the most frequent types of network events?

SELECT DISTINCT event_type, count(*) as total_events
FROM network_events
GROUP BY event_type
ORDER BY total_events DESC;


--Users with most login attempts

SELECT 
    l.user_id,
	u.role, 
	o.industry,
    COUNT(*) AS login_count 
FROM login_logs l
JOIN users u
ON l.user_id = u.user_id
	RIGHT JOIN organizations o
		ON o.org_id = u.org_id
GROUP BY l.user_id,u.role, o.industry
ORDER BY login_count desc;


--Which incident type has the most critical severity

SELECT  incident_type, severity, count(severity) as most_severe 
FROM security_incidents
WHERE severity= 'Critical' 
GROUP BY incident_type, severity
ORDER BY most_severe DESC


-- Top 5 most common IP addresses

SELECT 
    ip_address,
    COUNT(*) AS total_logins
FROM login_logs
GROUP BY ip_address
ORDER BY total_logins DESC
LIMIT 5;

-- Which country and industry are associated with the highest number of security incidents? 

SELECT DISTINCT 
    o.industry,
    si.incident_type,
	o.country,
    COUNT(si.incident_id) AS total_incidents
FROM organizations o
JOIN security_incidents si 
    ON o.org_id = si.org_id
GROUP BY  o.industry, si.incident_type, o.country
ORDER BY total_incidents DESC
LIMIT 10;


-- What are the most common types of security incidents?

SELECT DISTINCT incident_type, count(incident_type) as total_incidents 
FROM security_incidents
GROUP BY incident_type
ORDER BY total_incidents DESC


-- Industry with the most high severity of  unauthorized access incidents

SELECT  
    o.org_id,
    o.industry,
    COUNT(*) AS total_incidents
FROM organizations o
JOIN security_incidents s ON o.org_id = s.org_id
WHERE s.severity = 'High'
  AND s.incident_type = 'Unauthorized Access'
GROUP BY o.org_id, o.industry
ORDER BY total_incidents DESC;



-- Find out which system has the most malware alert

SELECT i.system_id,ne.event_type, count(*) as total_of_occurance
FROM incident_systems i
LEFT JOIN network_events ne
	ON i.system_id = ne.system_id
WHERE event_type = 'Malware Alert'
GROUP BY i.system_id, ne.event_type
ORDER BY  total_of_occurance DESC;


-- TOP 10 most targeted systems
SELECT 
    s.system_id,
    COUNT(i.incident_id) AS incident_count
FROM systems s
JOIN incident_systems i ON s.system_id = i.system_id
GROUP BY s.system_id
ORDER BY incident_count DESC 
LIMIT 10;


-- Which events has the most critical events

SELECT DISTINCT event_type, severity, count(severity) as total_events
FROM network_events
WHERE severity = 'Critical'
GROUP BY event_type, severity
ORDER BY total_events DESC;


-- Find how many systems that did not have network incident

SELECT i.system_id, 
		count(*) as total_of_systems 
FROM incident_systems i
FULL JOIN network_events ne
	ON i.system_id = ne.system_id
WHERE i.system_id IS NULL
GROUP BY i.system_id;


-- Which systems experience the most serious (critical) incidents? 

SELECT i.incident_id ,i.system_id, ne.event_type, ne.severity, count(ne.severity) as number_of_incidents
FROM incident_systems i
JOIN network_events ne
	ON i.system_id = ne.system_id
	WHERE severity = 'Critical'
GROUP BY ne.event_type, i.incident_id, i.system_id, ne.severity
ORDER BY number_of_incidents DESC
LIMIT 5;


-- Which systems is most severe when accessing file?


SELECT i.incident_id ,i.system_id, ne.event_type, ne.severity, count(incident_id) as number_of_incidents
FROM incident_systems i
JOIN network_events ne
	ON i.system_id = ne.system_id
WHERE event_type = 'File Access' and severity = 'Critical'
GROUP BY ne.event_type, i.incident_id, i.system_id, ne.severity
ORDER BY number_of_incidents DESC
LIMIT 15;


-- Systems with more than one incident 

SELECT 
    system_id,
    COUNT(*) AS incident_count
FROM incident_systems
GROUP BY system_id
HAVING COUNT(*) > 1
ORDER BY incident_count DESC;


-- Monthly incident trends
SELECT 
    DATE_TRUNC('month', discovered_date) AS month,
    COUNT(*) AS total_incidents
FROM security_incidents
GROUP BY month
ORDER BY month;


-- Incident severity trends over time
SELECT 
    DATE_TRUNC('month', discovered_date) AS month,
    severity,
    COUNT(*) AS total_incidents
FROM security_incidents
GROUP BY month, severity
ORDER BY month;


--Find out failed login attempt for each country per industry

DROP TABLE IF EXISTS industry_logs;
CREATE TABLE industry_logs
AS SELECT DISTINCT
 		 o.country, o.industry, l.status, count(l.status) AS total_counts
FROM login_logs l
RIGHT JOIN users u
		ON l.user_id = u.user_id
LEFT JOIN organizations o
		ON  u.org_id = o.org_id
WHERE status = 'Failed' 
GROUP BY o.country, o.industry, l.status
ORDER BY total_counts DESC

SELECT * FROM industry_logs












