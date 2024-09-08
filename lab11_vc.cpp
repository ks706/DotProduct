#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lab11.h"
#include "vectorclass.h"

using namespace std;

double dot_double_vc(double* arr1, double* arr2, uint64_t n)
{
    double product = 0;
    
    for(uint64_t i = 0; i < n; i += 4)
    {
        Vec4d numbers1 = Vec4d(arr1[i], arr1[i + 1], arr1[i + 2], arr1[i + 3]);
        Vec4d numbers2 = Vec4d(arr2[i], arr2[i + 1], arr2[i + 2], arr2[i + 3]);
        Vec4d products = numbers1 * numbers2;
        product += horizontal_add(products);
    }

    return product;
}

float dot_single_vc(float* arr1, float* arr2, uint64_t n)
{
    float product = 0;
   
    for(uint64_t i = 0; i < n; i += 8)
    {
        Vec8f numbers1 = Vec8f(arr1[i], arr1[i + 1], arr1[i + 2], arr1[i + 3], arr1[i + 4], arr1[i + 5], arr1[i + 6], arr1[i + 7]);
        Vec8f numbers2 = Vec8f(arr2[i], arr2[i + 1], arr2[i + 2], arr2[i + 3], arr2[i + 4], arr2[i + 5], arr2[i + 6], arr2[i + 7]);
        Vec8f products = numbers1 * numbers2;
        product += horizontal_add(products);
    }
   
    return product;
}   

//x*(x*(a*x + b) + c) + d
void map_poly_double_vc(double* input, double* output, uint64_t length, double a, double b, double c, double d)
{
    for(uint64_t i = 0; i < length; i += 4)
    {
        Vec4d x = Vec4d(input[i], input[i + 1], input[i + 2], input[i + 3]);
        Vec4d x2 = Vec4d(input[i], input[i + 1], input[i + 2], input[i + 3]);
        Vec4d aV = Vec4d(a);
        Vec4d bV = Vec4d(b);
        Vec4d cV = Vec4d(c);
        Vec4d dV = Vec4d(d);
        
        x = x * aV;
        x += bV;
        x = x * x2;
        x += cV;
        x = x * x2;
        x += dV;

        output[i] = x[i];
        output[i + 1] = x[i + 1];
        output[i + 2] = x[i + 2];
        output[i + 3] = x[i + 3];

    }
}

void map_poly_single_vc(float* input, float* output, uint64_t length, float a, float b, float c, float d)
{
    for(uint64_t i = 0; i < length; i += 8)
    {
        Vec8f x(input[i], input[i + 1], input[i + 2], input[i + 3], input[i + 4], input[i + 5], input[i + 6], input[i + 7]);
        Vec8f x2 = x;
        Vec8f aV = Vec8f(a);
        Vec8f bV = Vec8f(b);
        Vec8f cV = Vec8f(c);
        Vec8f dV = Vec8f(d);
        
        x = x * aV;
        x += bV;
        x = x * x2;
        x += cV;
        x = x * x2;
        x += dV;

        output[i] = x[i];
        output[i + 1] = x[i + 1];
        output[i + 2] = x[i + 2];
        output[i + 3] = x[i + 3];
        output[i + 4] = x[i + 4];
        output[i + 5] = x[i + 5];
        output[i + 6] = x[i + 6];
        output[i + 7] = x[i + 7];
    }
}