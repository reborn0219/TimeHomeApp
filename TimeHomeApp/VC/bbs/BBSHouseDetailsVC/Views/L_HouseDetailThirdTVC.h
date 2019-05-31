//
//  L_HouseDetailThirdTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseDetailModel.h"
@interface L_HouseDetailThirdTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) L_HouseDetailModel *model;


@end
