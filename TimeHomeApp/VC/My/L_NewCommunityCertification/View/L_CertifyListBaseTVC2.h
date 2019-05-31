//
//  L_CertifyListBaseTVC2.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_ResiCarListModel.h"

@interface L_CertifyListBaseTVC2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carNum_Label;

@property (nonatomic, strong) L_ResiCarListModel *model;

@end
