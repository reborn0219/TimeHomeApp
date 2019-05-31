//
//  L_HouseDetailBaseTVC3.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_PowerListModel.h"

@interface L_HouseDetailBaseTVC3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitle_Label;

@property (weak, nonatomic) IBOutlet UILabel *detail_Label;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *rightBtn_Label;
@property (weak, nonatomic) IBOutlet UIImageView *rightBtn_ImageView;

@property (nonatomic, strong) L_PowerListModel *model;

@end
