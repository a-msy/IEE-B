#include "image.h"

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