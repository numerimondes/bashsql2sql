# Database Migration Script

This script is a Bash utility designed to migrate tables from a source MySQL database to a target MySQL database. It allows the user to interactively configure database connection details, choose a language (French or English), and securely manage credentials.

[![Database Migration Script Video](https://img.youtube.com/vi/XACP_yGrV48/0.jpg)](https://youtu.be/XACP_yGrV48)

*Click the image above to watch the video tutorial.*

## Features

- **Multi-language support**: Prompts are available in French and English.
- **Interactive configuration**: Automatically creates a configuration file (`config.txt`) based on user input.
- **Table-specific migration**: Retrieves a list of tables from the source database and migrates them individually.
- **Credential security**: Ensures credentials are deleted after usage by removing the configuration file.
- **Error handling**: Provides feedback for table migration success or failure.
- **Remote access warning**: Displays warnings about IP address authorization for remote database connections.

## Prerequisites

- **MySQL Client Tools**: `mysql` and `mysqldump` must be installed and available in your PATH.
- **Sudo privileges**: The script requires `sudo` access to execute commands securely.
- **Bash**: A Unix/Linux environment with Bash is required to run this script.

## Notes for Windows Users

This script is written in Bash (`.sh`) and is not natively compatible with Windows. However, it can still be executed on Windows using the following methods:

1. **Windows Subsystem for Linux (WSL)**:
   - Enable WSL on Windows.
   - Install a Linux distribution from the Microsoft Store (e.g., Ubuntu).
   - Open the Linux terminal and run the script as you would on a Linux machine.

2. **Git Bash**:
   - Install [Git for Windows](https://git-scm.com/) which includes Git Bash.
   - Open Git Bash and run the script.

3. **Cygwin**:
   - Install [Cygwin](https://www.cygwin.com/), a Linux-like environment for Windows.
   - Ensure `mysql` and `mysqldump` are available in the Cygwin environment.

4. **Docker**:
   - Create a Docker container with a Linux image and the necessary MySQL client tools installed.
   - Copy the script into the container and execute it.

## Installation

1. Clone the repository or copy the script to your local environment.
2. Ensure the script has execution permissions:
   ```bash
   chmod +x bashsql2sql.sh
