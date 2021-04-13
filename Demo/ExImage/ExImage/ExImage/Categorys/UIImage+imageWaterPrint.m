//
//  UIImage+imageWaterPrint.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/28.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "UIImage+imageWaterPrint.h"

@implementation UIImage (imageWaterPrint)

- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString *)waterString{
    UIGraphicsBeginImageContext(self.size);
    // 原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGFloat waterX = 0;
    CGFloat waterY = 0;
    CGFloat waterW = 80;
    CGFloat waterH = 80;
    // logo 渲染
    [imageLogo drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    // 渲染文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary *dic = @{
                          NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                          NSParagraphStyleAttributeName: paragraphStyle,
                          NSForegroundColorAttributeName: [UIColor whiteColor]
                          };
    [waterString drawInRect:CGRectMake(0, self.size.height - 60, self.size.width - 10, 60) withAttributes:dic];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
