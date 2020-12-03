// gcc lsq.c image.c image2.c -lm -O ; ./a.out

#include"image.h"
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>

// basic vector operations
double VP(double*a,double*b,int N){
  double s=0;
  int i;
  for(i=0;i<N;i++) s += a[i] * b[i] ;
  return s;
}

void VSS(double*d,double s,int N){
  int i;
  for(i=0;i<N;i++) d[i] *= s;
}

void VSA(double*d,double*a,double s,int N){
  int i;
  for(i=0;i<N;i++) d[i] += a[i] * s;
}

#define Elem(_a,_b,_c)  (_a)->data[(_a)->W*(_b)+(_c)]
#define Row(_a,_b)     ((_a)->data+(_a)->W*(_b))

void MatrixClear(Matrix*mt){
  memset(mt->data,0,mt->W*mt->H*sizeof(double));
}


void MatrixCopy(Matrix*mtD,Matrix*mt){
  memmove(mtD->data,mt->data,mt->W*mt->H*sizeof(double));
}

void MatrixCopyT(Matrix*mtD,Matrix*mt){
  int i,j;
  for(i=0;i<mtD->H;i++)
    for(j=0;j<mtD->W;j++)
      Elem(mtD,i,j) = Elem(mt,j,i);
}

void MatrixPrint(Matrix*mt){
  int i,j;
  for(i=0;i<mt->H;i++){
    for(j=0;j<mt->W;j++){
        printf("%f ",Elem(mt,i,j));
    }
    printf("\n");
  }
}

void MatrixMultT(Matrix*mtD,Matrix*mtA,Matrix*mtB){
  // D = A B^T
  int i,j;
  for(i=0;i<mtA->H;i++){
      for(j=0;j<mtB->H;j++){
        Elem(mtD,i,j) = VP( Row(mtA,i), Row(mtB,j), mtA->W);
    }
  }
}


void MatrixQRDecompColMajor(Matrix*mtR,Matrix*mt){
  // Gram-Schmidt orthonormalization (R and Q)
  double t;//, *aT[] = { Row(mt,0), Row(mt,1), Row(mt,2), Row(mt,3), Row(mt,4), Row(mt,5), Row(mt,6), Row(mt,7) } ;
  int W = mt->W;
  double **aT = (double **)malloc((sizeof (double *)) * mt->H);
  //縦に伸びていく　
  for(int get=0; get<mt->H;get++){
      aT[get] = Row(mt,get);
  }
  MatrixClear(mtR);

///////////
for(int i=0; i < W; i++){
    for(int j=0; j <= i; j++){
        // printf("%d,%d\n",i,j);
        if(j == i){
            Elem(mtR,j,i) = t = sqrt(VP(aT[j],aT[i],W));
            VSS(aT[i], 1/t, W);
        }else{
            Elem(mtR,j,i) = t = VP(aT[j], aT[i], W);
            VSA(aT[i], aT[j], -t, W);
        }
    }
}
//   Elem(mtR,0,0) = t = sqrt(VP(aT[0],aT[0],W));
//   VSS(aT[0], 1/t, W);

// ///////////
//   Elem(mtR,0,1) = t = VP(aT[0], aT[1], W);
//   VSA(aT[1], aT[0], -t, W);

//   Elem(mtR,1,1) = t = sqrt(VP(aT[1],aT[1],W));
//   VSS(aT[1], 1/t, W);

// ///////////
//   Elem(mtR,0,2) = t = VP(aT[0], aT[2], W);
//   VSA(aT[2], aT[0], -t, W);

//   Elem(mtR,1,2) = t = VP(aT[1], aT[2], W);
//   VSA(aT[2], aT[1], -t, W);

//   Elem(mtR,2,2) = t = sqrt(VP(aT[2],aT[2],W));
//   VSS(aT[2], 1/t, W);

// ////// 以下略
}

void MatrixSimeqLr(Matrix*mtB,Matrix*mtR){
  // B = B L^{-1}
  double * B = Row(mtB,0);
  for(int i=mtR->W-1; 0<=i; i--){
      for(int j=i+1; j<mtR->W; j++){
        B[i] -=  B[j]*Elem(mtR,i,j);
      }
      B[i] = B[i] / Elem(mtR,i,i);
  }
//   B[7] =  B[7] / Elem(mtR,7,7);
//   B[6] = (B[6]-B[7]*Elem(mtR,6,7)) / Elem(mtR,6,6);
//   B[5] = (B[5]-B[6]*Elem(mtR,5,6)-B[7]*Elem(mtR,5,7)) / Elem(mtR,5,5);
//   B[4] = (B[4]-B[5]*Elem(mtR,4,5)-B[6]*Elem(mtR,4,6)-B[7]*Elem(mtR,4,7)) / Elem(mtR,4,4);
///// 以下略
}


main(){
  Matrix *cmA, *vt, *mtR, *tmp;
  int i;

  double w[][4]={ // (x,y,u,v)
    // 256,218,  371,230,
    // 347,220,  463,230,
    // 263,367,  383,379,
    // 413,315,  530,327,

    //kaizen
    // 147,535,  268,544,
    // 116,209,  235,224,
    // 509,205,  629,210,
    // 432,517,  550,530

    // //jibun
    // 215,320,  315,319,
    // 220,507,  320,506,
    // 651,480,  751,479,
    // 600,135,  700,134

    //dai6
    315,495,564,507,
    259,538,507,548,
    119,196,367,211,
    142,517,393,522
  };

  cmA=MatrixAlloc(8,8);
  vt=MatrixAlloc(1,8);

  // create A (col-major)
  for(i=0;i<4;i++){
    Elem(cmA,0,i*2  )=w[i][0];
    Elem(cmA,1,i*2  )=w[i][1];
    Elem(cmA,2,i*2  )=1;
    Elem(cmA,3,i*2  )=0;
    Elem(cmA,4,i*2  )=0;
    Elem(cmA,5,i*2  )=0;
    Elem(cmA,6,i*2  )=-w[i][0]*w[i][2];
    Elem(cmA,7,i*2  )=-w[i][1]*w[i][2];
    Elem(cmA,0,i*2+1)=0;
    Elem(cmA,1,i*2+1)=0;
    Elem(cmA,2,i*2+1)=0;
    Elem(cmA,3,i*2+1)=w[i][0];
    Elem(cmA,4,i*2+1)=w[i][1];
    Elem(cmA,5,i*2+1)=1;
    Elem(cmA,6,i*2+1)=-w[i][0]*w[i][3];
    Elem(cmA,7,i*2+1)=-w[i][1]*w[i][3];
    Elem(vt ,0,i*2  )=w[i][2];
    Elem(vt ,0,i*2+1)=w[i][3];
  }

  // solve Least-squares equation
  mtR=MatrixAlloc(8,8);
  MatrixQRDecompColMajor(mtR,cmA);
  tmp=MatrixAlloc(1,8);
  MatrixMultT(tmp,vt,cmA);
  MatrixSimeqLr(tmp,mtR);
  MatrixPrint(tmp);

//make Image
  Image *im,*id;
  id=ImageAlloc(1024,768);
  ImageClear(id);
  double m0d[][3]={
      1,0,-100,
      0,1,-100,
      0,0,1
    };
    im = ImageRead("0.jpg");
    ImageImageProjectionAlpha(id,im,m0d,.5);
    double m10[][3]={
        Elem(tmp,0,0), Elem(tmp,0,1), Elem(tmp,0,2),
        Elem(tmp,0,3), Elem(tmp,0,4), Elem(tmp,0,5),
        Elem(tmp,0,6), Elem(tmp,0,7), 1
    }, m1d[3][3];
    mult33(m1d,m10,m0d);
    im = ImageRead("2.jpg");
    ImageImageProjectionAlpha(id,im,m1d,.5);
    ImageWrite("dai6.jpg",id);
}