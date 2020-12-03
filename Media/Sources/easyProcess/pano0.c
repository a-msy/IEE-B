// cl /Ox pano0.c image.c image2.cxx && pano0 && 0.jpg
// gcc --no-warnings -O pano0.c image.c image2.c && ./a.out && display out.jpg

#include"image.h"

// Following functions must be defined in image.c:
//   ImageAlloc, ImageClear.

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

int main(){
  Image *im,*id;

  id=ImageAlloc(1024,768);
  ImageClear(id);

  {
    double m0d[][3]={
      1,0,-100,
      0,1,-100,
      0,0,1
    };
    im=ImageRead("0.jpg");
    ImageImageProjectionAlpha(id,im,m0d,.5);
    double m10[][3]={
      0.930421,   0.018946,   118.490952,
      -0.043542,  0.976597,   22.193656,
      -0.000097,  0.000002,   1.000000 
    }, m1d[3][3];
    mult33(m1d,m10,m0d);
    im = ImageRead("1.jpg");
    ImageImageProjectionAlpha(id,im,m1d,.5);
  }

  ImageWrite("out.jpg",id);

  return 0;
}