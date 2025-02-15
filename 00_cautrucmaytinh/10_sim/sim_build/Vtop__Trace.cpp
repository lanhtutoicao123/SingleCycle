// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vtop::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->chgIData(oldp+0,(vlTOPp->rs1_data),32);
        tracep->chgIData(oldp+1,(vlTOPp->rs2_data),32);
        tracep->chgBit(oldp+2,(vlTOPp->br_unsigned));
        tracep->chgBit(oldp+3,(vlTOPp->br_less));
        tracep->chgBit(oldp+4,(vlTOPp->br_equal));
        tracep->chgIData(oldp+5,(vlTOPp->brc__DOT__rs1_data),32);
        tracep->chgIData(oldp+6,(vlTOPp->brc__DOT__rs2_data),32);
        tracep->chgBit(oldp+7,(vlTOPp->brc__DOT__br_unsigned));
        tracep->chgBit(oldp+8,(vlTOPp->brc__DOT__br_less));
        tracep->chgBit(oldp+9,(vlTOPp->brc__DOT__br_equal));
        tracep->chgIData(oldp+10,(vlTOPp->brc__DOT__addsubcomp__DOT__inA),32);
        tracep->chgIData(oldp+11,(vlTOPp->brc__DOT__addsubcomp__DOT__inB),32);
        tracep->chgBit(oldp+12,(vlTOPp->brc__DOT__addsubcomp__DOT__neg_sel));
        tracep->chgBit(oldp+13,(vlTOPp->brc__DOT__addsubcomp__DOT__unsigned_sel));
        tracep->chgIData(oldp+14,(vlTOPp->brc__DOT__addsubcomp__DOT__result),32);
        tracep->chgBit(oldp+15,(vlTOPp->brc__DOT__addsubcomp__DOT__less_than));
        tracep->chgBit(oldp+16,(vlTOPp->brc__DOT__addsubcomp__DOT__equal));
        tracep->chgQData(oldp+17,(vlTOPp->brc__DOT__addsubcomp__DOT__extendedA),33);
        tracep->chgQData(oldp+19,(vlTOPp->brc__DOT__addsubcomp__DOT__extendedB),33);
        tracep->chgQData(oldp+21,(vlTOPp->brc__DOT__addsubcomp__DOT__newB),33);
    }
}

void Vtop::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
    }
}
