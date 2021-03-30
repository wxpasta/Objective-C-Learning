//
//  ViewController.m
//  iOSInterviewBlock
//
//  Created by 巴糖 on 2021/3/22.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController


/*
 (void)viewDidLoad -> static void _I_ViewController_viewDidLoad(ViewController * self, SEL _cmd)
 self 这里是局部变量，block截获
 并在结构体内生成变量ViewController *self
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.name = @"haha";
    void(^blockName)(void) = ^() {
        NSLog(@"self.name %@", self.name);
        
    };
    self.name = @"xxx";
    
    blockName();
    
    
    
    
}

@end
