//
//  PersonnalBarView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonnalBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
- (IBAction)focusAction:(id)sender;
- (IBAction)chatAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *leftLb;
@property (weak, nonatomic) IBOutlet UILabel *rightLb;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

@property (nonatomic, copy) ViewsEventBlock block;
@end
