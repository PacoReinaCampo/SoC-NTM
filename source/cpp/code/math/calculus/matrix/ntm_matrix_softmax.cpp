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

vector<vector<double>> ntm_matrix_softmax(vector<vector<double>> data_in) {
  double temporal0 = 0.0;

  vector<vector<double>> data_int;

  vector<vector<double>> data_out;

  for (int i = 0; i < data_in.size(); i++) {

    vector<double> vector0;

    for (int j = 0; j < data_in[0].size(); j++) {
      temporal0 += exp(data_in[i][j]);

      double temporal1 = exp(data_in[i][j]);

      vector0.push_back(temporal1);
    }
    data_int.push_back(vector0);

    vector<double> vector1;

    for (int j = 0; j < data_in[0].size(); j++) {
      vector1.push_back(data_int[i][j]/temporal0);
    }
    data_out.push_back(vector1);
  }

  return data_out;
}

int main() {
  vector<vector<double>> data_in {
    { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
    { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
    { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
  };

  vector<vector<double>> data_out {
    { 0.115673909555040450, 0.004756662822010267, 0.8795694276229492000 },
    { 0.012658220095684168, 0.034408489418901890, 0.1367547003294767900 },
    { 0.714653980863293200, 0.092921900422636110, 0.0006526948744619639 }
  };

  assert(ntm_matrix_softmax(data_in)==data_out);

  return 0;
}
