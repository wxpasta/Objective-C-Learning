//
//  ViewController.m
//  AddLoad
//
//  Created by 巴糖 on 2021/3/5.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    +load方法会在runtime加载类、分类时调用

    每个类、分类的+load，在程序运行过程中只调用一次

    调用顺序
    先调用类的+load
    按照编译先后顺序调用（先编译，先调用）
    调用子类的+load之前会先调用父类的+load

    再调用分类的+load
    按照编译先后顺序调用（先编译，先调用）
     */
}


@end
