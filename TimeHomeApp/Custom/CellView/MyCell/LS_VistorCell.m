//
//  LS_VistorCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_VistorCell.h"

@implementation LS_VistorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)assignmentWithModel:(UserVisitor *)UV
{
    self.nameLb.text = [XYString isBlankString:UV.visitname]?UV.visitphone:UV.visitname;
    
    self.timeLb.text = [UV.visitdate substringToIndex:10];
    
//    NSString *dateString = [UV.visitdate substringToIndex:10];
//    
//    NSDate *date = [XYString NSStringToDate:dateString withFormat:@"yyyy-MM-dd"];
//    //    NSString *currentDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
//    
//    NSString * beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
//    NSDate *currentDate = [XYString NSStringToDate:beginDateString withFormat:@"yyyy-MM-dd"];
//    int isOld = [XYString CompareOneDay:currentDate withAnotherDay:date];
    
    if (UV.isinvalid.integerValue == 1) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (UV.type.intValue == 2) {
        self.nameLb.text = UV.visitcard;
        ///到访车辆
        [_headerImgV setImage:[UIImage imageNamed:@"我发出的车辆通行"]];
        
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
