//
//  PAWaterSuccessView.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterSuccessView.h"
@interface PAWaterSuccessView()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end
@implementation PAWaterSuccessView

-(void)awakeFromNib{
    [super awakeFromNib];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"请在90秒内操作设备进行取水"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#464A54"] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#007AFF"] range:NSMakeRange(2,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#464A54"] range:NSMakeRange(4,str.length-4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(4, str.length-4)];
    self.msgLabel.attributedText = str;
}

- (IBAction)backHomeClick:(id)sender {
    self.hidden = YES;
    self.backToHomeViewBlock(@"", self, 0);
}

@end
