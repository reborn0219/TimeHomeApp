//
//  TopicFooterView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *nextLineImg;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (copy, nonatomic) UpDateViewsBlock block;
@end
