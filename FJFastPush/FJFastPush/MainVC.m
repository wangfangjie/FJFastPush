//
//  MainVC.m
//  FJFastPush
//
//  Created by wangfj on 2017/8/9.
//  Copyright © 2017年 FJFastPush. All rights reserved.
//

#import "MainVC.h"
#import "FJFastPush.h"
@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *pushNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushNextButton.frame = CGRectMake(100, 100, 200, 50);
    [pushNextButton setTitle:@"pushnext" forState:UIControlStateNormal];
    [pushNextButton addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushNextButton];
    
    UIButton *pushSelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushSelfButton.frame = CGRectMake(100, 200, 200, 50);
    [pushSelfButton setTitle:@"pushself" forState:UIControlStateNormal];
    [pushSelfButton addTarget:self action:@selector(pushSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushSelfButton];
}

-(void)pushNext
{
    FJ_PUSH_VC(@"OtherVC", @{@"titleStr":@"other"});
}

-(void)pushSelf
{
    FJ_PUSH_VC(@"MainVC", nil);
}
























@end
