
**Conditional Database Dump:** The database dump (`mysqldump`) and download of the SQL file are only performed if `--ignoredb` is not set.

### Usage:
- To run the backup with the database dump:
  ```bash
  ./backup.sh
  ```

- To run the backup without the database dump:
  ```bash
  ./backup.sh --ignoredb
  ```

This change ensures that the script no longer checks for or tries to back up the database when `--ignoredb` is passed.