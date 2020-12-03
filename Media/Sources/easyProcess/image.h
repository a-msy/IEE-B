#pragma once

#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>

typedef struct _Image
{
    unsigned char *data;
    int W, H;
} Image;

typedef struct {
  double *data;
  int W,H;
} Matrix;

#define IElem(_im, _x, _y, _c) (_im)->data[(_y) * (_im)->W * 3 + (_x)*3 + (_c)]
#define Elem(_a,_b,_c)  (_a)->data[(_a)->W*(_b)+(_c)]
#define DElem(_a,_b,_c)  (_a)->data[(_a)->W*(_c)+(_b)]
#define Row(_a,_b)     ((_a)->data+(_a)->W*(_b))
#define isInsideImage(is, u, v) (0 <= u && u < is->W && 0 <= v && v < is->H)
#define MAX 30

#ifdef _WIN32
#include<intrin.h>
#else
#define __rdtsc() ({ long long a,d; __asm__ volatile ("rdtsc":"=a"(a),"=d"(d)); d<<32|a; })
#endif

Image *ImageAlloc(int W, int H);
Image *ImageRead(const char *name);
void ImageFree(Image *im);
void ImageWrite(const char *name, Image *im);
void ImageClear(Image *im);
void ImageImageProjectionAlpha(Image *id, Image *is, double a[3][3], double alpha);
void ImageDrawBox(Image *im, int x, int y,int W);
void mult33(double d[3][3],double a[3][3],double b[3][3]);
Matrix *MatrixAlloc(int _H,int _W);
double ImageSSD(Image*im,int x1,int y1, Image*im2,int x2,int y2,int W);
void calcSSDtable(Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2, int W);
int matchMethod1(double w[][4],Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2);
int matchMethod2(double w[][4],Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2);
void ImageFeature(Matrix*im2,Image*im,int W);
int MatrixLocalMax(int w[][3], Matrix*im2, int W);
void MatrixSimeqLr(Matrix*mtB,Matrix*mtR);
void MatrixQRDecompColMajor(Matrix*mtR,Matrix*mt);
void MatrixCopyT(Matrix*mtD,Matrix*mt);
void MatrixClear(Matrix*mt);
void MatrixCopy(Matrix*mtD,Matrix*mt);
void VSA(double*d,double*a,double s,int N);
void VSS(double*d,double s,int N);
double VP(double*a,double*b,int N);


