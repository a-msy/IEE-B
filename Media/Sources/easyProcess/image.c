#include "image.h"

union {int i; float f;} _inf={0x7f800000};
#define INFINITY _inf.f // 2重定義エラーが出るなら，この定義を削除
#define INFINITY_INT _inf.i

Image *ImageAlloc(int w, int h)
{
    Image *im = (Image *)malloc(sizeof(Image));
    im->W = w;
    im->H = h;
    im->data = (unsigned char *)malloc(3 * w * h);
    return im;
}

void ImageClear(Image *im){
    for(int y=0;y<im->H;y++){
        for(int x=0;x<im->W;x++){
            IElem(im,x,y,0) = 0;
            IElem(im,x,y,1) = 0;
            IElem(im,x,y,2) = 0;
        }
    }
}
void mult33(double d[3][3],double a[3][3],double b[3][3]){
    for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
            d[i][j] = a[i][0]*b[0][j] + a[i][1]*b[1][j] + a[i][2]*b[2][j];
        }
    }
}

void ImageImageProjectionAlpha(Image*id,Image*is,double a[3][3],double alpha){
  int x,y,u,v;
  double r;
  for(y=0;y<id->H;y++) for(x=0;x<id->W;x++){
    r=1/(a[2][0]*x+a[2][1]*y+a[2][2]);
    u=r*(a[0][0]*x+a[0][1]*y+a[0][2]);
    v=r*(a[1][0]*x+a[1][1]*y+a[1][2]);
    if( isInsideImage(is,u,v) ){
      IElem(id,x,y,0)+=IElem(is,u,v,0)*alpha,
      IElem(id,x,y,1)+=IElem(is,u,v,1)*alpha,
      IElem(id,x,y,2)+=IElem(is,u,v,2)*alpha;
    }
  }
}

Matrix *MatrixAlloc(int _H,int _W){
  Matrix*mt=(Matrix*)malloc(sizeof(Matrix));
  mt->W = _W;
  mt->H = _H;
  mt->data=(double*)malloc(mt->W*mt->H*sizeof(double));
  return mt;
}

Image *ImageRead(const char *name)
{
    int W, H;
    Image *im;
    char tmp[128];
    sprintf(tmp, "convert %s ppm:-", name);
    FILE *fp = popen(tmp, "r");
    if (fp == NULL)
    {
        fprintf(stderr, "could not read %s\n", name);
        return 0;
    }
    fscanf(fp, "%*s%d%d%*s%*c", &W, &H);
    //fprintf(stderr,"w x h=%d %d\n",W,H);
    im = ImageAlloc(W, H);
    fread(im->data, 1, W * H * 3, fp);
    pclose(fp);
    return im;
}

void ImageWrite(const char *name, Image *im)
{
    char tmp[128];
    sprintf(tmp, "convert ppm:- %s", name);
    FILE *fp = popen(tmp, "w");
    if (fp == NULL)
    {
        fprintf(stderr, "could not write %s\n", name);
        return;
    }
    fprintf(fp, "P6 %d %d 255\n", im->W, im->H);
    fwrite(im->data, 1, im->W * im->H * 3, fp);
    pclose(fp);
}

double ImageSSD(Image*im,int x1,int y1, Image*im2,int x2,int y2,int W){
  int i,j;
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

void calcSSDtable(Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2,int W){
    int i,j;
    #pragma omp parallel for private (j)
    for(i=0;i<N1;i++){
        for(j=0;j<N2;j++){
            Elem(mt,i,j) = ImageSSD(im ,x1[i][0],x1[i][1],im2,x2[j][0],x2[j][1], W);
        }
    }
}

int matchMethod1(double w[][4],Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2){
  int i,j,k,ji,n=0;

  for(i=0;i<N1;i++){
    double sm=INFINITY,t;
    for(j=0;j<N2;j++){
      t = Elem(mt,i,j);
      if(sm>t) sm=t, ji=j;
    }
    //printf("%d,%d,%d,%d,\n",x1[i][0],x1[i][1],x2[ji][0],x2[ji][1]);
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

int matchMethod2(double w[][4],Matrix*mt,Image*im ,int x1[][3],int N1,Image*im2,int x2[][3],int N2){
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
    //printf("%d,%d,%d,%d,\n",x1[minElem[0]][0],x1[minElem[0]][1],x2[minElem[1]][0],x2[minElem[1]][1]);
    w[n][0] = x1[minElem[0]][0];
    w[n][1] = x1[minElem[0]][1];
    w[n][2] = x2[minElem[1]][0];
    w[n][3] = x2[minElem[1]][1];
    n++;
    minElem[2]=INFINITY_INT;
  }
  return n;
}

void ImageFeature(Matrix*im2,Image*im,int W){//特徴点らしさ
  int x,y,u,v,ix,iy;
  for(y=W+1;y<im->H-W-1;y++) for(x=W+1;x<im->W-W-1;x++){
        double ixx,ixy,iyy;
        ixx=iyy=ixy=0;
        for(v=-W;v<=W;v++)for(u=-W;u<=W;u++){
            ix = IElem(im, x+u+1, y+v, 1) - IElem(im, x+u-1, y+v, 1);
            iy = IElem(im, x+u, y+v+1, 1) - IElem(im, x+u, y+v-1, 1);
            ixx += ix*ix; // ixx だけでなく ixy,iyy も計算する． 
            iyy += iy*iy;
            ixy += ix*iy;
    }
    DElem(im2,x,y) = ((ixx + iyy)-sqrt(pow(ixx+iyy,2.0)-4.0*(ixx*iyy-ixy*ixy)))/2.0; 
  }
}

int MatrixLocalMax(int w[][3], Matrix*im2, int W){//特徴点がほんとにそうかどうか
  int x,y,u,v,n=0,a;
  for(y=W+1;y<im2->H-W-1;y++) for(x=W+1;x<im2->W-W-1;x++){
    double max=-1;
    for(v=-W;v<=W;v++) for(u=-W;u<=W;u++){
      if(DElem(im2, x+u, y+v) > max){
        max = DElem(im2,x+u,y+v);
      }
    }
    if( max == DElem(im2, x, y) ){
      a = n;
      if(n < MAX) { n++; }
      for(;a>0 && w[a-1][2] < DElem(im2, x, y);a--){
        w[a][0]=w[a-1][0]; w[a][1]=w[a-1][1]; w[a][2]=w[a-1][2];
      }
      w[a][0]=x; w[a][1]=y; w[a][2]=max;
    }
  }
  return n; // 記録した点の数 
}
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
  double t;
  int W = mt->W;
  double **aT = (double **)malloc((sizeof (double *)) * mt->H);
  for(int get=0; get<mt->H;get++){
    aT[get] = Row(mt,get);
  }
  MatrixClear(mtR);
  for(int i=0; i < W; i++){
    for(int j=0; j <= i; j++){
      if(j == i){
        Elem(mtR,j,i) = t = sqrt(VP(aT[j],aT[i],W));
        VSS(aT[i], 1/t, W);
      }else{
        Elem(mtR,j,i) = t = VP(aT[j], aT[i], W);
        VSA(aT[i], aT[j], -t, W);
      }
    }
  }
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
}