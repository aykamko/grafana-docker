INSERT INTO data_source (org_id, version, type, name, access, url, password, user, database, basic_auth, is_default, created, updated)
VALUES (1, 0, influxdb, "<--DASH_NAME-->", "proxy", "<--PROTO-->://<--HOST-->:<--PORT-->", "<--PASS-->", "<--USER-->", "<--DB_NAME-->", 0, 1, (SELECT datetime('now')), (SELECT datetime('now')));
