//
//  UIImage+imageCut.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIImage+imageCut.h"

@implementation UIImage (imageCut)

- (UIImage *)imageCutRect:(CGRect )rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect samllRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(samllRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, samllRect, subImageRef);
    UIImage *image = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    return image;
}

@end
