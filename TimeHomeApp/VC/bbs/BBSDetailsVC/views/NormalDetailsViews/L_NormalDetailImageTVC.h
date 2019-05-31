//
//  L_NormalDetailImageTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_NormalInfoModel.h"

typedef void(^RefreshImageHeightBlock)(CGFloat imageHeight);
@interface L_NormalDetailImageTVC : UITableViewCell

@property (nonatomic, copy) RefreshImageHeightBlock refreshImageHeightBlock;

/**
 普通帖图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;



@end
