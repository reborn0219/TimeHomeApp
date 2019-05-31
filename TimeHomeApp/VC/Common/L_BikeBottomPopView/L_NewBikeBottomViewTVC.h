//
//  L_NewBikeBottomViewTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleDidTouchBlock)();
@interface L_NewBikeBottomViewTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (nonatomic, copy) TitleDidTouchBlock titleDidTouchBlock;

@end
