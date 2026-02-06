//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// TransferFaceToVert.h
//
// Code generation for function 'TransferFaceToVert'
//

#pragma once

// Include files
#include "TransferFaceToVert_types.h"
#include "rtwtypes.h"
#include "coder_array.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Function Declarations
void TransferFaceToVert(const emlrtStack *sp, const struct0_T *MeshStruct,
                        const coder::array<real_T, 2U> &Value,
                        coder::array<real_T, 2U> &Output);

// End of code generation (TransferFaceToVert.h)
