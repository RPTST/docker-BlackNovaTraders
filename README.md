# docker-BlackNovaTraders
BlackNova Traders Docker (unteated)
This is a test to create a docker install of BlackNova Traders.

BlackNova Traders

REQUIREMENTS

- PHP version 5.3 minimum is required. (For Smarty, crypt for login, and many other features)
- MySQL version 5.5 is supported, we have not determined a required minimum.
- Apache version 2.2.20+ is supported, we have not determined a required minimum.

INSTALLATION

1. create the Docker image

2, Open the file <www.your-host>/<install-dir>/setup_info.php in your browser. This
   file will help you understand what settings you should use in your db_config.php file.
   
3. Edit the db_config.php file to your own settings

4. Create the database:
   mysqladmin -uuser -ppass create dbname

5. Open the file <www.your-host>/<install-dir>/create_universe.php in
   your browser.  You'll need to enter your admin password to access this
   page.  Change the settings to suit the universe you'd like to create -
   and go for it.

6. Open the file <www.your-host>/<install-dir>/index.php in your browser
   - you should now be able to log-in.

7. chmod 000 setup_info.php - it contains information that might be a security risk.

8. If you'd like additional security, we have included .htaccess files for some protection.
   Some systems do not ship with .htaccess enabled. You'll need to edit your Apache config 
   (either httpd.conf or the correct file for your host/directory), and set it to AllowOverrides Limits
   (it is often set to AllowOverrides None). Don't forget to reload Apache's config if you make this change.

9. Hopefully - it works now. :)
