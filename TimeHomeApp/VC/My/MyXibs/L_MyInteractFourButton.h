//
//  L_MyInteractFourButton.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FourButtonDidClickBlock)(NSInteger index);
@interface L_MyInteractFourButton : UITableViewCell

@property (nonatomic, copy) FourButtonDidClickBlock fourButtonDidClickBlock;

@end
