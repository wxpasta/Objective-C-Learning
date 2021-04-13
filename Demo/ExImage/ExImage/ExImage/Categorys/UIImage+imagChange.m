//
//  UIImage+imagChange.m
//  ExImage
//
//  Created by magic-devel on 2020/11/2.
//  Copyright © 2020 巴糖. All rights reserved.
//

#import "UIImage+imagChange.h"

@implementation UIImage (imagChange)

//图片置灰操作
+ (UIImage *)changeGrayImage:(UIImage *)oldImage {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *superImage = [CIImage imageWithCGImage:oldImage.CGImage];
        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
        [lighten setValue:superImage forKey:kCIInputImageKey];
 // 修改亮度   -1---1   数越大越亮
        [lighten setValue:@(0) forKey:@"inputBrightness"];
        // 修改饱和度  0---2
        [lighten setValue:@(0) forKey:@"inputSaturation"];
  // 修改对比度  0---4
        [lighten setValue:@(0.5) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
        // 得到修改后的图片
        UIImage *newImage =  [UIImage imageWithCGImage:cgImage];
        // 释放对象
        CGImageRelease(cgImage);
    return newImage;
}

@end
