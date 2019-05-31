//
//  SpeedyLockCollectionViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LockButtonDidClickBlock)(NSInteger index);

@interface SpeedyLockCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) LockButtonDidClickBlock LockButtonDidClickBlock;

@property (weak, nonatomic) IBOutlet UIImageView *headerLockImage;

@property (weak, nonatomic) IBOutlet UILabel *headerTypeLal;

@property (weak, nonatomic) IBOutlet UILabel *headerCommLal;

@property (weak, nonatomic) IBOutlet UILabel *midTypeLal;

@property (weak, nonatomic) IBOutlet UIImageView *midLockImage;

@property (weak, nonatomic) IBOutlet UILabel *bottomLockLal;

@property (weak, nonatomic) IBOutlet UILabel *bottomVoiceLal;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
