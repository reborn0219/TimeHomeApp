//
//  PublishTopicVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PublishTopicVC.h"
#import "Masonry.h"
#import "TopicImgList.h"
#import "TopicImgListModel.h"
#import "PublishPostVC.h"
#import "PostPresenter.h"
#import "MessageAlert.h"
#import "PostPresenter.h"
#import "WebViewVC.h"

@interface PublishTopicVC ()<UITextViewDelegate>
{
    NSString * picID;
}
@property (strong, nonatomic)  UIButton *publishBtn;

@end

@implementation PublishTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建圈子";
    self.contentTextV.delegate = self;
//    [self showMaskingViewArrays:@[@"创建话题_新手引导"] frameArray:nil];
    UIView * bottomV = [[UIView alloc]init];
    [bottomV setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [self.view addSubview:bottomV];
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        
    }];
    
    self.publishBtn = [[UIButton alloc]init];
    [self.publishBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.publishBtn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
    self.publishBtn.layer.borderWidth = 1.0f;
    [self.publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.publishBtn.layer.borderColor = UIColorFromRGB(0xB9BABB).CGColor;
    [self.view addSubview:self.publishBtn];
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-7.5);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        
    }];
    picID = @"1";
    
}
#pragma  mark - 创建话题
-(void)publishAction:(UIButton *)btn
{
    if ([XYString isBlankString:self.titleTF.text]||self.titleTF.text.length<2||self.titleTF.text.length>8) {
        [self showToastMsg:@"输入圈子名称（2-8字）" Duration:2.0];
        return;
    }
    if ([XYString isBlankString:self.contentTextV.text]||self.contentTextV.text.length<5||self.contentTextV.text.length>50||[self.contentTextV.text isEqualToString:@"添加圈子介绍（5-50字）"]) {
        [self showToastMsg:@"添加圈子介绍（5-50字）" Duration:2.0];
        return;
    }
@WeakObj(self)
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self];
    [PostPresenter addTopic:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            NSLog(@"－－－－－创建话题返回数据%@",data);
            if (resultCode ==SucceedCode) {//addinte
                [self.navigationController popViewControllerAnimated:YES];
                NSString * addinte = [data objectForKey:@"addinte"];
                if(addinte.integerValue)
                {
                    [self showToastMsg:[NSString stringWithFormat:@"首次创建圈子，获得%@积分！",addinte] Duration:4.0f];

                }else
                {
                    [self showToastMsg:@"创建成功！" Duration:2.0f];
                }
                
                
//                if (![XYString isBlankString:topicID]) {
//                    
//                    [PostPresenter addFollowTopic:topicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
//                        NSLog(@"给自己添加话题关注－－－－%@",data);
//                    }];
//                }

            }else if(resultCode == FailureCode)
            {
                [self showToastMsg:data Duration:2.0f];

            }else if(resultCode == CustomCode)
            {
                NSLog(@"----%@",data);
                NSDictionary * tempDic = data;
               NSString * state =  [tempDic objectForKey:@"state"];
                [[MessageAlert shareMessageAlert] showInVC:selfWeak withTitle:@"圈子名称被占用，你想？" andCancelBtnTitle:@"修改标题" andOtherBtnTitle:@"去发贴"];
                [MessageAlert shareMessageAlert].closeBtnIsShow = YES;
                [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                {
                    
                    if (index==Ok_Type) {
                        
                        if (state.integerValue == 0 ) {
                            
                            [selfWeak showToastMsg:@"该圈子正在审核中" Duration:2.5f];
                            
                            
                        }else{
                            
                            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                            AppDelegate *appDlgt=GetAppDelegates;
                            NSString * topicgotourl = [tempDic objectForKey:@"topicgotourl"];
                            
                            if([topicgotourl hasSuffix:@".html"])
                            {
                                webVc.url=[NSString stringWithFormat:@"%@?token=%@",topicgotourl,appDlgt.userData.token];
                            }
                            else
                            {
                                webVc.url=[NSString stringWithFormat:@"%@&token=%@",topicgotourl,appDlgt.userData.token];
                            }
                            webVc.type= 1;
                            webVc.topicid = [tempDic objectForKey:@"id"];
                            
                            webVc.shareUr = topicgotourl;
                            webVc.title = _titleTF.text;
                            webVc.isShowRightBtn=YES;
                            webVc.shareTypes=4;
                            [self.navigationController pushViewController:webVc animated:YES];
                        }
                    }else
                    {
                        [_titleTF becomeFirstResponder];
                    }
                };

            }

        });
        
        
    } withTitle:self.titleTF.text andRemarks:self.contentTextV.text andPicid:picID];
    
    
//    PublishPostVC * ppVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PublishPostVC"];
//    [self.navigationController pushViewController:ppVC animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

}

- (IBAction)selectedImageAction:(id)sender {
    
    @WeakObj(self)

    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            TopicImgList * tilistVC = [[TopicImgList alloc]init];
            tilistVC.block = ^(id  _Nullable data,ResultCode resultCode)
            {
                TopicImgListModel * TILM = data;
                picID = TILM.picID;
                if (TILM.image) {
                    [selfWeak.addBtn setImage:TILM.image forState:UIControlStateNormal];
                    
                }else
                {
                    //        [selfWeak.addBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:TILM.fileurl]]] forState:UIControlStateNormal];
                    [selfWeak.addBtn sd_setImageWithURL:[NSURL URLWithString:TILM.fileurl] forState:UIControlStateNormal];
                }
            };
            [self.navigationController pushViewController:tilistVC animated:YES];
        }];
    }];
    

    
}
#pragma mark - textFieldDelegate
- (IBAction)editingChanged:(id)sender {
    
    UITextField * tempTF = sender;
    UITextRange * selectedRange = tempTF.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(_titleTF.text.length>=8)
        {
            _titleTF.text=[_titleTF.text substringToIndex:8];
        }
    }
   
}
#pragma mark - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height- ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
    if ([self.contentTextV.text isEqualToString:@"添加圈子介绍（5-50字）"]) {
        self.contentTextV.text=@"";
    }
    self.contentTextV.textColor=UIColorFromRGB(0x818181);
}

-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
        if (self.contentTextV.text.length>=50) {
            self.contentTextV.text=[textView.text substringToIndex:50];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (self.contentTextV.text.length==0) {
        self.contentTextV.text=@"添加圈子介绍（5-50字）";
        self.contentTextV.textColor=UIColorFromRGB(0xdcdbdc);
    }
    
}


@end
