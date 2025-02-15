// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__Syms.h"
#include "Vtop.h"



// FUNCTIONS
Vtop__Syms::Vtop__Syms(Vtop* topp, const char* namep)
    // Setup locals
    : __Vm_namep(namep)
    , __Vm_activity(false)
    , __Vm_baseCode(0)
    , __Vm_didInit(false)
    // Setup submodule names
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
    // Setup scopes
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", 0, VerilatedScope::SCOPE_OTHER);
    __Vscope_brc.configure(this, name(), "brc", "brc", -9, VerilatedScope::SCOPE_MODULE);
    __Vscope_brc__addsubcomp.configure(this, name(), "brc.addsubcomp", "addsubcomp", -9, VerilatedScope::SCOPE_MODULE);
    
    // Setup scope hierarchy
    __Vhier.add(0, &__Vscope_brc);
    __Vhier.add(0, &__Vscope_brc__addsubcomp);
    __Vhier.add(&__Vscope_brc, &__Vscope_brc__addsubcomp);
    
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
        __Vscope_TOP.varInsert(__Vfinal,"br_equal", &(TOPp->br_equal), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"br_less", &(TOPp->br_less), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"br_unsigned", &(TOPp->br_unsigned), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"rs1_data", &(TOPp->rs1_data), false, VLVT_UINT32,VLVD_IN|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"rs2_data", &(TOPp->rs2_data), false, VLVT_UINT32,VLVD_IN|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc.varInsert(__Vfinal,"br_equal", &(TOPp->brc__DOT__br_equal), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc.varInsert(__Vfinal,"br_less", &(TOPp->brc__DOT__br_less), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc.varInsert(__Vfinal,"br_unsigned", &(TOPp->brc__DOT__br_unsigned), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc.varInsert(__Vfinal,"rs1_data", &(TOPp->brc__DOT__rs1_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc.varInsert(__Vfinal,"rs2_data", &(TOPp->brc__DOT__rs2_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"equal", &(TOPp->brc__DOT__addsubcomp__DOT__equal), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"extendedA", &(TOPp->brc__DOT__addsubcomp__DOT__extendedA), false, VLVT_UINT64,VLVD_NODIR|VLVF_PUB_RW,1 ,32,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"extendedB", &(TOPp->brc__DOT__addsubcomp__DOT__extendedB), false, VLVT_UINT64,VLVD_NODIR|VLVF_PUB_RW,1 ,32,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"inA", &(TOPp->brc__DOT__addsubcomp__DOT__inA), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"inB", &(TOPp->brc__DOT__addsubcomp__DOT__inB), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"less_than", &(TOPp->brc__DOT__addsubcomp__DOT__less_than), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"neg_sel", &(TOPp->brc__DOT__addsubcomp__DOT__neg_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"newB", &(TOPp->brc__DOT__addsubcomp__DOT__newB), false, VLVT_UINT64,VLVD_NODIR|VLVF_PUB_RW,1 ,32,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"result", &(TOPp->brc__DOT__addsubcomp__DOT__result), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_brc__addsubcomp.varInsert(__Vfinal,"unsigned_sel", &(TOPp->brc__DOT__addsubcomp__DOT__unsigned_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
    }
}
