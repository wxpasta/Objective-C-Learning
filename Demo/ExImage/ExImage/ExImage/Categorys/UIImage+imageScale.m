//
//  UIImage+imageScale.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIImage+imageScale.h"

@implementation UIImage (imageScale)

- (UIImage *)imageScaleSize:(CGSize )size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
