//
//  LS _NeighborNoticeCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNoticeModel.h"

@interface LS_NeighborNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topview_layout_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topview_layout_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_layout_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_layout_right;

@property (weak, nonatomic) IBOutlet UIImageView *ls_imgV;
@property (weak, nonatomic) IBOutlet UIImageView *zanImgV;

@property (weak, nonatomic) IBOutlet UILabel *detailContentLb;
@property (weak, nonatomic) IBOutlet UIImageView *detailImgV;
@property (weak, nonatomic) IBOutlet UIView *detailV;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImg_layout;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (nonatomic,strong) CellEventBlock block;
-(void)assignmentWithModel:(UserNoticeModel *)UNML withType:(NSString *)type;
- (IBAction)replyAction:(id)sender;
-(void)wetherEditing:(BOOL)isEditing;
@end
