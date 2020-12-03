// cl /Ox TKfilter.c image.c image2.cxx && TKfilter 0.jpg
// gcc TKfilter2.c image.c image2.c -lm -O3 -mavx2 -march=native -funroll-loops -fomit-frame-pointer && ./a.out 0.jpg 7

#include"image.h"
#include<math.h>

/*
 The following should be defined (in image.h and image.c):
  - structures Image and Matrix
  - related macros (IElem, ,Elem, DElem)
  - related functions (ImageAlloc, MatrixAlloc, ...)
 */

#define CPU_KHZ 3.9e+6

#ifdef _WIN32
#include<intrin.h>
#else
#define __rdtsc() ({ long long a,d; __asm__ volatile ("rdtsc":"=a"(a),"=d"(d)); d<<32|a; })
#endif

int desc(int left[3], int right[3])
{
  return right[2]-left[2];
}

void ImageDrawBox(Image*im,int x,int y,int W){
  int u,v;
  for(v=-W;v<=W;v++){
      for(u=-W;u<=W;u++){
        IElem(im,x+u,y+v,0)=IElem(im,x+u,y+v,0) + 0xff >> 1;
        IElem(im,x+u,y+v,1)=IElem(im,x+u,y+v,1) >> 1;
        IElem(im,x+u,y+v,2)=IElem(im,x+u,y+v,2) >> 1;
    }
  }
}

void ImageMatrixWrite(Image*im,Matrix*mt,double s){
  int x,y,p;
  for(y=0;y<mt->H;y++) for(x=0;x<mt->W;x++){
    double tmp=mt->data[y*mt->W+x]*s;
    if(tmp>255) tmp=255;
    im->data[(y*im->W+x)*3+0] = im->data[(y*im->W+x)*3+1] = im->data[(y*im->W+x)*3+2] = tmp;
  }
}

void ImageFeature(Matrix*im2,Matrix*im3,Matrix*im4,Matrix*im5,Image*im,int W){
  int x,y,u,v,ix,iy;
  for(y=1;y<im->H-1;y++) for(x=W+1;x<im->W-W-1;x++){
        double ixx,ixy,iyy;
        ixx=iyy=ixy=0;
        for(u=-W;u<=W;u++){
          ix = IElem(im, x+u+1, y, 1) - IElem(im, x+u-1, y, 1);
          iy = IElem(im, x+u, y, 1) - IElem(im, x+u, y-1, 1);
          ixx += ix*ix;
          iyy += iy*iy;
          ixy += ix*iy;
    }
    DElem(im3,x,y) = ixx;
    DElem(im4,x,y) = ixy;
    DElem(im5,x,y) = iyy;
  }
    for(y=W+1;y<im->H-W-1;y++) for(x=W+1;x<im->W-W-1;x++){
        double ixx,ixy,iyy;
        ixx=iyy=ixy=0;
        for(v=-W;v<=W;v++){
          ixx += DElem(im3, x, y+v);
          ixy += DElem(im4, x, y+v);
          iyy += DElem(im5, x, y+v);
    }
    DElem(im2,x,y) = ((ixx + iyy)-sqrt(pow(ixx+iyy,2.0)-4.0*(ixx*iyy-ixy*ixy)))/2.0;
  }
}

int MatrixLocalMax(int w[][3], Matrix*im2, Matrix*im3, int W){
  int x,y,u,v,n=0,a=0;
  // double max=-1;
  // for(y=1;y<im2->H-1;y++) for(x=W+1;x<im2->W-W-1;x++){
  //   for(u=-W;u<=W;u++){
  //     if(DElem(im2, x+u, y) > max){
  //       DElem(im3,x,y) = DElem(im2, x+u, y);
  //     }
  //   }
  // }
  // for(y=W+1;y<im2->H-W-1;y++) for(x=W+1;x<im2->W-W-1;x++){
  //   for(v=-W;v<=W;v++){
  //   }
  // }
  for(y=W+1;y<im2->H-W-1;y++){
    for(x=W+1;x<im2->W-W-1;x++){
      double max=-1;
      for(v=-W;v<=W;v++){
        for(u=-W;u<=W;u++){
          // (x,y) を中心とする 15x15 の矩形領域内で DElem(im2,x+u,y+v) の最大値を探す．
          if(DElem(im2, x+u, y+v) > max){
            max = DElem(im2,x+u,y+v);
          } 
        }
      }
      // 最大値が DElem(im2,x,y) と等しいなら，(x,y) を特徴点として記録する． 
      if(max == DElem(im2,x,y)){
        a = n++; 
        w[a][0] = x;
        w[a][1] = y;
        w[a][2] = max;
      }
    }
  }
  return n; // 記録した点の数 
}

void debug(int w[][3],int kw){
  for(int i=0; i<kw; i++){
    printf("%d %d %d\n",w[i][0],w[i][1],w[i][2]);
  }
}

void debug2(int w[][3],int kw){
  for(int i=0; i<30; i++){
    printf("%d,%d,\n",w[i][0],w[i][1]);
  }
}


int main(int ac,char**av){
  Image *im;
  Matrix *im2,*im3,*im4,*im5;
  int kk[9999][3], kw,i;
  // av[2]が小さすぎるとセグフォ
  if(ac<1){ fprintf(stderr,"Specify an image to process.\n"); return 1; }

  im=ImageRead(av[1]);
  im2=MatrixAlloc(im->H,im->W);
  im3=MatrixAlloc(im->H,im->W);
  im4=MatrixAlloc(im->H,im->W);
  im5=MatrixAlloc(im->H,im->W);
  long long start=__rdtsc();
  ImageFeature(im2,im3,im4,im5,im,atoi(av[2]));
  kw = MatrixLocalMax(kk,im2,im3,atoi(av[2]));
  printf("%f msec\n",(__rdtsc()-start)/CPU_KHZ);
  qsort(kk, kw, sizeof(kk[0]),desc);
  debug2(kk,kw);
  ImageMatrixWrite(im,im2,.001);
  for(i=0;i<30;i++) ImageDrawBox(im,kk[i][0],kk[i][1],atoi(av[2]));//ここで５０個だけとかにできる
  ImageWrite("out.jpg",im);
  return 0;
}