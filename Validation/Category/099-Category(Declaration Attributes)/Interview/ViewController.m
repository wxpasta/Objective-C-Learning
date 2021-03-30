//
//  ViewController.m
//  iOSInterviewBlock
//
//  Created by 巴糖 on 2021/3/22.
//

#import "ViewController.h"
#import "ViewController+Test.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.name = @"Name";
    
    
    // self.weight = 10;
    
    /*
     *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[ViewController setWeight:]: unrecognized selector sent to instance 0x7faba3d04ec0'
     */
    
}

@end
