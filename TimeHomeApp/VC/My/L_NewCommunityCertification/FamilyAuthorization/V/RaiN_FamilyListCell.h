//
//  RaiN_FamilyListCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaiN_FamilyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,copy)ViewsEventBlock block;
@end
