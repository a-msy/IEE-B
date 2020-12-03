/*
 cl /Ox greedy.c image.c image2.cxx ; greedy 0.jpg 2.jpg
 gcc -O greedy.c image.c image2.c -lm ; ./a.out 0.jpg 2.jpg
*/
#include"image.h"
#include<math.h>

#define MAX 30

double ImageSSD(Image*im,int x1,int y1, Image*im2,int x2,int y2){
  int i,j,W=7;
  double sr=0,sg=0,sb=0,dr,dg,db;
  for(i=-W;i<=W;i++) for(j=-W;j<=W;j++){
    dr  = IElem(im, x1+j, y1+i, 0) - IElem(im2, x2+j , y2+i, 0);
    dg  = IElem(im, x1+j, y1+i, 1) - IElem(im2, x2+j , y2+i, 1);
    db  = IElem(im, x1+j, y1+i, 2) - IElem(im2, x2+j , y2+i, 2);
    sr += dr*dr;
    sg += dg*dg;
    sb += db*db;
  }
  return sr+sg+sb;
}


void calcSSDtable(Matrix*mt,Image*im ,int x1[][2],int N1,Image*im2,int x2[][2],int N2){
    int i,j;
    for(i=0;i<N1;i++){
        for(j=0;j<N2;j++){
            Elem(mt,i,j) = ImageSSD(im ,x1[i][0],x1[i][1],im2,x2[j][0],x2[j][1]);
            //printf("%3d ",(int)Elem(mt,i,j)/100000);
        }
        //printf("\n");
    }
}

void MatrixPrint(Matrix*mt){
  int i,j;
  for(i=0;i<mt->H;i++){
    for(j=0;j<mt->W;j++){
        printf("%d ",(int)Elem(mt,i,j)/100000);
    }
    printf("\n");
  }
}

union {int i; float f;} _inf={0x7f800000};
#define INFINITY _inf.f // 2重定義エラーが出るなら，この定義を削除
#define INFINITY_INT _inf.i

int matchMethod1(double w[][4],Matrix*mt,Image*im ,int x1[][2],int N1,Image*im2,int x2[][2],int N2){
  int i,j,k,ji,n=0;

  for(i=0;i<N1;i++){
    double sm=INFINITY,t;
    for(j=0;j<N2;j++){
      t = Elem(mt,i,j);
      if(sm>t) sm=t, ji=j;
    }
    printf("%d,%d,%d,%d,\n",x1[i][0],x1[i][1],x2[ji][0],x2[ji][1]);
    // 上の printf で表示されるものを w[n][] に格納.
    w[n][0] = x1[i][0];
    w[n][1] = x1[i][1];
    w[n][2] = x2[ji][0];
    w[n][3] = x2[ji][1];
    n++;
    for(k=0;k<N1;k++) { Elem(mt,k,ji)=INFINITY; }
  }
  printf("%d\n",n);
  return n;
}

int matchMethod2(double w[][4],Matrix*mt,Image*im ,int x1[][2],int N1,Image*im2,int x2[][2],int N2){
  int i,j,k,l,n = 0;
  int minElem[3] = {0,0,INFINITY_INT};
  //　SSDの表中の最小値
  for(i=0;i<MAX;i++){//点の数だけ
    for(j=0;j<mt->W;j++){//横幅
      for(k=0;k<mt->H;k++){//縦幅
        if(Elem(mt,j,k) < minElem[2]){
          minElem[0] = j;
          minElem[1] = k;
          minElem[2] = (int)Elem(mt,j,k);
          //printf("%d,%d,%d\n",minElem[0],minElem[1],minElem[2]);
        }
      }
    }
    for(k=0;k<MAX;k++) Elem(mt,minElem[0],k)=INFINITY_INT;//横固定して爆破
    for(k=0;k<MAX;k++) Elem(mt,k,minElem[1])=INFINITY_INT;//縦固定して爆破
    //MatrixPrint(mt);
    printf("%d,%d,%d,%d,\n",x1[minElem[0]][0],x1[minElem[0]][1],x2[minElem[1]][0],x2[minElem[1]][1]);
    w[n][0] = x1[minElem[0]][0];
    w[n][1] = x1[minElem[0]][1];
    w[n][2] = x2[minElem[1]][0];
    w[n][3] = x2[minElem[1]][1];
    n++;
    minElem[2]=INFINITY_INT;
  }
  return n;
}

int main(int ac,char**av){
  Image *im,*im2;
  Matrix*mt;

  int x1[][2]={
383, 465,
614, 440,
354, 500,
403, 462,
242, 528,
295, 498,
687, 482,
337, 514,
298, 554,
116, 406,
315, 495,
458, 471,
134, 501,
136, 457,
259, 538,
578, 460,
13, 562,
11, 474,
114, 505,
215, 526,
119, 196,
142, 517,
289, 328,
692, 453,
680, 452,
403, 319,
12, 538,
141, 412,
79, 407,
223, 244,
  }, N1=MAX;
  int x2[][2]={
636, 478,
544, 510,
604, 518,
490, 536,
655, 476,
588, 528,
368, 411,
546, 567,
387, 464,
269, 478,
208, 408,
564, 507,
207, 416,
385, 507,
275, 557,
367, 509,
393, 522,
535, 341,
716, 487,
367, 211,
299, 466,
462, 528,
148, 336,
507, 548,
274, 536,
152, 295,
321, 469,
332, 415,
658, 327,
127, 419,
  }, N2=MAX;

  if(ac<3) return 1;

  im =ImageRead(av[1]);
  im2=ImageRead(av[2]);

  mt=MatrixAlloc(N1,N2);
  calcSSDtable(mt,im,x1,N1,im2,x2,N2);
  
  double w[999][4];
  int nm;
  nm=matchMethod2(w,mt,im,x1,N1,im2,x2,N2);//特徴点の対応付け

  return 0;
}