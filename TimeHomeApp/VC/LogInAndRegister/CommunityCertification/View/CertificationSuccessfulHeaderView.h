//
//  CertificationSuccessfulHeaderView.h
//  PropertyButler
//
//  Created by 赵思雨 on 2017/7/19.
//  Copyright © 2017年 优思科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface CertificationSuccessfulHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *theTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *msglabel;

@end
