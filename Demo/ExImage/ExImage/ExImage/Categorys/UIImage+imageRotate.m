//
//  UIImage+imageRotate.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIImage+imageRotate.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (imageRotate)

- (UIImage *)imageRotateIndegree:(float)degree{
    size_t width = (size_t) (self.size.width * self.scale);
    size_t height = (size_t) (self.size.height * self.scale);
    // 表明每行 图片数据字节
    size_t bytePerRow = width *4;
    // alpha
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;
    // 配置上下文参数
    CGContextRef bmContex = CGBitmapContextCreate(NULL, width, height, 8, bytePerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alphaInfo);
    if (!bmContex) {
        return nil;
    }
    CGContextDrawImage(bmContex, CGRectMake(0, 0, width, height), self.CGImage);
    // 旋转
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(bmContex);
    vImage_Buffer src = {data, height, width, bytePerRow};
    vImage_Buffer dest = {data, height, width, bytePerRow};
    Pixel_8888 bgColor ={0, 0, 0, 0};
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    // uiimage
    CGImageRef rotateImageRef = CGBitmapContextCreateImage(bmContex);
    UIImage *rotateImage = [UIImage imageWithCGImage:rotateImageRef scale:self.scale orientation:self.imageOrientation];
    return  rotateImage;
}

@end
