Here's a README.md for your script:

```markdown
# WordPress Backup Script for aaPanel

This script is designed to make it easier to back up WordPress websites hosted on aaPanel without the need for the aaPanel premium plan. It performs a full backup of the WordPress site, including a tarball of the website files and an optional SQL dump of the WordPress database.

## Features

- Backs up WordPress files (`tar.gz` format).
- Optionally backs up the WordPress database (`mysqldump`).
- Allows skipping the database backup using the `--ignoredb` flag.
- Compatible with aaPanel hosted sites.
- Can be run from the command line.

## Requirements

- **SSH Access**: The script requires SSH access to the server.
- **SSH Key**: You must provide the path to an SSH private key for authentication.
- **mysqldump**: MySQL client tool (`mysqldump`) is required for database backups.
- **tar**: The `tar` command is used to create compressed backups of the website files.
- **Linux or Mac**: This script is designed to work on Unix-based systems.

## Installation

1. Clone or download the repository containing the script to your local machine or server.
2. Ensure the script is executable by running:
   ```bash
   chmod +x backup.sh
   ```

3. Place your SSH private key (e.g., `ssh.key`) in the appropriate directory (`~/.ssh/` or another location) and ensure its permissions are set correctly.

4. Make sure the server is accessible with SSH and that you can log in as `root` or another user with the necessary permissions.

## Usage

To back up the website, run the following command:

```bash
./backup.sh
```

You will be prompted to enter the **folder name** for the WordPress site on the server. The backup will include both website files and the database dump (SQL file).

### Skip Database Backup

If you don't want to back up the WordPress database, use the `--ignoredb` flag:

```bash
./backup.sh --ignoredb
```

This will skip the database backup and only back up the website files.

## Script Flow

1. The script asks for the folder name of the WordPress website to back up.
2. It checks whether the folder exists on the server.
3. If `--ignoredb` is not passed, it finds the `wp-config.php` file in the folder and extracts the database credentials (database name, user, password).
4. The script then creates a SQL dump of the database using `mysqldump`.
5. The script compresses the website files into a `.tar.gz` archive.
6. Both the website files and the database dump (if not skipped) are downloaded to your local machine.

## Example Output

```bash
Enter the folder name: launch.baescientia.lk
Found wp-config.php at: /www/wwwroot/launch.baescientia.lk/wp-config.php
Database Name: example_db
Dumping database example_db...
Database dump created: /www/wwwroot/launch.baescientia.lk/launch-baescientia-lk-db-20250318-153000.sql
Backup created: /www/wwwroot/launch.baescientia.lk/launch-baescientia-lk-20250318-153000.tar.gz
Backup successfully downloaded to ./backups/launch.baescientia.lk/
```

## Customization

You can customize the following variables in the script:

- **SSH_KEY**: Path to your SSH private key.
- **SSH_USER**: Username for SSH login (default is `root`).
- **SSH_HOST**: The IP address or hostname of the server hosting your WordPress site.
- **DEFAULT_DIR**: The root directory where your WordPress sites are located (default is `/www/wwwroot`).
- **LOCAL_BACKUP_DIR**: Local directory where the backups will be stored (default is `./backups`).

## Troubleshooting

- **"wp-config.php not found!"**: Ensure the folder you entered is correct and that `wp-config.php` exists in the specified directory.
- **"Error downloading file"**: Make sure your SSH credentials are correct, and the remote server is accessible.

## License

This script is open-source and free to use. It is provided as-is with no warranty. You are free to modify and use the script as per your needs.

---

By using this script, you can efficiently back up your WordPress sites on aaPanel without the need for a premium plan. Happy backing up!
```

### Key sections:

- **Usage instructions**: How to run the script and use the `--ignoredb` flag.
- **Flow and customizations**: Overview of how the script works and what parts can be customized.
- **Troubleshooting**: Helps users fix common issues they may encounter while running the script.

Let me know if you want any more changes!