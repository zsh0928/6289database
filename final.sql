CREATE DATABASE covid19; 
USE covid19;

CREATE TABLE test (
  test_date date NOT NULL,
  county varchar(50) NOT NULL,
  new_positive int(10) NOT NULL,
  total_positive int(10) NOT NULL,
  new_test int(10) NOT NULL,
  total_test int(10) NOT NULL,
  daily_rate decimal(3,2) NOT NULL, 	
  PRIMARY KEY (test_date, county)
);

CREATE TABLE death (
  report_date date NOT NULL,
  county varchar(50) NOT NULL,
  fatality int(10) NOT NULL, 
  PRIMARY KEY (report_date, county)
);

CREATE TABLE foodstore (
  county varchar(50) NOT NULL,
  license_id int(10) NOT NULL,
  entity_name varchar(50) NOT NULL,
  DBA_name varchar(50) DEFAULT NULL,
  street_num varchar(50) DEFAULT NULL,
  street_name varchar(50) NOT NULL,
  zipcode int(10) NOT NULL,
  square_footage int(10) NOT NULL,
  PRIMARY KEY (license_id)
);

CREATE TABLE hospital (
  report_date date NOT NULL,
  facility_PFI int(10) NOT NULL,
  facility_name varchar(100) NOT NULL,
  county varchar(50) NOT NULL,
  staffed_beds int(10) NOT NULL,
  staffed_ICU_beds int(10) NOT NULL,	
  PRIMARY KEY (report_date, facility_PFI)
);

CREATE TABLE vaccination (
  county varchar(50) NOT NULL,
  first_dose int(10) NOT NULL,
  series_complete int(10) NOT NULL,
  report_date date NOT NULL,
  PRIMARY KEY (county, report_date)
);

select * from foodstore
where county='Tompkins';

select county,SUM(license_id)
from foodstore
GROUP BY county
ORDER by county;

select county,series_complete
from vaccination
where report_date='2022-11-20';


select f.county,SUM(license_id),t.total_positive
from foodstore f,test t
where f.county=t.county AND t.test_date='2022-11-29'
group by county;

DELETE FROM test
WHERE county in ('Capital Region', 'Central New York', 'Finger Lakes', 'Long Island',
				'Mid-Hudson', 'Mohawk Valley', 'New York City', 'North Country', 'Southern Tier',
                'STATEWIDE', 'Western New York');

DELETE FROM test
WHERE county in ('Capital Region', 'Central New York', 'Finger Lakes', 'Long Island',
				'Mid-Hudson', 'Mohawk Valley', 'New York City', 'North Country', 'Southern Tier',
                'STATEWIDE', 'Western New York');
                
DELETE FROM death
WHERE county in ('Non-NYS', 'Statewide Total');

UPDATE death
SET county = 'New York'
WHERE county = 'Manhattan';
                
select * from death
where report_date='2022-11-29'
order by fatality;

select * from test t, death d where t.test_date=d.report_date AND t.county=d.county AND test_date = "2022-11-29";

select county, count(license_id) from foodstore
group by county;

select t.county, total_positive/total_test, count(license_id) 
from test t, foodstore f 
where test_date="2022-11-29" and t.county=f.county
group by f.county;

select * from vaccination where report_date="2022-11-29";

select t.county, total_positive, first_dose, series_complete from test t, vaccination v
where t.county=v.county and t.test_date=v.report_date and test_date="2022-11-29";


select d.county, fatality, AVG(staffed_beds), AVG(staffed_ICU_beds) from death d, hospital h
where d.county=h.county and d.report_date="2022-11-29"
group by h.county;