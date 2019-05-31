//
//  L_NormalDetailForthTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_NormalInfoModel.h"

typedef void(^PraiseButtonDidBlock)();
typedef void(^HeaderButtonDidBlock)(NSString *userid);

@interface L_NormalDetailForthTVC : UITableViewCell

@property (nonatomic, copy) HeaderButtonDidBlock headerButtonDidBlock;

@property (nonatomic, copy) PraiseButtonDidBlock praiseButtonDidBlock;

/**
 点赞图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;

/**
 点赞数
 */
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;

@property (nonatomic, strong) L_NormalInfoModel *model;

@end
