///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                           / _(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 //
//                  | |                                                          //
//                  |_|                                                          //
//                                                                               //
//                                                                               //
//              Peripheral-NTM for MPSoC                                         //
//              Neural Turing Machine for MPSoC                                  //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// Copyright (c) 2020-2024 by the author(s)                                      //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
//                                                                               //
// ============================================================================= //
// Author(s):                                                                    //
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

#include<iostream>
#include<math.h>
#include<vector>
#include<cassert>

using namespace std;

vector<vector<vector<double>>> ntm_tensor_integration(vector<vector<vector<double>>> data_in, double length_in) {

  vector<vector<vector<double>>> data_out;

  for (int i = 0; i < data_in.size(); i++) {

    vector<vector<double>> matrix;

    for (int j = 0; j < data_in[0].size(); j++) {
      double temporal = 0.0;

      vector<double> vector;

      for (int k = 0; k < data_in[0][0].size(); k++) {
        temporal += data_in[i][j][k];

        vector.push_back(temporal*length_in);
      }
      matrix.push_back(vector);
    }
    data_out.push_back(matrix);
  }

  return data_out;
}

int main() {
  vector<vector<vector<double>>> data_in {
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    },
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    },
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    }
  };

  vector<vector<vector<double>>> data_out {
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    },
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    },
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    }
  };

  assert(ntm_tensor_integration(data_in, 1.0)==data_out);

  return 0;
}