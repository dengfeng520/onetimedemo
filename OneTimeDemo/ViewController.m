//
//  ViewController.m
//  OneTimeDemo
//
//  Created by rp.wang on 2018/1/30.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import "ViewController.h"
#import "SubClass.h"
#import "OneTimeClass+Add.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    OneTimeClass *onetime1 = [OneTimeClass sharedOneTimeClass];
    NSLog(@"shared:============%@",onetime1);
//    OneTimeClass *onetime2 = [[OneTimeClass alloc]init];
//    NSLog(@"new:============%@",onetime2);
    
//    NSLog(@"new:============%@",[OneTimeClass new]);
    
    
//    NSLog(@"SubClass:============%@",[SubClass new]);
    [onetime1 printStr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
