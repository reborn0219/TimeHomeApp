//
//  ScratchRuleViewController.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/7/24.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScratchRuleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *infoTextLal;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTextTopLayout;


+(instancetype)shareScratchRuleVC;

-(void)showInVC:(UIViewController *)VC with:(NSString *)infoStr;

@end
