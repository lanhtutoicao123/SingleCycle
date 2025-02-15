// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


//======================

void Vtop::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vtop::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vtop::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vtop::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vtop::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBus(c+1,"rs1_data", false,-1, 31,0);
        tracep->declBus(c+2,"rs2_data", false,-1, 31,0);
        tracep->declBit(c+3,"br_unsigned", false,-1);
        tracep->declBit(c+4,"br_less", false,-1);
        tracep->declBit(c+5,"br_equal", false,-1);
        tracep->declBus(c+6,"brc rs1_data", false,-1, 31,0);
        tracep->declBus(c+7,"brc rs2_data", false,-1, 31,0);
        tracep->declBit(c+8,"brc br_unsigned", false,-1);
        tracep->declBit(c+9,"brc br_less", false,-1);
        tracep->declBit(c+10,"brc br_equal", false,-1);
        tracep->declBus(c+11,"brc addsubcomp inA", false,-1, 31,0);
        tracep->declBus(c+12,"brc addsubcomp inB", false,-1, 31,0);
        tracep->declBit(c+13,"brc addsubcomp neg_sel", false,-1);
        tracep->declBit(c+14,"brc addsubcomp unsigned_sel", false,-1);
        tracep->declBus(c+15,"brc addsubcomp result", false,-1, 31,0);
        tracep->declBit(c+16,"brc addsubcomp less_than", false,-1);
        tracep->declBit(c+17,"brc addsubcomp equal", false,-1);
        tracep->declQuad(c+18,"brc addsubcomp extendedA", false,-1, 32,0);
        tracep->declQuad(c+20,"brc addsubcomp extendedB", false,-1, 32,0);
        tracep->declQuad(c+22,"brc addsubcomp newB", false,-1, 32,0);
    }
}

void Vtop::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vtop::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vtop::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullIData(oldp+1,(vlTOPp->rs1_data),32);
        tracep->fullIData(oldp+2,(vlTOPp->rs2_data),32);
        tracep->fullBit(oldp+3,(vlTOPp->br_unsigned));
        tracep->fullBit(oldp+4,(vlTOPp->br_less));
        tracep->fullBit(oldp+5,(vlTOPp->br_equal));
        tracep->fullIData(oldp+6,(vlTOPp->brc__DOT__rs1_data),32);
        tracep->fullIData(oldp+7,(vlTOPp->brc__DOT__rs2_data),32);
        tracep->fullBit(oldp+8,(vlTOPp->brc__DOT__br_unsigned));
        tracep->fullBit(oldp+9,(vlTOPp->brc__DOT__br_less));
        tracep->fullBit(oldp+10,(vlTOPp->brc__DOT__br_equal));
        tracep->fullIData(oldp+11,(vlTOPp->brc__DOT__addsubcomp__DOT__inA),32);
        tracep->fullIData(oldp+12,(vlTOPp->brc__DOT__addsubcomp__DOT__inB),32);
        tracep->fullBit(oldp+13,(vlTOPp->brc__DOT__addsubcomp__DOT__neg_sel));
        tracep->fullBit(oldp+14,(vlTOPp->brc__DOT__addsubcomp__DOT__unsigned_sel));
        tracep->fullIData(oldp+15,(vlTOPp->brc__DOT__addsubcomp__DOT__result),32);
        tracep->fullBit(oldp+16,(vlTOPp->brc__DOT__addsubcomp__DOT__less_than));
        tracep->fullBit(oldp+17,(vlTOPp->brc__DOT__addsubcomp__DOT__equal));
        tracep->fullQData(oldp+18,(vlTOPp->brc__DOT__addsubcomp__DOT__extendedA),33);
        tracep->fullQData(oldp+20,(vlTOPp->brc__DOT__addsubcomp__DOT__extendedB),33);
        tracep->fullQData(oldp+22,(vlTOPp->brc__DOT__addsubcomp__DOT__newB),33);
    }
}
