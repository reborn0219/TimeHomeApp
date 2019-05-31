//
//  questionImgTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "questionImgTableViewCell.h"

#import "ImageUitls.h"

@implementation questionImgTableViewCell

- (IBAction)allButtonDidTouch:(UIButton *)sender {
    
    //1.头像 2.评论列表
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(sender.tag);
    }
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
    NSArray *imgArr = self.picList;
    
    if (imgArr.count >= 3) {
        
        NSDictionary *dict1 = imgArr[0];
        NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView1 withName:url1];
        
        NSDictionary *dict2 = imgArr[1];
        NSString *url2 = [NSString stringWithFormat:@"%@",dict2[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView2 withName:url2];
        
        NSDictionary *dict3 = imgArr[2];
        NSString *url3 = [NSString stringWithFormat:@"%@",dict3[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView3 withName:url3];
        
        self.imgView1.hidden = NO;
        self.imgView2.hidden = NO;
        self.imgView3.hidden = NO;
    }else if (imgArr.count == 2){
        
        NSDictionary *dict1 = imgArr[0];
        NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView1 withName:url1];
        
        NSDictionary *dict2 = imgArr[1];
        NSString *url2 = [NSString stringWithFormat:@"%@",dict2[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView2 withName:url2];
        
        self.imgView1.hidden = NO;
        self.imgView2.hidden = NO;
        self.imgView3.hidden = YES;
    }else if (imgArr.count == 1){
        
        NSDictionary *dict1 = imgArr[0];
        NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
        [ImageUitls saveAndShowImage:self.imgView1 withName:url1];

        self.imgView1.hidden = NO;
        self.imgView2.hidden = YES;
        self.imgView3.hidden = YES;
    }
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
