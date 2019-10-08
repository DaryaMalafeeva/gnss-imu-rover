clear all; close all; clc;

N = 1000;

% истинные углы
R_true   = (rand(N,1)*2*pi - pi);
P_true   = (rand(N,1)*pi - pi/2);
Y_true   = (rand(N,1)*2*pi - pi);
RPY_true = [R_true P_true Y_true]';

% длина вехи
L_rpy = [ 0 0 2]';

% истинные координаты второго конца вехи в ecef
x2_true   = randn(N,1);
y2_true   = randn(N,1);
z2_true   = randn(N,1);
xyz2_true = [ x2_true y2_true z2_true]';

% ско шума приемника
sigma_gnss = (0.018 + 0.024)/2; % a iao?ao

% ско шума IMU
sigma_imu = (0.011 + 0.017)/2; % iao?u

% пустые матрицы
xyz1_true  = zeros(3,N);
xyz1_new   = zeros(3,N);
RPY_new    = zeros(3,N);
xyz2_new   = zeros(3,N);
xyz2_error = zeros(3,N);
T_true     = zeros(1,N);

% расчет
for i = 1:N
% матрица преобразования из истинных углов
C_rpy_ecef_true = rpy2mat(RPY_true(1:3,i));

% истинные координаты первого конца вехи
xyz1_true(1:3,i) = xyz2_true(1:3,i) + C_rpy_ecef_true * L_rpy;

% шумные координаты первого конца вехи
xyz1_new(1:3,i) = xyz1_true(1:3,i) + sigma_gnss;

% шумные углы 
RPY_new(1:3,i) = RPY_true(1:3,i) + sigma_imu;

% шумная матрица преобразования
C_rpy_ecef_new = rpy2mat(RPY_new(1:3,i));

% шумные координаты второго конца вехи
xyz2_new(1:3,i) = xyz1_new(1:3,i) - C_rpy_ecef_new * L_rpy;

% ошибка координат второго конца вехи
xyz2_error(1:3,i) = xyz2_new(1:3,i) - xyz2_true(1:3,i);

% угол наклона
T_true(i) = asin( sin(R_true(i)) * sin(P_true(i)));
end

% графики
figure
plot(rad2deg(T_true),(xyz2_error(1,:)), '.','LineWidth',2);
title('x2 coordinate error vs Tilt')
xlabel('Tilt, deg')
ylabel('x2 coordinate error, m')
grid on

figure
plot(rad2deg(T_true),xyz2_error(2,:), '.','LineWidth',2);
title('y2 coordinate error vs Tilt')
xlabel('Tilt, deg')
ylabel('y2 coordinate error, m')
grid on

figure
plot(rad2deg(T_true),xyz2_error(3,:), '.','LineWidth',2);
title('z2 coordinate error vs Tilt')
xlabel('Tilt, deg')
ylabel('z2 coordinate error, m')
grid on

% 3d error
xyz2_error_mod = sqrt((xyz2_error(1,:)).^2 + (xyz2_error(2,:)).^2 + (xyz2_error(3,:)).^2);

figure
plot(rad2deg(T_true),xyz2_error_mod, '.','LineWidth',2);
title('zyz2 coordinate error vs Tilt')
xlabel('Tilt, deg')
ylabel('zyz2 coordinate error, m')
grid on
