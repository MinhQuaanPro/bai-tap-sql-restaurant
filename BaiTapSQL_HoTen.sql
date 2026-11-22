
DROP DATABASE IF EXISTS restaurant_db;
CREATE DATABASE restaurant_db;
USE restaurant_db;

-- 1. TẠO CÁC BẢNG THEO SƠ ĐỒ DIAGRAM
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100)
);

CREATE TABLE restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(100),
    image VARCHAR(255),
    `desc` TEXT
);

CREATE TABLE food_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50)
);

CREATE TABLE food (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100),
    image VARCHAR(255),
    price FLOAT,
    `desc` TEXT,
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(100),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(50),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- 2. CHÈN DỮ LIỆU MẪU
INSERT INTO user (full_name, email, password) VALUES
('Nguyễn Văn A', 'a@email.com', '123456'),
('Trần Thị B', 'b@email.com', '123456'),
('Lê Văn C', 'c@email.com', '123456'),
('Phạm Thị D', 'd@email.com', '123456'),
('Hoàng Văn E', 'e@email.com', '123456');

INSERT INTO restaurant (res_name, image, `desc`) VALUES
('Nhà hàng A', 'img1.jpg', 'Mô tả nhà hàng A'),
('Nhà hàng B', 'img2.jpg', 'Mô tả nhà hàng B'),
('Nhà hàng C', 'img3.jpg', 'Mô tả nhà hàng C');

INSERT INTO food_type (type_name) VALUES ('Món chính'), ('Đồ uống'), ('Tráng miệng');

INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES
('Phở bò', 'pho.jpg', 50000, 'Phở bò Hà Nội', 1),
('Cơm tấm', 'com.jpg', 45000, 'Cơm tấm sườn', 1),
('Coca', 'coca.jpg', 15000, 'Coca cola', 2);

INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Phở bò tái', 55000, 1), ('Phở bò chín', 50000, 1), ('Cơm tấm sườn', 45000, 2);

INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 1, 2, 'ORD001', '1,2'), (1, 2, 1, 'ORD002', '3'), (1, 3, 3, 'ORD003', ''),
(2, 1, 1, 'ORD004', '1'), (2, 2, 2, 'ORD005', '3'), (3, 1, 1, 'ORD006', '2');

INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1, 1, '2024-01-01'), (1, 2, '2024-01-02'), (1, 3, '2024-01-03'),
(2, 1, '2024-01-04'), (2, 2, '2024-01-05'), (3, 1, '2024-01-06');

INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1, 1, 5, '2024-01-01'), (2, 2, 4, '2024-01-02'), (3, 1, 3, '2024-01-03');

-- ============================================
-- PHẦN 3: 4 CÂU QUERY BÀI TẬP
-- ============================================

-- Câu 1: Tìm 5 người đã like nhà hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(lr.res_id) AS so_luong_like
FROM user u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY so_luong_like DESC
LIMIT 5;

-- Câu 2: Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id, r.res_name, COUNT(lr.user_id) AS so_luong_like
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY so_luong_like DESC
LIMIT 2;

-- Câu 3: Tìm người đã đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(o.food_id) AS so_don_hang
FROM user u
JOIN `order` o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY so_don_hang DESC
LIMIT 1;

-- Câu 4: Tìm người dùng không hoạt động trong hệ thống
-- (không đặt hàng, không like, không đánh giá nhà hàng)
SELECT u.user_id, u.full_name, u.email
FROM user u
WHERE u.user_id NOT IN (SELECT user_id FROM `order`)
  AND u.user_id NOT IN (SELECT user_id FROM like_res)
  AND u.user_id NOT IN (SELECT user_id FROM rate_res);