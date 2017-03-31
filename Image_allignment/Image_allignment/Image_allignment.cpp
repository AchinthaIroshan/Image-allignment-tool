// Image_allignment.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "opencv2/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
using namespace cv;
//using namespace std;

int main()
{
	Mat a = imread("C:\\Users\\\Achintha Iroshan\\Desktop\\LED.jpg");
	namedWindow("image", WINDOW_AUTOSIZE);
	imshow("image", a);
	waitKey(0); //wait infinite time for a keypress
    return 0;
}

