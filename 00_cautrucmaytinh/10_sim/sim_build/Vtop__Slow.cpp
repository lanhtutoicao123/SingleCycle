// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"

//==========

VL_CTOR_IMP(Vtop) {
    Vtop__Syms* __restrict vlSymsp = __VlSymsp = new Vtop__Syms(this, name());
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vtop::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-9);
    Verilated::timeprecision(-12);
}

Vtop::~Vtop() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = nullptr);
}

void Vtop::_initial__TOP__1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_initial__TOP__1\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->brc__DOT__addsubcomp__DOT__neg_sel = 1U;
}

void Vtop::_eval_initial(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_initial\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
}

void Vtop::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::final\n"); );
    // Variables
    Vtop__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vtop::_eval_settle(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_settle\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__2(vlSymsp);
}

void Vtop::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_ctor_var_reset\n"); );
    // Body
    rs1_data = VL_RAND_RESET_I(32);
    rs2_data = VL_RAND_RESET_I(32);
    br_unsigned = VL_RAND_RESET_I(1);
    br_less = VL_RAND_RESET_I(1);
    br_equal = VL_RAND_RESET_I(1);
    brc__DOT__rs1_data = VL_RAND_RESET_I(32);
    brc__DOT__rs2_data = VL_RAND_RESET_I(32);
    brc__DOT__br_unsigned = VL_RAND_RESET_I(1);
    brc__DOT__br_less = VL_RAND_RESET_I(1);
    brc__DOT__br_equal = VL_RAND_RESET_I(1);
    brc__DOT__addsubcomp__DOT__inA = VL_RAND_RESET_I(32);
    brc__DOT__addsubcomp__DOT__inB = VL_RAND_RESET_I(32);
    brc__DOT__addsubcomp__DOT__neg_sel = VL_RAND_RESET_I(1);
    brc__DOT__addsubcomp__DOT__unsigned_sel = VL_RAND_RESET_I(1);
    brc__DOT__addsubcomp__DOT__result = VL_RAND_RESET_I(32);
    brc__DOT__addsubcomp__DOT__less_than = VL_RAND_RESET_I(1);
    brc__DOT__addsubcomp__DOT__equal = VL_RAND_RESET_I(1);
    brc__DOT__addsubcomp__DOT__extendedA = VL_RAND_RESET_Q(33);
    brc__DOT__addsubcomp__DOT__extendedB = VL_RAND_RESET_Q(33);
    brc__DOT__addsubcomp__DOT__newB = VL_RAND_RESET_Q(33);
    for (int __Vi0=0; __Vi0<1; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
