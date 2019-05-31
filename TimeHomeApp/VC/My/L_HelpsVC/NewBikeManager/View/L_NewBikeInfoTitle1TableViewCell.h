//
//  L_NewBikeInfoTitle1TableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

@interface L_NewBikeInfoTitle1TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *equipmentId;

@property (weak, nonatomic) IBOutlet UILabel *bikeType;

@property (weak, nonatomic) IBOutlet UILabel *bikeBrand;

@property (weak, nonatomic) IBOutlet UILabel *bikeColor;

@property (weak, nonatomic) IBOutlet UILabel *inOrOut;

@property (weak, nonatomic) IBOutlet UILabel *bikeTime;

@property (nonatomic, strong) L_BikeListModel *bikeModel;

@end
