//
//   CertificationPrivilegeHeaderView.h
//  PropertyButler
//
//  Created by 赵思雨 on 2017/7/19.
//  Copyright © 2017年 优思科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface  CertificationPrivilegeHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *checkMyHouse;

@property (weak, nonatomic) IBOutlet UIButton *certificationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (nonatomic,copy)ViewsEventBlock block;
@end
