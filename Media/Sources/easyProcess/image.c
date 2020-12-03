#include "image.h"

Image *ImageAlloc(int w, int h)
{
    Image *im = (Image *)malloc(sizeof(Image));
    im->W = w;
    im->H = h;
    im->data = (unsigned char *)malloc(3 * w * h);
    return im;
}