#include "image.h"

#define TRIAL 1000000

void initRndAry(int rndAry[MAX]){
    for(int i = 0; i<MAX; i++){
        rndAry[i] = i;
    }
    srand(__rdtsc()); // __rdtsc については第４回を参照．
}

void chooseFourNumbers(int rndAry[MAX]){
    for(int i=0;i<4;i++){
        int j, t;
        j = (int)((long long)rand()*(MAX-i)/(RAND_MAX+1LL))+i; // 乱数関数は stdlib.h で宣言されている．
        t = rndAry[i]; 
        rndAry[i] = rndAry[j]; 
        rndAry[j] = t;
    }
}

void calcHomography(double H[3][3],double w[][4],int rndAry[MAX], Matrix *cmA, Matrix *vt, Matrix *mtR, Matrix *tmp){
    int a = rndAry[0], b = rndAry[1], c = rndAry[2], d = rndAry[3];
    double ww[][4] = {
        w[a][0], w[a][1], w[a][2], w[a][3],
        w[b][0], w[b][1], w[b][2], w[b][3],
        w[c][0], w[c][1], w[c][2], w[c][3],
        w[d][0], w[d][1], w[d][2], w[d][3],
    };
      // create A (col-major)
    for(int i=0;i<4;i++){
        Elem(cmA,0,i*2  )=ww[i][0];
        Elem(cmA,1,i*2  )=ww[i][1];
        Elem(cmA,2,i*2  )=1;
        Elem(cmA,3,i*2  )=0;
        Elem(cmA,4,i*2  )=0;
        Elem(cmA,5,i*2  )=0;
        Elem(cmA,6,i*2  )=-ww[i][0]*ww[i][2];
        Elem(cmA,7,i*2  )=-ww[i][1]*ww[i][2];
        Elem(cmA,0,i*2+1)=0;
        Elem(cmA,1,i*2+1)=0;
        Elem(cmA,2,i*2+1)=0;
        Elem(cmA,3,i*2+1)=ww[i][0];
        Elem(cmA,4,i*2+1)=ww[i][1];
        Elem(cmA,5,i*2+1)=1;
        Elem(cmA,6,i*2+1)=-ww[i][0]*ww[i][3];
        Elem(cmA,7,i*2+1)=-ww[i][1]*ww[i][3];
        Elem(vt ,0,i*2  )=ww[i][2];
        Elem(vt ,0,i*2+1)=ww[i][3];
    }
    MatrixQRDecompColMajor(mtR,cmA);
    MatrixMultT(tmp,vt,cmA);
    MatrixSimeqLr(tmp,mtR);

    H[0][0] = Elem(tmp,0,0);
    H[0][1] = Elem(tmp,0,1);
    H[0][2] = Elem(tmp,0,2);
    H[1][0] = Elem(tmp,0,3);
    H[1][1] = Elem(tmp,0,4);
    H[1][2] = Elem(tmp,0,5);
    H[2][0] = Elem(tmp,0,6);
    H[2][1] = Elem(tmp,0,7);
    H[2][2] = 1;
}

int calcScore(double H[3][3], double w[][4]){
    int score=0;
    for(int i=0;i<MAX;i++){
        double x=w[i][0], y=w[i][1], u=w[i][2], v=w[i][3],
        x_prime = H[0][0] * x + H[0][1] * y + H[0][2],
        y_prime = H[1][0] * x + H[1][1] * y + H[1][2],
        z_prime = H[2][0] * x + H[2][1] * y + H[2][2], // 変換行列と (x,y,1)^T の積
	    du = (x_prime/z_prime) - u,
        dv = (y_prime/z_prime) -v; // (x,y) を変換した座標(第2回の概要を参照)と (u,v) の差
        if(du*du+dv*dv < 10) score++;//w[i] は正しい;
        else score += 0;              //w[i] は正しくない;
    }
    return score;
}

void createPanorama(Matrix *id, Image *im, Image *im2, int bestH[3][3]){
    double m0d[3][3]={
      1,0,-100,
      0,1,-100,
      0,0,1
    },m1d[3][3];
    ImageImageProjectionAlpha(id,im,m0d,.5);
    mult33(m1d,bestH,m0d);
    ImageImageProjectionAlpha(id,im2,m1d,.5);
    ImageWrite("dai8.jpg",id);
}

int main(int ac,char**av){
    Image *im, *im2;
    Matrix *imf, *mt, *id;
    int N1, N2, nm;
    double w[999][4];

    /*av[1] = Wの値，それ以降は画像ファイル名*/
    im = ImageRead("0.jpg");
    im2 = ImageRead("2.jpg");
    imf = MatrixAlloc(im->H, im->W);

    ImageFeature(imf, im, 7);
    N1 = MatrixLocalMax(x1, imf, 7);
    ImageFeature(imf, im2, 7);
    N2 = MatrixLocalMax(x2, imf, 7);
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
  };
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
    };

    mt = MatrixAlloc(N1, N2);
    calcSSDtable(mt, im, x1, N1, im2, x2, N2, 7);
    nm = matchMethod2(w, mt, im, x1, N1, im2, x2, N2);

    // 多数の変換行列から最も信頼度の高い行列を選ぶ(RANSAC)
    double bestH[3][3]; 
    int best_score = 0; // 既に発見された最良の変換行列と得点
    int rndAry[MAX];
    Matrix *cmA, *vt, *mtR, *tmp; // 作業領域をここで確保して calcHomography で使う

    cmA = MatrixAlloc(8,8);
    vt = MatrixAlloc(1,8);
    mtR = MatrixAlloc(8,8);
    tmp = MatrixAlloc(1,8);
    initRndAry(rndAry);

    for(int trial = 0; trial<TRIAL; trial++){

        double H[3][3]; // 選んだ4点から計算される変換行列の置き場
        chooseFourNumbers(rndAry);
        calcHomography(H,w,rndAry,cmA,vt,mtR,tmp);
        int score = calcScore(H,w);

        if(best_score < score){ 
            bestH[0][0] = H[0][0];
            bestH[0][1] = H[0][1];
            bestH[0][2] = H[0][2];
            bestH[1][0] = H[1][0];
            bestH[1][1] = H[1][1];
            bestH[1][2] = H[1][2];
            bestH[2][0] = H[2][0];
            bestH[2][1] = H[2][1];
            bestH[2][2] = H[2][2];
            best_score = score;
        }
    }

    id = ImageAlloc(1024,768);
    ImageClear(id);
    createPanorama(id, im, im2, bestH);

    return 0;
}
