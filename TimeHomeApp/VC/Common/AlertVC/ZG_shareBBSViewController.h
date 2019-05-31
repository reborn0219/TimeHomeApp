//
//  ZG_shareBBSViewController.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonDidClickBlock)(NSString *type);

@interface ZG_shareBBSViewController : UIViewController

@property (nonatomic, copy) buttonDidClickBlock buttonDidClickBlock;

+(instancetype)shareZG_shareBBSVC;

-(void)showInVC:(UIViewController *)VC with:(NSString *)infoStr;

@end
