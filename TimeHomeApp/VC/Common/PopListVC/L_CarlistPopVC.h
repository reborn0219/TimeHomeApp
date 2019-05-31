//
//  L_CarlistPopVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/27.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_CarlistPopVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (nonatomic, copy) ViewsEventBlock cellSelectCallBack;

+ (L_CarlistPopVC *)getInstance;

///显示
- (void)showVC:(UIViewController *)parent withDataArray:(NSArray *)array withType:(NSInteger)comeType cellEvent:(ViewsEventBlock)eventCallBack;

@end
