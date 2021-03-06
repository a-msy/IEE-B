// cl /Ox homography.c image.c image2.cxx && homography 1.jpg out.jpg && out.jpg
// gcc --no-warnings -O homography.c image.c image2.c && ./a.out 1.jpg out.jpg && display out.jpg

#include"image.h"

// Following functions must be defined in image.c:
//   ImageAlloc, ImageClear

void ImageImageProjection(Image*id,Image*is,double a[3][3]){
  int x,y,u,v;
  double r;
  for(y=0;y<id->H;y++) for(x=0;x<id->W;x++){
    r=1/(a[2][0]*x+a[2][1]*y+a[2][2]);
    u=r*(a[0][0]*x+a[0][1]*y+a[0][2]);
    v=r*(a[1][0]*x+a[1][1]*y+a[1][2]);
    if( isInsideImage(is,u,v) ){
      IElem(id,x,y,0)=IElem(is,u,v,0),
      IElem(id,x,y,1)=IElem(is,u,v,1),
      IElem(id,x,y,2)=IElem(is,u,v,2);
    }
  }
}

int main(int argc,char*argv[]){
  Image *im,*im2;
  // double a[][3]={
  //    .866 , -.5  ,  160,
  //    .5   , .866 , -300,
  //    0    , 0    , 1
  // };
  
  double a[][3]={
    0.5, 0, 0,
    0, 0.5, 0,
    0, 0, 1
  };
  double b[][3]={
     .866 , -.5  ,  160,
     .5   , .866 , -300,
     -.001, 0    , 1
  };

  im=ImageRead(argv[1]);

  im2=ImageAlloc(1024,768);
  ImageClear(im2);
  ImageImageProjection(im2,im,a);
  ImageWrite(argv[2],im2);

  return 0;
}