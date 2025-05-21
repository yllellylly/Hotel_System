ALTER USER 'root'@'localhost' IDENTIFIED BY 'mike';
CREATE DATABASE hotel;
GRANT ALL PRIVILEGES ON hotel.* TO 'root'@'localhost';
FLUSH PRIVILEGES;