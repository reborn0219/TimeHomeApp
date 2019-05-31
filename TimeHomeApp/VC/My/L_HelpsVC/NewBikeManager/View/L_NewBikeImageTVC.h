//
//  L_NewBikeImageTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"
//#import "UserPhotoWall.h"
#import "L_BikeImageResourceModel.h"

typedef void(^AllButtonsDidTouchBlock)(NSInteger buttonIndex);
@interface L_NewBikeImageTVC : UITableViewCell

@property (nonatomic, copy) AllButtonsDidTouchBlock allButtonsDidTouchBlock;

@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;

@property (nonatomic, strong) L_BikeListModel *model;

@end
