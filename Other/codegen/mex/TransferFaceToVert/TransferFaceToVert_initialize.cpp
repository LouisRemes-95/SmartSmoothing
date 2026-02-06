//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// TransferFaceToVert_initialize.cpp
//
// Code generation for function 'TransferFaceToVert_initialize'
//

// Include files
#include "TransferFaceToVert_initialize.h"
#include "TransferFaceToVert_data.h"
#include "_coder_TransferFaceToVert_mex.h"
#include "rt_nonfinite.h"

// Function Declarations
static void TransferFaceToVert_once();

// Function Definitions
static void TransferFaceToVert_once()
{
  mex_InitInfAndNan();
}

void TransferFaceToVert_initialize()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    TransferFaceToVert_once();
  }
}

// End of code generation (TransferFaceToVert_initialize.cpp)
