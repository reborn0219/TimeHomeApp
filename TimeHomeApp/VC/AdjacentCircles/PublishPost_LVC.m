//
//  PublishPost_LVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PublishPost_LVC.h"

@implementation PublishPost_LVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
@end
