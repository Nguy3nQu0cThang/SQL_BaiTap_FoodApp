-- Bài tập
CREATE DATABASE IF NOT EXISTS food_app;
USE food_app


CREATE TABLE user (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255)
);


CREATE TABLE food_type (
  type_id INT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(255)
);


CREATE TABLE food (
  food_id INT AUTO_INCREMENT PRIMARY KEY,
  food_name VARCHAR(255),
  image VARCHAR(255),
  price FLOAT,
  `desc` VARCHAR(500),
  type_id INT,
  FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);


CREATE TABLE sub_food (
  sub_id INT AUTO_INCREMENT PRIMARY KEY,
  sub_name VARCHAR(255),
  sub_price FLOAT,
  food_id INT,
  FOREIGN KEY (food_id) REFERENCES food(food_id)
);


CREATE TABLE `order` (
  user_id INT,
  food_id INT,
  amount INT,
  code VARCHAR(255),
  arr_sub_id VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (food_id) REFERENCES food(food_id)
);


CREATE TABLE restaurant (
  res_id INT AUTO_INCREMENT PRIMARY KEY,
  res_name VARCHAR(255),
  image VARCHAR(255),
  `desc` VARCHAR(500)
);


CREATE TABLE like_res (
  user_id INT,
  res_id INT,
  date_like DATETIME,
  PRIMARY KEY (user_id, res_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);


CREATE TABLE rate_res (
  user_id INT,
  res_id INT,
  amount INT,
  date_rate DATETIME,
  PRIMARY KEY (user_id, res_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);


INSERT INTO food_type (type_name) VALUES 
('Món chính'),
('Tráng miệng'),
('Đồ uống');


INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES 
('Cơm gà', 'comga.jpg', 50000, 'Cơm gà giòn ngon', 1),
('Bánh flan', 'banhflan.jpg', 15000, 'Bánh flan nhà làm', 2),
('Trà sữa', 'trasua.jpg', 30000, 'Trà sữa trân châu', 3);


INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES 
('Thêm gà', 10000, 1),
('Topping caramel', 5000, 2),
('Thêm trân châu', 7000, 3);


INSERT INTO restaurant (res_name, image, `desc`) VALUES 
('Nhà hàng A', 'nha_hang_a.jpg', 'Không gian ấm cúng'),
('Nhà hàng B', 'nha_hang_b.jpg', 'Phong cách hiện đại');


INSERT INTO user (full_name, email, password) VALUES 
('Nguyễn Văn A', 'a@example.com', 'pass123'),
('Trần Thị B', 'b@example.com', 'pass123'),
('Lê Văn C', 'c@example.com', 'pass123'); 


INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES 
(1, 1, 2, 'ORD123', '1'), 
(2, 3, 1, 'ORD124', '3');


INSERT INTO like_res (user_id, res_id, date_like) VALUES 
(1, 1, NOW()),
(2, 2, NOW());


INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES 
(1, 1, 4, NOW()),
(2, 2, 5, NOW());


SELECT 
    u.user_id,
    u.full_name,
    COUNT(lr.res_id) AS like_count
FROM user u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id
ORDER BY like_count DESC
LIMIT 5;


SELECT 
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS total_likes
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id
ORDER BY total_likes DESC
LIMIT 2;


SELECT 
    u.user_id,
    u.full_name,
    COUNT(o.food_id) AS total_orders
FROM user u
JOIN `order` o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY total_orders DESC
LIMIT 1;


SELECT 
    u.user_id,
    u.full_name,
    u.email
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE o.user_id IS NULL
  AND lr.user_id IS NULL
  AND rr.user_id IS NULL;
