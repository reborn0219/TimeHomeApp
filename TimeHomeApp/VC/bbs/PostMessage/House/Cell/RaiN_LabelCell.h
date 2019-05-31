//
//  RaiN_LabelCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaiN_LabelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic,assign) CGSize itemSize;
@end
