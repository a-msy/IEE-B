#include "image.h"

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