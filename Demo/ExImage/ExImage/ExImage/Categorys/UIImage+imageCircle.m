//
//  UIImage+imageCircle.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIImage+imageCircle.h"

@interface BJCircleView: UIView

@property (nonatomic, strong) UIImage *image;

@end

@implementation BJCircleView

-(void)drawRect:(CGRect)rect{
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contexRef);
    
    CGContextAddEllipseInRect(contexRef, CGRectMake(0, 0, rect.size.width/2, rect.size.height/2));
    CGContextClip(contexRef);
    CGContextFillPath(contexRef);
    [_image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRestoreGState(contexRef);
}

@end

@implementation UIImage (imageCircle)

- (UIImage *)imageClipCircle{
    CGFloat imageSizeMin = MIN(self.size.width, self.size.height);
    CGSize imageSize = CGSizeMake(imageSizeMin, imageSizeMin);
    
    BJCircleView *view = [[BJCircleView alloc] init];
    view.image = self;
    
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    view.frame = CGRectMake(0, 0, imageSizeMin, imageSizeMin);
    view.backgroundColor = [UIColor whiteColor];
    [view.layer renderInContext:context];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
