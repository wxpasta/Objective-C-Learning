//
//  ViewController.m
//  ExImage
//
//  Created by 巴糖 on 2017/9/27.
//  Copyright © 2017年 巴糖. All rights reserved.
//

#import "ViewController.h"
// webp
#import "YYImage.h"

// GIF 分解
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIView+imageScreenShot.h"
#import "UIImage+imageRotate.h"
#import "UIImage+imageScale.h"
#import "UIImage+imageCut.h"
#import "UIImage+imageCircle.h"
#import "UIImage+imageWaterPrint.h"


#import "UIImage+imagChange.h"

@interface ViewController ()

@property (nonatomic, strong) YYImageDecoder *decoder;

@property (nonatomic, assign)int i;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)imageTest{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *changeImage = [UIImage changeGrayImage:image];
    UIImageWriteToSavedPhotosAlbum(changeImage, self, nil, nil);
}

- (void)imageTestWater{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *imageLogo = [UIImage imageNamed:@"Garfield01.jpg"];
    UIImage *imageNew = [image imageWater:imageLogo waterString:@"巴糖"];
    UIImageWriteToSavedPhotosAlbum(imageNew, self, nil, nil);
}
- (void)imageTestCircle{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *imageNew = [image imageClipCircle];
    UIImageWriteToSavedPhotosAlbum(imageNew, self, nil, nil);
}

- (void)imageTestCut{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *imageNew = [image imageCutRect:CGRectMake(100, 100, 320, 200)];
    UIImageWriteToSavedPhotosAlbum(imageNew, self, nil, nil);
}

- (void)imageTestScale{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *imageNew = [image imageScaleSize:CGSizeMake(200, 500)];
    UIImageWriteToSavedPhotosAlbum(imageNew, self, nil, nil);
}

- (void)imageTestScreen{
    UIImage *image = [self.view imageScreenShot];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)imageTestRotate{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    UIImage *imageNew = [image imageRotateIndegree: M_PI / 180 * 45];
    UIImageWriteToSavedPhotosAlbum(imageNew, self, nil, nil);
}

#pragma mark - 图片转化
- (void)jpgToPng{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *imagePNG = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(imagePNG, self, nil, nil);
}

- (void)jpgToJpg{
    UIImage *image = [UIImage imageNamed:@"timg.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.4);
    UIImage *imageJPG = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(imageJPG, self, nil, nil);
}

#pragma mark - Webp
- (void)roadWebP{
    NSURL *webUrl = [[NSBundle mainBundle] URLForResource:@"GarfieldWebp" withExtension:@"webp"];
    NSData *data = [NSData dataWithContentsOfURL:webUrl];
    _decoder = [YYImageDecoder decoderWithData:data scale:1.0];
    self.i = 0;
    UIImage *imageWebp = [_decoder frameAtIndex:self.i decodeForDisplay:YES].image;
    UIImageWriteToSavedPhotosAlbum(imageWebp, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != nil) {
        NSLog(@"error = %@",error);
    }else{
        NSLog(@"success");
        self.i++;
        UIImage *imageWebp = [_decoder frameAtIndex:self.i decodeForDisplay:YES].image;
        if (imageWebp != nil) {
            UIImageWriteToSavedPhotosAlbum(imageWebp, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
#pragma mark - GIF 分解
// 1.拿到gif数据
// 2.将gif分解每一帧
// 3.单帧抓化UIimage
// 4.单帧图片保存
- (void)deCompositionGif{
    NSString *pathGif = [[NSBundle mainBundle] pathForResource:@"Garfield" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:pathGif];
    
    CGImageSourceRef source = CGImageSourceCreateWithData( (__bridge CFDataRef) data, NULL);
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *tmpArray = [[NSMutableArray array] init];
    for (size_t i = 0; i < count ; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [tmpArray addObject:image];
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    int i = 0;
    for (UIImage *image in tmpArray) {
        NSData *data = UIImagePNGRepresentation(image);
        NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathGif = document[0];
        NSLog(@"path = %@ ",pathGif);
        NSString * pathNum = [pathGif stringByAppendingString:[NSString stringWithFormat:@"/Garfield%02d.png", (i+1)]];
        i++;
        [data writeToFile:pathNum atomically:NO];
    }
}

#pragma mark - Gif合成
// 1.获取数据
// 2.创建gif
// 3.配置gif
// 4.每帧添加到gif中
- (void)createGif{
    NSMutableArray *images = [[NSMutableArray alloc] initWithObjects:
                              [UIImage imageNamed:@"Garfield01.jpg"],
                              [UIImage imageNamed:@"Garfield02.jpg"],
                              [UIImage imageNamed:@"Garfield03.jpg"],
                              [UIImage imageNamed:@"Garfield04.jpg"],
                              [UIImage imageNamed:@"Garfield05.jpg"],
                              [UIImage imageNamed:@"Garfield06.jpg"],
                              [UIImage imageNamed:@"Garfield07.jpg"],
                              [UIImage imageNamed:@"Garfield08.jpg"],
                              [UIImage imageNamed:@"Garfield09.jpg"],
                              nil];
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDic = [documentStr stringByAppendingString:@"/gif"];
    [fileManager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDic stringByAppendingString:@"/test1.gif"];
    NSLog(@"path = %@ ",path);
    
    CGImageDestinationRef destion;
    CFURLRef urlRef = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,  (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(urlRef, kUTTypeGIF, images.count, NULL);
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3],(NSString *)kCGImagePropertyGIFDelayTime, nil];
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDelayTime];
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString *)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (UIImage *dImage in images) {
        CGImageDestinationAddImage(destion, dImage.CGImage,( __bridge CFDictionaryRef) frameDic);
    }
    CGImageDestinationSetProperties(destion, ( __bridge CFDictionaryRef) gifProperty);
    CGImageDestinationFinalize(destion);
    CFRelease(destion);
}

#pragma mark - 动画
- (void)animationJPG{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i < 10; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Garfield%02d",i];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [images addObject:image];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    [imageView setAnimationImages:images];
    [imageView setAnimationRepeatCount:10];
    [imageView setAnimationDuration:2];
    [imageView startAnimating];
}

@end
