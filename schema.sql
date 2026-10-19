CREATE TABLE affiliation(hcp_id INTEGER PRIMARY KEY,hcp_name VARCHAR(20),region VARCHAR(20),specialty VARCHAR(40),rep VARCHAR(20));
CREATE TABLE sales(hcp_id INTEGER,month DATE,brand_rx INTEGER CHECK(brand_rx>=0),competitor_rx INTEGER CHECK(competitor_rx>=0),PRIMARY KEY(hcp_id,month),FOREIGN KEY(hcp_id) REFERENCES affiliation(hcp_id));
CREATE TABLE alerts(alert_id INTEGER PRIMARY KEY,hcp_id INTEGER,alert_date DATE,contacted INTEGER CHECK(contacted IN (0,1)),FOREIGN KEY(hcp_id) REFERENCES affiliation(hcp_id));
