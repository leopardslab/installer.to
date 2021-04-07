# Download and Install the Latest Updates for the OS
apt-get update && apt-get upgrade -y

# Install essential packages
apt-get -y install zsh htop

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get -y install mysql-server-8.6

#This utility prompts you to define the mysql root password and other security-related options, including removing remote access to the root user and setting the root password.
mysql_secure_installation utility

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
ufw enable
ufw allow 22
ufw allow 3306

# Run the MySQL Secure Installation wizard
mysql_secure_installation

#start the mysql service 
systemctl start mysql
systemctl enable mysql

#configure interfaces
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf
mysql -uroot -p -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

#restarting the service mysql
service mysql restart

#running mysql 
/usr/bin/mysql -u root -p 
