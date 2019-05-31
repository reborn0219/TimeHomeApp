//
//  ScratchRuleViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/7/24.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ScratchRuleViewController.h"

@interface ScratchRuleViewController (){
    
    UIViewController *_nextVC;
    
    NSString *_infoStr;
}

@end

@implementation ScratchRuleViewController

#pragma mark - 删除
- (IBAction)dissMissClick:(id)sender {
    
    [self dismiss];
}

#pragma mark - 初始化
+(instancetype)shareScratchRuleVC {
    
    ScratchRuleViewController * ScratchRuleVC= [[ScratchRuleViewController alloc] initWithNibName:@"ScratchRuleViewController" bundle:nil];
    return ScratchRuleVC;
    
}

#pragma mark - 关闭VC
-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)showInVC:(UIViewController *)VC with:(NSString *)infoStr {
    
    _nextVC = VC;
    _infoStr = infoStr;
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([XYString isBlankString:_infoStr]) {
        
        self.infoTextLal.text = @"1、符合签到条件，即可进行抽奖；\n2、每次抽奖只能抽取一次；\n3、如果放弃抽奖，则当日无法再次抽奖；\n4、本活动最终解释权归属优思科技所有；";
        
    }else{
        
        self.infoTextLal.text = _infoStr;
    }
    
    float width = SCREEN_WIDTH - 2 * 30;
    float unit = width / 363;
    self.buttonTopLayout.constant = (unit * 64 - 22) / 2;
    self.infoTextTopLayout.constant = unit * 64 + 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
