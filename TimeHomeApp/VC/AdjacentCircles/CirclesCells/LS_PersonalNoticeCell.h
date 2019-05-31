//
//  LS_ PersonalNoticeCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNoticeModel.h"

@interface LS_PersonalNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ls_selectImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenttrailing;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UILabel *DetailLb;
@property (weak, nonatomic) IBOutlet UIImageView *RightImgV;
@property (weak, nonatomic) IBOutlet UIButton *DetailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redpacketBtn;
@property (nonatomic,copy)ViewsEventBlock block;
- (IBAction)detailAction:(id)sender;
-(void)assignmentWithModel:(UserNoticeModel *)UNML;
-(void)wetherEditing:(BOOL)isEditing;
@end
