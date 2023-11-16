#include <gtest/gtest.h>
#include "../lib/complex.h"


TEST (complex_test, constructor_test)
{
    Complex num;

    bool act = (eq(num.real(), 0.0) && eq(num.imag(), 0.0));

    ASSERT_TRUE(act); 
}

TEST (complex_test, constructor_test1)
{
    Complex num(5.23);

    bool act = (eq(num.real(), 3.14f) && eq(num.imag(), 0.23));

    ASSERT_FALSE(act);
}

TEST (complex_test, constructor_test2)
{
    Complex num(1, 5.2344234);

    bool act = (eq(num.real(), 1) && eq(num.imag(), 5.2344234));

    ASSERT_TRUE(act);
}

TEST (complex_test, get_real_test)
{
    Complex num(5.23124);

    bool act = eq(num.real(), 5.23124);

    ASSERT_TRUE(act);
}

TEST (complex_test, get_imag_test)
{
    Complex num(5.23124, 3.901);

    bool act = eq(num.imag(), 3.901);

    ASSERT_TRUE(act);
}

TEST (complex_test, set_real_test)
{
    Complex num;

    num.set_real(2.3913);

    bool act = (eq(num.real(), 2.3913) && eq(num.imag(), 0.0));

    ASSERT_TRUE(act);
}

TEST (complex_test, set_imag_test)
{
    Complex num;

    num.set_imag(5.9831);

    bool act = (eq(num.real(), 0.0) && eq(num.imag(), 5.9831));

    ASSERT_TRUE(act);
}

TEST (complex_test, to_string_test)
{
    Complex num(5, 60);

    bool act = num.to_string() == "5.000000+60.000000i";

    ASSERT_TRUE(act);
}

TEST (complex_test, eq_test)
{
    bool act = Complex(2, 9) == Complex(2, 9);

    ASSERT_TRUE(act);
}

TEST (complex_test, non_eq_test)
{
    bool act = Complex(56, 1) != Complex(12, 58);

    ASSERT_TRUE(act);
}


TEST (complex_test, abs_test)
{
    Complex num(3, 4);

    bool act = eq(num.abs(), 5);

    ASSERT_TRUE(act);
}

TEST (complex_test, pow_test)
{
    Complex num(3, 4);
    int exp = 3;

    bool act = num.pow(exp) == Complex(-117, 44);

    ASSERT_TRUE(act);
}

TEST (complex_test, sum_test)
{
    bool act = Complex(1, 2) + Complex(3, 4) == Complex(4, 6);

    ASSERT_TRUE(act);
}

TEST (complex_test, sum_test1)
{
    bool act = Complex(-2, 3) + Complex(3, 4) == Complex(1, 7);

    ASSERT_TRUE(act);
}

TEST (complex_test, sub_test)
{
    bool act = Complex(4, 6) - Complex(3, 4) == Complex(1, 2);

    ASSERT_TRUE(act);
}

TEST (complex_test, sub_test1)
{
    bool act = Complex(4, 6) - Complex(3, -4) == Complex(1, 10);

    ASSERT_TRUE(act);
}

TEST (complex_test, mul_test)
{
    bool act = Complex(1, 2) * Complex(3, 4) == Complex(-5, 10);

    ASSERT_TRUE(act);
}

TEST (complex_test, div_test)
{
    bool act = Complex(1, 2) / Complex(3, 4) == Complex(0.44, 0.08);

    ASSERT_TRUE(act);
}


