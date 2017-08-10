//
//  ThirdVC.m
//  FJFastPush
//
//  Created by wangfj on 2017/8/9.
//  Copyright © 2017年 FJFastPush. All rights reserved.
//

#import "ThirdVC.h"
#import "FJFastPush.h"
@interface ThirdVC ()

@end

@implementation ThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    self.title = _titleName;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 50);
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)goBack
{
    NSLog(@"点击");
    
    FJ_POP_TO_VC_BY_CLASSNAME(@"MainVC");
}

@end
