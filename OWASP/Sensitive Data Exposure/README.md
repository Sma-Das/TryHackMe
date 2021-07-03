# Sensitive Data Exposure Task

Used crackstation and sqlite to gain the username and password of the admin

### SQL commands used:
    > `.tables` shows what tables are in the database
    > `PRAGMA table_info(table_name)` shows the summary columns for the table
    > `SELECT username, password FROM users WHERE admin=1` for the username and pasword of the admin accounts`
