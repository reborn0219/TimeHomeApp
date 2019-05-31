//
//  L_HouseDetailForthTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseDetailModel.h"

typedef void(^PraiseButtonDidBlock)();
typedef void(^HeaderButtonDidBlock)(NSString *userid);

@interface L_HouseDetailForthTVC : UITableViewCell

@property (nonatomic, copy) HeaderButtonDidBlock headerButtonDidBlock;
@property (nonatomic, copy) PraiseButtonDidBlock praiseButtonDidBlock;

@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;

@property (nonatomic, strong) L_HouseDetailModel *model;

@end
