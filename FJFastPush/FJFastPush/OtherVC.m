//
//  OtherVC.m
//  FJFastPush
//
//  Created by wangfj on 2017/8/9.
//  Copyright © 2017年 FJFastPush. All rights reserved.
//

#import "OtherVC.h"
#import "FJFastPush.h"
#import "ThirdVC.h"
@interface OtherVC ()

@end

@implementation OtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    NSLog(@"标题%@",_titleStr);
    self.title = _titleStr;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 50);
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *testbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    testbutton.frame = CGRectMake(100, 200, 200, 50);
    [testbutton setTitle:@"textBlock" forState:UIControlStateNormal];
    [testbutton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testbutton];
}

-(void)goBack
{
    NSLog(@"点击");
    
    FJ_PUSH_VC(@"ThirdVC", @{@"titleName":@"第三个VC"});
    
    
}

-(void)testButtonClick:(id)sender
{
    NSLog(@"Block");
    
}

@end
