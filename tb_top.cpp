#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtop.h"

#define MAX_SIM_TIME 300
#define VERIF_START_TIME 7
vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;


void dut_reset (Vtop *dut, vluint64_t &sim_time) {
    dut->reset = 0;
    if (sim_time >= 3 && sim_time < 22) {
        dut->reset = 1;
    }
}

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vtop *dut = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    while (sim_time < MAX_SIM_TIME) {
        dut_reset(dut, sim_time);

        dut->clk ^= 1;
        dut->eval();

        if (dut->MemWriteM == 1 & dut->clk == 0) {
            if (dut->DataAdrM == 100 & dut->WriteDataM == 25)
                std::cout << "Simulation succeeded" << std::endl;
            else if (dut->DataAdrM =! 96)
                std::cout << "Simulation failed" << std::endl;
            else
                std::cout << "Error!" << std::endl;
        }

        m_trace->dump(sim_time);
        sim_time++;
    }

m_trace->close();
delete dut;
exit(EXIT_SUCCESS);

}
