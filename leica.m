<<<<<<< HEAD
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

% шум приемника
sigma_gnss = (0.018 + 0.024)/2; % в метрах

% шум IMU
sigma_imu = (0.011 + 0.017)/2; % метры

% пустые матрицы
xyz1_true  = zeros(3,N);
xyz1_new   = zeros(3,N);
RPY_new    = zeros(3,N);
xyz2_new   = zeros(3,N);
xyz2_error = zeros(3,N);
T_true     = zeros(1,N);

% расчёты
for i = 1:N
% истинная матрица преобразования
C_rpy_ecef_true = rpy2mat(RPY_true(1:3,i));

% истинные координаты первого конца вехи
xyz1_true(1:3,i) = xyz2_true(1:3,i) + C_rpy_ecef_true * L_rpy;

% координаты первого конца вехи с учетом шума приемника
xyz1_new(1:3,i) = xyz1_true(1:3,i) + sigma_gnss;

% углы с учетом шума IMU
RPY_new(1:3,i) = RPY_true(1:3,i) + sigma_imu;

% шумная матрица преобразования
C_rpy_ecef_new = rpy2mat(RPY_new(1:3,i));

% координаты второго конца вехи с учетом шумов
xyz2_new(1:3,i) = xyz1_new(1:3,i) - C_rpy_ecef_new * L_rpy;

% ошибки оценивания координат второго конца 
xyz2_error(1:3,i) = xyz2_new(1:3,i) - xyz2_true(1:3,i);

% расчет угла наклона
T_true(i) = asin( sin(R_true(i)) * sin(P_true(i)));
end

% построение графиков
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


=======
clear all; close all; clc;

N = 1000;

% РёСЃС‚РёРЅРЅС‹Рµ СѓРіР»С‹
R_true   = (rand(N,1)*2*pi - pi);
P_true   = (rand(N,1)*pi - pi/2);
Y_true   = (rand(N,1)*2*pi - pi);
RPY_true = [R_true P_true Y_true]';

% РґР»РёРЅР° РІРµС…Рё
L_rpy = [ 0 0 2]';

% РёСЃС‚РёРЅРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ РІС‚РѕСЂРѕРіРѕ РєРѕРЅС†Р° РІРµС…Рё РІ ecef
x2_true   = randn(N,1);
y2_true   = randn(N,1);
z2_true   = randn(N,1);
xyz2_true = [ x2_true y2_true z2_true]';

% СЃРєРѕ С€СѓРјР° РїСЂРёРµРјРЅРёРєР°
sigma_gnss = (0.018 + 0.024)/2; % a iao?ao

% СЃРєРѕ С€СѓРјР° IMU
sigma_imu = (0.011 + 0.017)/2; % iao?u

% РїСѓСЃС‚С‹Рµ РјР°С‚СЂРёС†С‹
xyz1_true  = zeros(3,N);
xyz1_new   = zeros(3,N);
RPY_new    = zeros(3,N);
xyz2_new   = zeros(3,N);
xyz2_error = zeros(3,N);
T_true     = zeros(1,N);

% СЂР°СЃС‡РµС‚
for i = 1:N
% РјР°С‚СЂРёС†Р° РїСЂРµРѕР±СЂР°Р·РѕРІР°РЅРёСЏ РёР· РёСЃС‚РёРЅРЅС‹С… СѓРіР»РѕРІ
C_rpy_ecef_true = rpy2mat(RPY_true(1:3,i));

% РёСЃС‚РёРЅРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ РїРµСЂРІРѕРіРѕ РєРѕРЅС†Р° РІРµС…Рё
xyz1_true(1:3,i) = xyz2_true(1:3,i) + C_rpy_ecef_true * L_rpy;

% С€СѓРјРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ РїРµСЂРІРѕРіРѕ РєРѕРЅС†Р° РІРµС…Рё
xyz1_new(1:3,i) = xyz1_true(1:3,i) + sigma_gnss;

% С€СѓРјРЅС‹Рµ СѓРіР»С‹ 
RPY_new(1:3,i) = RPY_true(1:3,i) + sigma_imu;

% С€СѓРјРЅР°СЏ РјР°С‚СЂРёС†Р° РїСЂРµРѕР±СЂР°Р·РѕРІР°РЅРёСЏ
C_rpy_ecef_new = rpy2mat(RPY_new(1:3,i));

% С€СѓРјРЅС‹Рµ РєРѕРѕСЂРґРёРЅР°С‚С‹ РІС‚РѕСЂРѕРіРѕ РєРѕРЅС†Р° РІРµС…Рё
xyz2_new(1:3,i) = xyz1_new(1:3,i) - C_rpy_ecef_new * L_rpy;

% РѕС€РёР±РєР° РєРѕРѕСЂРґРёРЅР°С‚ РІС‚РѕСЂРѕРіРѕ РєРѕРЅС†Р° РІРµС…Рё
xyz2_error(1:3,i) = xyz2_new(1:3,i) - xyz2_true(1:3,i);

% СѓРіРѕР» РЅР°РєР»РѕРЅР°
T_true(i) = asin( sin(R_true(i)) * sin(P_true(i)));
end

% РіСЂР°С„РёРєРё
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
>>>>>>> 5f9f93c6963119017975da513c4318817bcfa808
