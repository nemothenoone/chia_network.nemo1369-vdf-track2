//---------------------------------------------------------------------------//
// Copyright (c) 2018-2019 Nil Foundation AG
// Copyright (c) 2018-2019 Mikhail Komarov <nemo@nilfoundation.org>
//
// Distributed under the Boost Software License, Version 1.0
// See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------//

#ifndef CRYPTO3_CHIA_POLICY_HPP
#define CRYPTO3_CHIA_POLICY_HPP

#ifdef CRYPTO3_VDF_NO_BOOST

#define GCDEXT_DC_THRESHOLD 64

#include <flint/fmpz.h>

#include <gmpxx.h>

#else

#include <boost/multiprecision/number.hpp>

#endif

namespace nil {
    namespace crypto3 {
        namespace vdf {
#ifndef CRYPTO3_VDF_NO_BOOST
            using namespace boost::multiprecision;
#endif

            /*!
             * @brief Defines y = ax^2 + bxy + y^2
             * @tparam NumberType
             */
            template<typename NumberType>
            struct binary_quadratic_form {
                typedef NumberType number_type;
#ifdef CRYPTO3_VDF_NO_BOOST

                binary_quadratic_form() {
                    mpz_inits(a, b, c, NULL);
                }

#endif

                // y = ax^2 + bxy + y^2
                number_type a;
                number_type b;
                number_type c;
                // number_type d; // discriminant
            };

            namespace detail {
                struct chia_policy {

#define LOG2(X) (63 - __builtin_clzll((X)))

                    constexpr static const int64_t threshold = 1UL << 31;
                    constexpr static const int64_t double_threshold = 1UL << 31;
                    constexpr static const int64_t exp_threshold = 63;
                    constexpr static const int64_t maxv = ((1UL << 63) - 1);

                    template<typename IntegerNumberType, typename FloatNumberType>
                    struct state_type {
                        typedef IntegerNumberType number_type;
                        typedef FloatNumberType float_number_type;
                        typedef binary_quadratic_form<number_type> form_type;
#ifdef CRYPTO3_VDF_NO_BOOST

                        state_type() {
                            mpz_inits(D, L, NULL);
                            mpz_inits(r, ra, s, p, NULL);
                            mpz_inits(G, dx, dy, By, Dy, x, y, t1, t2, bx, by, ax, ay, q, t, Q1, NULL);
                            mpz_inits(faa, fab, fac, fba, fbb, fbc, fca, fcb, fcc, NULL);

                            fmpz_init(fy);
                            fmpz_init(fx);
                            fmpz_init(fby);
                            fmpz_init(fbx);
                            fmpz_init(fL);
                        }

#else

#endif

                        number_type D, L;
                        number_type r, ra, s, p;
                        number_type G, dx, dy, By, Dy, x, y, t1, t2, bx, by, ax, ay, q, t, Q1;

                        number_type faa, fab, fac, fba, fbb, fbc, fca, fcb, fcc;

                        float_number_type fy, fx, fby, fbx, fL;

                        form_type previous_form, form;
                    };
                };
            }
        }
    }
}

#endif //CRYPTO3_CHIA_POLICY_HPP
