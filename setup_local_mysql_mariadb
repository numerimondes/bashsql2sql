# Install MariaDB

1. **Update the system and install MariaDB**:
    ```bash
    sudo apt update
    sudo apt install mariadb-server
    ```

2. **Run the MariaDB secure installation script**:
    ```bash
    sudo mysql_secure_installation
    ```

    - **Enter current password for root**: Press **Enter** (if no password is set).
    - **Switch to unix_socket authentication**: Type **Y** and press Enter.
    - **Change the root password**: Type **n** to keep the current one.
    - **Remove anonymous users**: Type **y**.
    - **Disallow root login remotely**: Type **y**.
    - **Remove test database and access to it**: Type **n**.
    - **Reload privilege tables now?**: Type **y**.

---

# Set Root Password for MariaDB

1. **Login to MariaDB as root**:
    ```bash
    sudo mysql
    ```

2. **Set a new password for the root user**:
    ```sql
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
    FLUSH PRIVILEGES;
    exit;
    ```

    Replace `'newpassword'` with a secure password of your choice.

3. **Test MySQL root login**:
    ```bash
    mysql -u root -p
    ```

---

# Create a Database and User in MariaDB

1. **Login to MariaDB as root** (if not already logged in):
    ```bash
    mysql -u root -p
    ```

2. **Create the `numerimondes` database**:
    ```sql
    CREATE DATABASE numerimondes;
    ```

3. **Create the `greatmaster` user and grant privileges**:
    ```sql
    CREATE USER 'greatmaster'@'%' IDENTIFIED BY 'ton_mot_de_passe';
    GRANT ALL PRIVILEGES ON numerimondes.* TO 'greatmaster'@'%';
    FLUSH PRIVILEGES;
    ```

    - Replace `'ton_mot_de_passe'` with a secure password of your choice.
    - This allows `greatmaster` user full access to `numerimondes` database from any IP address.

4. **Verify the privileges of the `greatmaster` user**:
    ```sql
    SHOW GRANTS FOR 'greatmaster'@'%';
    ```

---

# Install phpMyAdmin

1. **Download phpMyAdmin**:
    ```bash
    wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
    wget -P Downloads https://files.phpmyadmin.net/phpmyadmin.keyring
    ```

2. **Import the keyring for verification**:
    ```bash
    cd Downloads
    gpg --import phpmyadmin.keyring
    wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc
    gpg --verify phpMyAdmin-latest-all-languages.tar.gz.asc
    ```

3. **Extract the phpMyAdmin files**:
    ```bash
    sudo mkdir /var/www/html/phpMyAdmin
    sudo tar xvf phpMyAdmin-latest-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpMyAdmin
    ```

4. **Copy the sample configuration file**:
    ```bash
    sudo cp /var/www/html/phpMyAdmin/config.sample.inc.php /var/www/html/phpMyAdmin/config.inc.php
    ```

5. **Edit the configuration file**:
    ```bash
    sudo nano /var/www/html/phpMyAdmin/config.inc.php
    ```

6. **Locate the following line**:
    ```php
    $cfg['blowfish_secret'] = '';
    ```

7. **Set a password in the `blowfish_secret` field** and then save and exit the file.

8. **Install necessary PHP packages**:
    ```bash
    sudo apt -y install php php-cgi php-mysqli php-pear php-mbstring libapache2-mod-php php-common php-phpseclib php-mysql
    ```

9. **Set the correct permissions**:
    ```bash
    sudo chmod 660 /var/www/html/phpMyAdmin/config.inc.php
    sudo chown -R www-data:www-data /var/www/html/phpMyAdmin
    ```

10. **Install Apache PHP module**:
    ```bash
    sudo apt-get install libapache2-mod-php8.1
    sudo a2enmod php8.1
    sudo systemctl restart apache2
    ```

11. **Access phpMyAdmin**:
    - Open your web browser and go to: `http://YOUR_VM_IP/phpMyAdmin`
