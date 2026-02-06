//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// TransferFaceToVert_types.h
//
// Code generation for function 'TransferFaceToVert'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "emlrt.h"

// Type Definitions
struct struct0_T {
  coder::array<real_T, 2U> Vertices;
  coder::array<int32_T, 2U> Faces;
  coder::array<int32_T, 2U> Edges;
  coder::array<real_T, 1U> EdgeLength;
  coder::array<boolean_T, 1U> EdgeTagging;
  coder::array<real_T, 2U> VertexNormals;
  coder::array<real_T, 1U> K1;
  coder::array<real_T, 1U> K2;
  real_T Boundaries[6];
  coder::array<boolean_T, 2U> BoundaryTagging;
};

// End of code generation (TransferFaceToVert_types.h)
