//
//  GGFooterView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGFooterView : UICollectionReusableView
@property (nonatomic, copy)ViewsEventBlock block;
@property (nonatomic, copy)ViewsEventBlock img_block;
@property (nonatomic, assign)NSInteger type;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
- (IBAction)closeAction:(id)sender;

@end
