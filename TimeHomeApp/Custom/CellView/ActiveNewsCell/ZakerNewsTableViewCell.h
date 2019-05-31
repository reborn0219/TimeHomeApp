//
//  ZakerNewsTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PANewHomeNewsModel;
@interface ZakerNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLal;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;
@property (weak, nonatomic) IBOutlet UILabel *fromLal;
@property (strong, nonatomic) PANewHomeNewsModel * newsModel;
@end
