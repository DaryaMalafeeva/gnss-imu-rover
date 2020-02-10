# -*- coding: utf-8 -*-
"""
Created on Sat Sep 14 12:12:06 2019

@author: lukyanov_vs
"""
import numpy as np
import copy
import csv
import matplotlib.pyplot as plt
from enum import Enum



C = 299792458.0;


Freq0_L1OF = 1602e6;
dFreq_L1OF = 0.5625e6;



class TipySignal(Enum):
    GLN_L1_OF  =  1
    GLN_L2_OF  =  2
    GLN_L1_SF  =  3
    GLN_L2_SF  =  4
    GLN_L3_OCd =  5
    GLN_L3_OCp =  6
    GLN_L2_OCd =  7 # L2OCd = L2КСИ
    GLN_L2_OCp =  8
    GLN_L2_SCd =  9
    GLN_L2_SCp = 10
    GPS_L1     = 11
    


GLN_LIT  =  [ 1,        # 1
             -4,
              5,
              6,
              1,        # 5
             -4,
              5,
              6,
             -2,        # 9
             -7,
              0,
             -1,
             -2,        #13
             -7,
              0,
             -1,
              4,        #17
             -3,
              3,
              2,
              4,        #21
             -3,
              3,
              2];       #24



def getImimNameFile(Tsignal):
    if   Tsignal == TipySignal.GLN_L1_OF or Tsignal == TipySignal.GLN_L1_SF:
        return 'GLO L1F {sat_n} {sat_lit}'
    elif Tsignal == TipySignal.GLN_L2_OF or Tsignal == TipySignal.GLN_L2_SF:
        return 'GLO L2F {sat_n} {sat_lit}'
    elif Tsignal == TipySignal.GLN_L3_OCd or Tsignal == TipySignal.GLN_L3_OCp:
        return 'GLO L3C {sat_n} {sat_lit}'
    elif Tsignal == TipySignal.GLN_L2_OCd or Tsignal == TipySignal.GLN_L2_OCp or \
         Tsignal == TipySignal.GLN_L2_SCd or Tsignal == TipySignal.GLN_L2_SCp :
        return 'GLO L2C {sat_n} {sat_lit}'
    elif Tsignal == TipySignal.GPS_L1:
        return 'GPS L1C {sat_n} {sat_lit}'
    else:
        1 /0;
        
             
             
class Binr2_92h:
    """----------------------------------------------------------------------------
       конструктор
    ----------------------------------------------------------------------------"""
    def __init__(self, Tsignal, fname, k_line_ignore):
        k_line_ignore += 2
        flg_use_std_name = not (fname[-4:] == '.csv')
        
        # signal's param:
        if Tsignal == TipySignal.GLN_L1_OF or Tsignal == TipySignal.GLN_L1_SF:
            self.N_sat = 24
            self.lit = copy.deepcopy(GLN_LIT)
            self.f0 = 1602e6 + np.array(self.lit, float) * 0.5625e6;
            if flg_use_std_name:
                if Tsignal == TipySignal.GLN_L1_OF:
                    fname += '92h_GLN_L1_OF.csv'
                elif Tsignal == TipySignal.GLN_L1_SF:
                    fname += '92h_GLN_L1_SF.csv'
        elif Tsignal == TipySignal.GLN_L2_OF or Tsignal == TipySignal.GLN_L2_SF:
            self.N_sat = 24
            self.lit = copy.deepcopy(GLN_LIT)
            self.f0 = 1246e6 + np.array(self.lit, float) * 0.4375e6;
            if flg_use_std_name:
                if Tsignal == TipySignal.GLN_L2_OF:
                    fname += '92h_GLN_L2_OF.csv'
                elif Tsignal == TipySignal.GLN_L2_SF:
                    fname += '92h_GLN_L2_SF.csv'
        elif Tsignal == TipySignal.GLN_L3_OCd or Tsignal == TipySignal.GLN_L3_OCp:
            self.N_sat = 24
            self.lit = [0] * self.N_sat
            self.f0 = np.array([1202.025e6] * self.N_sat, float)
            if flg_use_std_name:
                if Tsignal == TipySignal.GLN_L3_OCd:
                    fname += '92h_GLN_L3_OCd.csv'
                elif Tsignal == TipySignal.GLN_L3_OCp:
                    fname += '92h_GLN_L3_OCp.csv'
        elif Tsignal == TipySignal.GLN_L2_OCd or Tsignal == TipySignal.GLN_L2_OCp or \
             Tsignal == TipySignal.GLN_L2_SCd or Tsignal == TipySignal.GLN_L2_SCp:
            self.N_sat = 24
            self.lit = [0] * self.N_sat
            self.f0 = np.array([1248.06e6] * self.N_sat, float)
            if flg_use_std_name:
                if Tsignal == TipySignal.GLN_L2_OCd:
                    fname += '92h_GLN_L2_OCd.csv'
                elif Tsignal == TipySignal.GLN_L2_OCp:
                    fname += '92h_GLN_L2_OCp.csv'
                elif Tsignal == TipySignal.GLN_L2_SCd:
                    fname += '92h_GLN_L2_SCd.csv'
                elif Tsignal == TipySignal.GLN_L2_SCp:
                    fname += '92h_GLN_L2_SCp.csv'
        elif Tsignal == TipySignal.GPS_L1:
            self.N_sat = 32
            self.lit = [0] * self.N_sat
            self.f0 = np.array([1575.42e6] * self.N_sat, float)
            if flg_use_std_name:
                fname += '92h_GPS_L1.csv'
        
        self.l0 = C / self.f0
        
        print('обработка файла: ' + fname) 
        data = [fields for fields in csv.reader(open(fname, newline = ''), delimiter = '|')]
        N_meas = len(data) - k_line_ignore;
        
        # meas data:
        self.t              = np.array( [float('nan')] * N_meas )
        self.dt             = np.array( [float('nan')] * N_meas )
        self.snr            = np.array( [[float('nan')] * self.N_sat] * N_meas )
        self.ph             = np.array( [[float('nan')] * self.N_sat] * N_meas )   # фаза в циклах
        self.r              = np.array( [[float('nan')] * self.N_sat] * N_meas )   # псевдодальность в мс
        self.fd             = np.array( [[float('nan')] * self.N_sat] * N_meas )   # fд в Гц
        self.flag_pll_state = np.array( [[float('nan')] * self.N_sat] * N_meas )
        self.F_meas         = 0;
        self.len            = 0;
        self.usedSatListInd = [];
        self.usedSatListNum = [];
        self.Nsat           = 0
        
        dt_csv = 6
        N_meas = 0;
        
        
        
        for line in data[k_line_ignore:]:
            for sat in range(self.N_sat):                
                splt = line[sat].split(';'); 
                if sat == 0:
                    if splt[3] != 'UTC':                                                # ждём шкалу времени UTC
                        break
                    self.t[N_meas]  = float(splt[1]);
                    self.dt[N_meas] = round (self.t[N_meas]) - self.t[N_meas];
                    self.t[N_meas] *= 1e-3
                    sh_snr, sh_ph, sh_r, sh_f, sh_st = (dt_csv,) * 5
                else:
                    sh_snr, sh_ph, sh_r, sh_f, sh_st = (1, ) * 5
                sh_snr += 0;    
                sh_ph  += 1;                  
                sh_r   += 2;
                sh_f   += 3;
                sh_st  += 4;
                try:
                    if float(splt[sh_st]) == 18:                                        # проверка статуса
                        continue
                except:
                    continue
                if sat == 12 - 1:
                    print('warning {:d}: {:s} {:s}'.format(N_meas, line[0], line[sat]))
                # добавление нового НКА в список:
                if not (sat in self.usedSatListInd):
                    self.usedSatListInd.append(sat);
                    self.usedSatListNum.append(sat + 1);
                    if N_meas > 0:
                        continue;
                # сохранение измерений:
                self.snr[N_meas, sat]            = float(splt[sh_snr])
                self.ph[N_meas, sat]             = float(splt[sh_ph])
                self.r[N_meas, sat]              = float(splt[sh_r])
                self.fd[N_meas, sat]             = float(splt[sh_f]);
                
                tmp = int(splt[sh_st], 16)
                if tmp & (1<<0) and tmp & (1<<1) and (not tmp & (1<<3)):
                    self.flag_pll_state[N_meas, sat]  = 1;
                    self.flag_pll_ok = np.sum(self.flag_pll_state, axis = 0)                    
                else:
                    self.flag_pll_state[N_meas, sat] = 0;
                self.flag_pll_sum = np.sum(self.flag_pll_state, axis = 0)
        
            if sat == self.N_sat - 1:
                N_meas += 1;
            
        del data
        
        self.len = N_meas
        self.nUsedSat = len(self.usedSatListInd)
        """ проверка результатов """
        # all freq of meas
        dt_meas = self.t[1:] - self.t[0:-1]
        F_meas_arr = 1 / (dt_meas); 
        
        # частота измерений: 1, 2, 5 или 10 Гц
        self.F_meas = int( round( np.max( F_meas_arr ) ) )
        # минимальная частота может быть меньше 1 Гц 
        F_meas_min  = round( np.min( F_meas_arr ) * 16) / 16          
        
        # очень странное место:
        self.fd *= self.F_meas                                                            
        
             
        print("список спутников с измерениями: " + str(self.usedSatListNum).strip('[]'))
        print("всего {} спутников".format(self.nUsedSat))
        print("частота измерений: {:.1f} Гц".format(self.F_meas))
        print('разность между максимальным и минимальным шагом измерений {:.3f} - {:.3f} = {:.3f} сек'.format(
                1/F_meas_min, 1/self.F_meas, 1/F_meas_min - 1/self.F_meas))
        
        if (self.F_meas - F_meas_min) > 0.1:
            print('warning: в файле пропуск измерений!!!')
        
        plt.figure(99)
        plt.clf()
        ind = np.arange(1, N_meas, 1) + k_line_ignore + 1
        plt.plot(ind, dt_meas)
        plt.ylabel('dt, sec')
        plt.xlabel('file line')

def get_common_time(tk, ti):
    time = [];
    k = 0;
    i = 0;
    lenTk = len(tk)
    lenTi = len(ti)
    
    while (True):
        dt = tk[k] - ti[i]
        
        if dt > 0.01:
            k += 1;
            if k == lenTk:
                break
        elif dt < 0.01:
            i += 1;
            if i == lenTi:
                break;
        else:
            time.append(tk[k])
            k += 1;
            i += 1;
            if k == lenTk or i == lenTi:
                break;
    return time
    

# функция заменяет пропуски измерений на Nan
def skip2nan(x, t_raw, t_etalon):
    lenEtalon = len(t_etalon)
    lenRaw = len(t_raw)
    y = np.array([float('nan')] * lenEtalon)
   
    i = 0;
    k = 0;
    
    while True:
        if np.isnan(t_raw[i]):
            i += 1
            if i == lenRaw:
                break
        if np.isnan(t_etalon[k]):
            k += 1
            if k == lenEtalon:
                break
        
        dt = t_etalon[k] - t_raw[i]
        if dt > 0.01:
            i += 1
            if i == lenRaw:
                break
        elif dt < -0.01:
            k += 1
            if k == lenEtalon:
                break
        else:
            y[k] = x[i]
            i += 1
            k += 1
            if i == lenRaw or k == lenEtalon:
                break
    return y


 
class ImitData:
    def __init__(self, N_meas, N_sat):
        self.t  = np.array( [[float('nan')] * N_sat] * N_meas )   
        self.r  = np.array( [[float('nan')] * N_sat] * N_meas )
        self.fd = np.array( [[float('nan')] * N_sat] * N_meas )
        self.sat = [float('nan')] * N_sat
        self.len = [0] * N_sat;
    def parseLine(self, line, k_sat):
        splt = line.replace(',', '.').split();
        try:
            self.t  [self.len[k_sat], k_sat] = float(splt[0])
            self.r  [self.len[k_sat], k_sat] = float(splt[1]) * 1e3
            self.fd [self.len[k_sat], k_sat] = float(splt[2])
            self.len[k_sat] += 1
            return 0
        except:
            return 1

     
class RangeDop:
    def __init__(self, r, fd,  t_meas, t_etalon):
        self.r    = skip2nan(r   , t_meas, t_etalon)
        self.fd   = skip2nan(fd  , t_meas, t_etalon)
        
#class MeasFinal:
#        def __init__(self, r, fd,  t_meas, t_etalon):
