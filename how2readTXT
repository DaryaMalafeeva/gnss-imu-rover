import math 
import matplotlib.pyplot as plt
import timedbg
import clsdata
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib as mpl


# запускаем таймер
plt.rcdefaults()
timedbg.tic()                        

'''----------------------- Пользовательские настройки ----------------------'''
fname = '77_log.log'
# настройки статистики, если измерений меньше - программа их игнорирует
# (пример: для с/ш 35 есть 10 измерений, а мин. порог 100 - значит эти 10 измерений в статистике не будут участвовать)
N_MIN_STATISTIC       = 100

# порог с/ш
SNR_MIN               = 15
SNR_MAX               = 55    

ACCEL_MIN             = 0
ACCEL_MAX             = 5000

# шаг по ускорению (лучше не менять, тк придется менять константы - попугаи)
ACCEL_INT             = 100

# инициализация переменных 
NUM_OF_TOO_BIG_SNR   = 0
NUM_OF_TOO_BIG_ACC   = 0
NUM_OF_TOO_SMALL_SNR = 0
NUM_OF_TOO_SMALL_ACC = 0
NUM_OF_GOOD_SNR      = 0
NUM_OF_GOOD_ACC      = 0

# коэффициент, возвращающий исходных попугаев (преобразования с попугаями очень нужны для того,чтобы программа работала быстро)
coef_size = 100000

# коэффициент, пересчитывающий ускорение из попугаев в гц/с
coef_accel = (10**6)/(2**28) 

# коэффициент, пересчитывающий дальность из попугаев в мс
coef_range = 1/(2**15) 
'''-------------------------- Предрасчёты ----------------------------------'''
# открываем файл
file      = open(fname ,'r', encoding='utf-8' )

# поля в считанной строке
list_data = ['rez', 'snr', 'range', 'dr', 'dop', 'dd', 'accel', 'da', 't2pll', 't2bs', 't2reset']
N_data    = len(list_data)

# константы и флаги состояний считанной строки 
# измерение правильное
MEAS_GOOD = 1   

# плохое измерение                      
MEAS_BAD  = 2     

# не измерение                    
MEAS_NO   = 0         
                
# количество точек SNR
N_SNR     = SNR_MAX - SNR_MIN + 1      

# количество точек accel
N_ACCEL   = ACCEL_MAX - ACCEL_MIN + 1   

# созадем экземпляр класса в котором объектами являются параметры, рассчитываемые в этом скрипте
data_ar   = [] 
data_ar   += [clsdata.Data(SNR_MIN + k, 0) for k in range(N_SNR)]

for i in range(N_SNR):
    data_ar[i] = []
    data_ar[i] += [clsdata.Data(i + SNR_MIN, ACCEL_MIN + l) for l in range(N_ACCEL)] 

'''------------------------ Чтение данных из файла -------------------------'''
num = 0
for line in file.readlines():
    num += 1 
    k, flg, flg_status_meas = 0, 0, MEAS_NO
    for word in line.split():
        if word == list_data[k]:
            flg = 1
            continue
        if flg == 1:
            flg = 0
            val = float(word)
            if k == 0:
                rez = val
            elif k == 1:
                snr = val
            elif k == 2:
                range_ = val
            elif k == 3:
                 dr = val
                 if abs(dr) >= 200:
                     flg_status_meas = MEAS_BAD
            elif k == 4:
                dop = val
            elif k == 5:
                dd = val
#                if abs(dd) > 200:
#                    flg_status_meas = MEAS_BAD
            elif k == 6:
                accel = abs(val)     
                accel = accel / 1000
            elif k == 7:
                da = val
            elif k == 8:
                t2pll = val
            elif k == 9:
                t2bs = val
            elif k == 10:
                t2reset = val
            k = k + 1
            if k == N_data:
                if flg_status_meas != MEAS_BAD:
                    flg_status_meas = MEAS_GOOD
                 
    if (snr < SNR_MIN):
#         i = SNR_MIN - 1
         NUM_OF_TOO_SMALL_SNR += 1
    elif (snr > SNR_MAX):
#       i = int(SNR_MAX + 1)
        NUM_OF_TOO_BIG_SNR    += 1
    else:
        NUM_OF_GOOD_SNR       += 1
        i = round(snr - SNR_MIN)
    
    if accel > ACCEL_MAX:
#        j = int((ACCEL_MAX / ACCEL_INT) + 1)
        NUM_OF_TOO_BIG_ACC   += 1
    elif (accel < ACCEL_MIN):
#        j = ACCEL_MIN - 1
        NUM_OF_TOO_SMALL_ACC += 1
    else:
        NUM_OF_GOOD_ACC      += 1
        j = round(accel / ACCEL_INT) 
    data2wr = data_ar[i][j]
           
    if   flg_status_meas  != MEAS_NO:
# общее количество попыток захвата 
         data2wr.try2track = data2wr.try2track + 1  
                                 
    if   flg_status_meas == MEAS_GOOD:
# количество попыток захвата при dr < 200
         data2wr.goodTry2track        += 1      
# успешный захват
         data2wr.tracked              += rez        
         data2wr.mean_da              += da                                                 
         data2wr.rms_da               += (da**2)  
         data2wr.mean_dr              += dr                                                  
         data2wr.rms_dr               += (dr**2)  
    
    elif flg_status_meas == MEAS_BAD:
# количество попыток захвата при dr > 200
         data2wr.falseTry2track       += 1    
# успешный захват при dr > 200
         data2wr.falseTracked         += rez       
         data2wr.mean_falseTracked_da += da
         data2wr.rms_falseTracked_da  += da**2
         data2wr.mean_falseTracked_dr += dr
         data2wr.rms_falseTracked_dr  += dr**2

NUM_OF_STR_IN_FILE   = NUM_OF_TOO_SMALL_SNR + NUM_OF_TOO_BIG_SNR  + NUM_OF_GOOD_SNR        
NUM_OF_UNCOUNTED_STR = NUM_OF_TOO_SMALL_SNR + NUM_OF_TOO_SMALL_ACC + NUM_OF_TOO_BIG_SNR + NUM_OF_TOO_BIG_ACC
NUM_OF_COUNTED_STR   = NUM_OF_STR_IN_FILE - NUM_OF_UNCOUNTED_STR

print('Количество строк в файле:', NUM_OF_STR_IN_FILE)
print('Количество значений с/ш меньших нижней границы:', NUM_OF_TOO_SMALL_SNR)
print('Количество значений с/ш больших верхней границы:', NUM_OF_TOO_BIG_SNR)
print('Количество значений ускорения больших верхней границы:', NUM_OF_TOO_BIG_ACC)
print('Количество значений ускорений меньших нижней границы:', NUM_OF_TOO_SMALL_ACC)
print('Количество строк, участвующих в расчётах:', NUM_OF_COUNTED_STR)

# если выведенные цифры меньше чем N_MIN_STATISTIC - то все хорошо, если нет - то надо расширить границы

'''------------------Обработка считанных данных ----------------------------'''

for i in range(N_SNR):
    for j in range(N_ACCEL):
        data2wr = data_ar[i][j]     
# вероятность хорошего и ложного захвата от сш                   
        if   data2wr.goodTry2track        == 0:                                                
             data2wr.p_zahv               = math.nan   
             
        elif data2wr.goodTry2track < N_MIN_STATISTIC:
             data2wr.p_zahv               = math.nan
        else:
             data2wr.p_zahv               = data2wr.tracked/ data2wr.try2track
             
        if   data2wr.falseTry2track       == 0:
             data2wr.p_zahv_false         = math.nan
              
        elif data2wr.falseTry2track < N_MIN_STATISTIC:
             data2wr.p_zahv_false         = math.nan
             
        else:
             data2wr.p_zahv_false         = data2wr.falseTracked/ data2wr.try2track
                         
# вероятность незахвата для хорошего и ложного захвата( rez = 0 при dr > 200 и dr < 200) 
        if   data2wr.goodTry2track        == 0:                                                
             data2wr.p_not_zahv           = math.nan   
             
        elif data2wr.goodTry2track < N_MIN_STATISTIC:
             data2wr.p_not_zahv           = math.nan
             
        else:
             data2wr.p_not_zahv           = (data2wr.tracked - data2wr.goodTry2track)/ data2wr.try2track
        
        if   data2wr.falseTry2track       == 0:
             data2wr.p_not_zahv_false     = math.nan
        elif data2wr.falseTry2track < N_MIN_STATISTIC:
             data2wr.p_not_zahv_false     = math.nan
        else:
             data2wr.p_not_zahv_false     = (data2wr.falseTry2track - data2wr.falseTracked)/ data2wr.try2track
                     
# мат ожидание и ско для ошибки дальности и ошибки ускорения        
        if   data2wr.tracked              == 0:                                              
             data2wr.mean_da              = math.nan                                            
             data2wr.rms_da               = math.nan
             data2wr.mean_dr              = math.nan                                            
             data2wr.rms_dr               = math.nan
             
        elif data2wr.tracked < N_MIN_STATISTIC:
             data2wr.mean_da              = math.nan                                            
             data2wr.rms_da               = math.nan
             data2wr.mean_dr              = math.nan
             data2wr.rms_dr               = math.nan
        else:
             data2wr.mean_da              = data2wr.mean_da / data2wr.tracked
             data2wr.rms_da               = (data2wr.rms_da / data2wr.tracked) - data2wr.mean_da**2
             data2wr.rms_da               = math.sqrt(abs(data2wr.rms_da))
             data2wr.mean_dr              = data2wr.mean_dr / data2wr.tracked
             data2wr.rms_dr               = (data2wr.rms_dr / data2wr.tracked) - data2wr.mean_dr**2
             data2wr.rms_dr               = math.sqrt(abs(data2wr.rms_dr))
             
        if   data2wr.falseTracked == 0:                                              
             data2wr.mean_falseTracked_da = math.nan                               
             data2wr.rms_falseTracked_da  = math.nan
             data2wr.mean_falseTracked_dr = math.nan                             
             data2wr.rms_falseTracked_dr  = math.nan
        
        elif data2wr.falseTracked < N_MIN_STATISTIC:

             data2wr.mean_falseTracked_da = math.nan
             data2wr.rms_falseTracked_da  = math.nan
             data2wr.mean_falseTracked_dr = math.nan
             data2wr.rms_falseTracked_dr  = math.nan
             
        else:
             data2wr.mean_falseTracked_da = data2wr.mean_falseTracked_da / data2wr.falseTracked
             data2wr.rms_falseTracked_da  = (data2wr.rms_falseTracked_da / data2wr.falseTracked) - data2wr.mean_falseTracked_da**2
             data2wr.rms_falseTracked_da  = math.sqrt(abs(data2wr.rms_falseTracked_da))
             data2wr.mean_falseTracked_dr = data2wr.mean_falseTracked_dr / data2wr.falseTracked
             data2wr.rms_falseTracked_dr  = (data2wr.rms_falseTracked_dr / data2wr.falseTracked) - data2wr.mean_falseTracked_dr**2
             data2wr.rms_falseTracked_dr  = math.sqrt(abs(data2wr.rms_falseTracked_dr))

'''---------------------------- Построение графиков ------------------------'''  

# вызов функции со структурой
data_plot  = clsdata.get_array_val(data_ar, N_SNR, N_ACCEL)

# графики для вероятности
# трёхмерные графики
fig_1 = plt.figure(1)
ax    = fig_1.add_subplot(projection=f'3d')
ax.scatter(data_plot.accel * coef_accel * coef_size, data_plot.snr, data_plot.p_zahv, color = 'darkblue')
#ax.scatter(data_plot.accel, data_plot.snr,data_plot.p_zahv)
ax.set_xlabel('Ускорение, Гц/с')
ax.set_ylabel('С/Ш, дБГц')
ax.set_zlabel('Вероятность правильного захвата')
plt.show()
#
#fig_2 = plt.figure(2)
#ax = fig_2.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.p_zahv_false)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Вероятность ложного захвата')
#plt.show()
#
#fig_3 = plt.figure(3)
#ax = fig_3.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.p_not_zahv)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Вероятность правильного незахвата')
#plt.show()
#
#fig_4 = plt.figure(4)
#ax = fig_4.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.p_not_zahv_false)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Вероятность ложного незахвата')
#plt.show()
#
fig_5 = plt.figure(5)
ax = fig_5.add_subplot (projection='3d')
ax.scatter(data_plot.accel * coef_accel * coef_size , data_plot.snr, data_plot.mean_da)
ax.set_xlabel('Ускорение, Гц/с')
ax.set_ylabel('С/Ш, дБГц')
ax.set_zlabel('Мат. ожиданеие ошибки ускорения, Гц/с')
plt.show()
#
#fig_6 = plt.figure(6)
#ax = fig_6.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.mean_dr * coef_range)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Мат. ожидание ошибки дальности, мс')
#plt.show()
#
#fig_7 = plt.figure(7)
#ax = fig_7.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.rms_da * coef_accel)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('СКО ошибки ускорения, Гц/с')
#plt.show()
#
#fig_8 = plt.figure(8)
#ax = fig_8.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.rms_dr * coef_range)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('СКО ошибки дальности, мс')
#plt.show()
#
## для ложного захвата
#fig_9 = plt.figure(9)
#ax = fig_9.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.mean_falseTracked_da * coef_accel)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Мат. ожидание ошибки ускорения для ложного захвата, Гц/с')
#plt.show()
#
#fig_10 = plt.figure(10)
#ax = fig_10.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.mean_falseTracked_dr * coef_range)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('Мат. ожидание ошибки дальности для ложного захвата, мс')
#plt.show()
#
#fig_11 = plt.figure(11)
#ax = fig_11.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.rms_falseTracked_da * coef_accel)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('СКО ошибки ускорения для ложного захвата, Гц/с')
#plt.show()
#
#fig_12 = plt.figure(12)
#ax = fig_12.add_subplot (projection='3d')
#ax.scatter(data_plot.accel * coef_accel, data_plot.snr, data_plot.rms_falseTracked_dr * coef_range)
#ax.set_xlabel('Ускорение, Гц/с')
#ax.set_ylabel('С/Ш, дБГц')
#ax.set_zlabel('СКО ошибки дальности для ложного захвата, мс')
#plt.show() 

fig_13 = plt.figure(13)
x      = data_plot.accel * coef_accel * coef_size
y      = data_plot.p_zahv
plt.plot(x, y, 'o-')
plt.xlabel ('Ускорение, Гц/с')
plt.ylabel('Вероятность правильного захвата')
plt.grid()
plt.show()

fig_14 = plt.figure(14)
x      = data_plot.snr 
y      = data_plot.p_zahv
plt.plot(x, y, 'o-')
plt.xlabel ('с/ш, дБГц')
plt.ylabel('Вероятность правильного захвата')
plt.grid()
plt.show()

timedbg.toc() 

 
