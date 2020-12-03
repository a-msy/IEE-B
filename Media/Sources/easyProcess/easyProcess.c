#include"image.h"

/* (x,y) ‚ª (xx,yy) ‚ğ’†S‚Æ‚·‚é”¼Œa 256 ‚Ì‰~“à‚©”»’è */
int disk(double x, double y, double xx, double yy) {
    if ((x - xx) * (x - xx) + (y - yy) * (y - yy) < 65536) return 255;
    return 0;
}

void Process(Image* dst, Image* src) {
    int x, y;
    for (y = 0; y < src->H; y++)
        for (x = 0; x < src->W; x++) {
            IElem(dst, x, y, 0) = IElem(src, x, y, 0) * disk(x, y, 320, 180) / 256; // red at (x,y)
            IElem(dst, x, y, 1) = IElem(src, x, y, 1) * disk(x, y, 260, 300) / 256; // green at (x,y)
            IElem(dst, x, y, 2) = IElem(src, x, y, 2) * disk(x, y, 380, 300) / 256; // blue at (x,y)
        }
}

int main(int argc, char** argv) {
    Image* src = ImageRead(argv[1]),
        * dst = ImageAlloc(src->W, src->H);
    Process(dst, src);
    ImageWrite(argv[2], dst);
    return 0;
}