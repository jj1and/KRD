import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

if __name__ == "__main__":
    data_2Gsps = np.loadtxt("./project_tcl/ZCU111/TwoChMixer_test/ILA_Data/2048Msps_12MHz.dat")
    data_4Gsps = np.loadtxt("./project_tcl/ZCU111/TwoChMixer_test/ILA_Data/4Gsps_12MHz.dat")

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("typical waveform, ADC:1V pk-pk/4096, Input waveform:12MHz 2.048Gsps vs 4Gsps")
    ax.set_xlabel("Time [nsec]")
    ax.set_ylabel("Amp. [mV]")

    arg_set_zero_2Gsps = np.argmin(data_2Gsps[:, 1]**2)
    arg_set_zero_4Gsps = np.argmin(data_4Gsps[:, 1]**2)

    ax.plot(data_2Gsps[arg_set_zero_2Gsps:, 0]-data_2Gsps[arg_set_zero_2Gsps, 0], data_2Gsps[arg_set_zero_2Gsps:, 1], label='2.048Gsps')
    ax.plot(data_4Gsps[arg_set_zero_4Gsps:, 0]-data_4Gsps[arg_set_zero_4Gsps, 0], data_4Gsps[arg_set_zero_4Gsps:, 1], label='4.000Gsps')
    ax.legend()

    plt.show()