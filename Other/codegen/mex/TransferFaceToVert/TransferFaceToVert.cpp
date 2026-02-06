//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// TransferFaceToVert.cpp
//
// Code generation for function 'TransferFaceToVert'
//

// Include files
#include "TransferFaceToVert.h"
#include "TransferFaceToVert_data.h"
#include "TransferFaceToVert_types.h"
#include "rt_nonfinite.h"
#include "coder_array.h"
#include "mwmathutil.h"

// Variable Definitions
static emlrtRSInfo emlrtRSI{
    4,                    // lineNo
    "TransferFaceToVert", // fcnName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m" // pathName
};

static emlrtBCInfo emlrtBCI{
    -1,                   // iFirst
    -1,                   // iLast
    7,                    // lineNo
    41,                   // colNo
    "Output",             // aName
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m", // pName
    0                             // checkKind
};

static emlrtBCInfo b_emlrtBCI{
    -1,                   // iFirst
    -1,                   // iLast
    7,                    // lineNo
    65,                   // colNo
    "Value",              // aName
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m", // pName
    0                             // checkKind
};

static emlrtECInfo emlrtECI{
    2,                    // nDims
    7,                    // lineNo
    34,                   // colNo
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m" // pName
};

static emlrtBCInfo c_emlrtBCI{
    -1,                   // iFirst
    -1,                   // iLast
    7,                    // lineNo
    16,                   // colNo
    "Output",             // aName
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m", // pName
    0                             // checkKind
};

static emlrtECInfo b_emlrtECI{
    -1,                   // nDims
    7,                    // lineNo
    9,                    // colNo
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m" // pName
};

static emlrtRTEInfo emlrtRTEI{
    80,                  // lineNo
    13,                  // colNo
    "reshapeSizeChecks", // fName
    "/Applications/MATLAB_R2024b.app/toolbox/eml/eml/+coder/+internal/"
    "reshapeSizeChecks.m" // pName
};

static emlrtBCInfo d_emlrtBCI{
    -1,                   // iFirst
    -1,                   // iLast
    4,                    // lineNo
    21,                   // colNo
    "FaceNodes",          // aName
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m", // pName
    0                             // checkKind
};

static emlrtRTEInfo b_emlrtRTEI{
    4,                    // lineNo
    21,                   // colNo
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m" // pName
};

static emlrtRTEInfo c_emlrtRTEI{
    5,                    // lineNo
    1,                    // colNo
    "TransferFaceToVert", // fName
    "/Users/louisremes/Documents/Doctorat/Research/Codes/SmartSmoothingAlg/"
    "Other/TransferFaceToVert.m" // pName
};

// Function Declarations
static void binary_expand_op(real_T in1_data[], int32_T in1_size[2],
                             const coder::array<real_T, 2U> &in2,
                             const coder::array<int32_T, 2U> &in3, int32_T in5,
                             const coder::array<real_T, 2U> &in6);

// Function Definitions
static void binary_expand_op(real_T in1_data[], int32_T in1_size[2],
                             const coder::array<real_T, 2U> &in2,
                             const coder::array<int32_T, 2U> &in3, int32_T in5,
                             const coder::array<real_T, 2U> &in6)
{
  int32_T b_in3;
  int32_T loop_ub;
  int32_T stride_0_1;
  int32_T stride_1_1;
  b_in3 = in3[in5];
  in1_size[0] = 1;
  if (in6.size(1) == 1) {
    loop_ub = in2.size(1);
  } else {
    loop_ub = in6.size(1);
  }
  in1_size[1] = loop_ub;
  stride_0_1 = (in2.size(1) != 1);
  stride_1_1 = (in6.size(1) != 1);
  for (int32_T i{0}; i < loop_ub; i++) {
    in1_data[i] = in2[(b_in3 + in2.size(0) * (i * stride_0_1)) - 1] +
                  in6[in5 + in6.size(0) * (i * stride_1_1)];
  }
}

void TransferFaceToVert(const emlrtStack *sp, const struct0_T *MeshStruct,
                        const coder::array<real_T, 2U> &Value,
                        coder::array<real_T, 2U> &Output)
{
  coder::array<int32_T, 2U> r;
  emlrtStack st;
  real_T tmp_data[3];
  int32_T iv[2];
  int32_T tmp_size[2];
  int32_T i;
  int32_T i1;
  int32_T n;
  int32_T nx;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  //  Maybe test the accumarray function
  n = MeshStruct->Faces.size(0);
  r.set_size(&b_emlrtRTEI, sp, 3, MeshStruct->Faces.size(0));
  for (i = 0; i < n; i++) {
    r[3 * i] = MeshStruct->Faces[i];
    r[3 * i + 1] = MeshStruct->Faces[i + MeshStruct->Faces.size(0)];
    r[3 * i + 2] = MeshStruct->Faces[i + MeshStruct->Faces.size(0) * 2];
  }
  st.site = &emlrtRSI;
  nx = 3 * r.size(1);
  n = 3;
  if (r.size(1) > 3) {
    n = r.size(1);
  }
  if (nx > muIntScalarMax_sint32(nx, n)) {
    emlrtErrorWithMessageIdR2018a(&st, &emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  i = Value.size(1);
  Output.set_size(&c_emlrtRTEI, sp, MeshStruct->Vertices.size(0),
                  Value.size(1));
  n = MeshStruct->Vertices.size(0) * Value.size(1);
  for (i1 = 0; i1 < n; i1++) {
    Output[i1] = 0.0;
  }
  i1 = Value.size(0);
  for (int32_T b_i{0}; b_i < i1; b_i++) {
    int32_T i2;
    if (b_i + 1 > nx) {
      emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, nx, &d_emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    i2 = r[b_i];
    if ((i2 < 1) || (i2 > Output.size(0))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, Output.size(0), &emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    if (b_i + 1 > i1) {
      emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, i1, &b_emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    n = Output.size(1);
    if ((Output.size(1) != i) && ((Output.size(1) != 1) && (i != 1))) {
      emlrtDimSizeImpxCheckR2021b(Output.size(1), i, &emlrtECI,
                                  (emlrtConstCTX)sp);
    }
    i2 = r[b_i];
    if ((i2 < 1) || (i2 > Output.size(0))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, Output.size(0), &c_emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    if (Output.size(1) == Value.size(1)) {
      tmp_size[0] = 1;
      tmp_size[1] = Output.size(1);
      for (i2 = 0; i2 < n; i2++) {
        tmp_data[i2] = Output[(r[b_i] + Output.size(0) * i2) - 1] +
                       Value[b_i + Value.size(0) * i2];
      }
    } else {
      binary_expand_op(tmp_data, tmp_size, Output, r, b_i, Value);
    }
    iv[0] = 1;
    n = Output.size(1);
    iv[1] = Output.size(1);
    emlrtSubAssignSizeCheckR2012b(&iv[0], 2, &tmp_size[0], 2, &b_emlrtECI,
                                  (emlrtCTX)sp);
    for (i2 = 0; i2 < n; i2++) {
      Output[(r[b_i] + Output.size(0) * i2) - 1] = tmp_data[i2];
    }
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

// End of code generation (TransferFaceToVert.cpp)
