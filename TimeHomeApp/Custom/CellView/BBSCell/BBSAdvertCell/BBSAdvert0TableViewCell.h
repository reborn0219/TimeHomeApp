//
//  BBSAdvert0TableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/11/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

typedef void(^cityButtonDidClickBlock)(NSInteger index);

@interface BBSAdvert0TableViewCell : UITableViewCell

@property (nonatomic, strong) BBSModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (nonatomic, copy) cityButtonDidClickBlock cityButtonDidClickBlock;

@end
