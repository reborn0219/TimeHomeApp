//
//  picWallCollectionViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserPhotoWall.h"

typedef void(^deleteButtonDidClickBlock)(NSInteger index);

@interface picWallCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) deleteButtonDidClickBlock deleteButtonDidClickBlock;

@property (nonatomic, strong) UserPhotoWall *model;
@property (nonatomic, strong) NSString *top;

@property (weak, nonatomic) IBOutlet UIImageView *picWall;
@property (weak, nonatomic) IBOutlet UILabel *headerLal;
@property (weak, nonatomic) IBOutlet UIButton *canelButton;

@end
