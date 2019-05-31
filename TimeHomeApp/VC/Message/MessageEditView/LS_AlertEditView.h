//
//  LS_AlertEditView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_AlertEditView : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
- (IBAction)okBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
-(void)showEditDetermine:(UIViewController *)parentVC andBlock:(AlertBlock)block;
@end
