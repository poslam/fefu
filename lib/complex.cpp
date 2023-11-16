#include "./complex.h"
#include <cmath>
#include <stdexcept>


Complex::Complex(double real, double imag): re(real), im(imag) {}

double Complex::real() const{
    return this->re;
}

double Complex::imag() const{
    return this->im;
}

void Complex::set_real(double real){
    this->re = real;
}

void Complex::set_imag(double imag){
    this->im = imag;
}

std::string Complex::to_string() const{
    return std::to_string(this->re) + "+" + std::to_string(this->im) + "i";
}

double Complex::abs() const{
    return std::sqrt(std::pow(this->re, 2) + std::pow(this->im, 2));
}

Complex Complex::pow(int exp) const{

    double abs = this->abs();

    if (std::fabs(abs) < EPS)
        throw std::invalid_argument("division by zero");

    double expphi = std::acos(this->re / abs) * exp;

    double cos_expphi = std::cos(expphi);
    double sin_expphi = std::sin(expphi);

    return Complex(cos_expphi, sin_expphi) * std::pow(abs, exp);
}

Complex Complex::operator+(Complex other) const{
    return Complex(this->re + other.re, this->im + other.im);
}

Complex Complex::operator-(Complex other) const{
    return Complex(this->re - other.re, this->im - other.im);
}

Complex Complex::operator*(Complex other) const{
    return Complex(this->re * other.re - this->im * other.im, this->re * other.im + this->im * other.re);
}

Complex Complex::operator*(double num) const{
    return Complex(this->re * num, this->im * num);
}

Complex Complex::operator/(Complex other) const{

    double div = std::pow(other.re, 2) + std::pow(other.im, 2);

    if (std::fabs(div) < EPS)
        throw std::invalid_argument("division by zero");

    return Complex((this->re * other.re + this->im * other.im), (this->im * other.re - this->re * other.im)) / div;
}

Complex Complex::operator/(double num) const{

    if (std::fabs(num) < EPS)
        throw std::invalid_argument("division by zero");

    return Complex(this->re / num, this->im / num);
}

bool Complex::operator==(Complex other) const{
    return eq(this->re, other.re) && eq(this->im, other.im);
}

bool Complex::operator!=(Complex other) const{
    return !eq(this->re, other.re) || !eq(this->im, other.im);
}

std::ostream &operator<<(std::ostream &os, Complex complex){
    os << complex.to_string();
    return os;
}

bool eq(double num1, double num2){
    return std::fabs(num1 - num2) <= EPS;
}