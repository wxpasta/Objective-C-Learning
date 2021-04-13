//
//  UIView+imageScreenShot.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIView+imageScreenShot.h"

@implementation UIView (imageScreenShot)

- (UIImage *)imageScreenShot{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
