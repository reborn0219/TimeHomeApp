//
//  TopicPostModel.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "TopicPostModel.h"

@implementation TopicPostModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"gamadvertiseid":@"id"};
}
-(void)setContent:(NSString *)content
{
    _webtitle = _title;
    NSString * tempStr =[NSString stringWithFormat:@"#%@#",_title];
    _title = tempStr;
    NSMutableString * tempMutableStr = [[NSMutableString alloc]init];
    
    for (int i =0 ; i<tempStr.length-1; i++) {
        
        [tempMutableStr appendString:@"    "];
        if (i==tempStr.length-2) {
            [tempMutableStr appendString:@" "];

        }
        
    }
    _content_ls = content;
    _content = [NSString stringWithFormat:@"%@%@",tempMutableStr,content];
    _contentAttriStr = [[NSMutableAttributedString alloc]initWithString:_content];
    
//    if (_paragraphStyle == nil) {
//        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        _paragraphStyle.alignment = NSTextAlignmentJustified;
//        _paragraphStyle.lineSpacing = 3.0f;///行间距
//        _paragraphStyle.maximumLineHeight = 15.f;
//        _paragraphStyle.minimumLineHeight = 15.f;
//    }
//    _paragraphStyle.firstLineHeadIndent = tempStr.length;
//   [_contentAttriStr addAttribute:NSParagraphStyleAttributeName value:_paragraphStyle range:NSMakeRange(0, _content.length)];
//
    
   self.cellHight = [XYString HeightForText:[NSString stringWithFormat:@"%@%@",tempStr,content] withSizeOfLabelFont:15.0f withWidthOfContent:SCREEN_WIDTH-50];
}


@end
