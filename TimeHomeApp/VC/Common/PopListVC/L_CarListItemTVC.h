//
//  L_CarListItemTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/27.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_CorrgateModel.h"

@interface L_CarListItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *content_Label;

@property (nonatomic, strong) L_CorrgateModel *gateModel;

//@property (nonatomic, strong) NSDictionary *carNumDict;

@end
