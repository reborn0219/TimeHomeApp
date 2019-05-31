//
//  L_CommentListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CommentListViewController.h"

#import "BBSMainPresenters.h"

#import "L_NewMinePresenters.h"

#import "ChatViewController.h"

#import "L_NormalDetailCommentTVC.h"
#import "personListViewController.h"
#import "answerTableViewCell.h"

CGFloat const kChatInputViewHeight = 50.0f;
CGFloat const kChatInputTextViewHeight = 34.0f;

NSInteger const CommentMAX_LIMIT_NUMS = 500;/** 回复字数限制 */

@interface L_CommentListViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    CGSize _currentTextViewContentSize;
    NSInteger _textLine;
    CGRect keyboardF;
    UILabel *placeHolder;
    BOOL isRefreshBeginning;
}

@property (weak, nonatomic) IBOutlet UIView *TFBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

/**
 评论输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 输入框背景高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFBgViewHeightConstraint;

@end

@implementation L_CommentListViewController

// MARK: - 删除评论
/**
 删除评论

 @param postid 帖子id
 @param commentID 评论id
 @param callback
 */
- (void)httpRequestForDeleteCommentWithPostid:(NSString *)postid commentID:(NSString *)commentID callBack:(void(^)())callback {
    
    [BBSMainPresenters deleteCommentWithPostID:postid commentid:commentID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (resultCode == SucceedCode) {
                
                [self showToastMsg:@"删除成功" Duration:3.0];

                if (callback) {
                    callback();
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 回复评论
/**
 回复评论

 @param content 回复内容
 */
- (void)httpRequestForAddCommentWithContent:(NSString *)content {
    
    NSString *string = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([XYString isBlankString:string]) {
        [self showToastMsg:@"回复内容不能为空" Duration:3.0];
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters addCommentWithID:_postID withContent:content withCommentID:_commentID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                _commentTextView.text = @"";
                _currentTextViewContentSize = _commentTextView.contentSize;
                _TFBgViewHeightConstraint.constant = 50;
            
//                commentcount
                if (self.praiseAndCommentCallBack) {
                    self.praiseAndCommentCallBack(nil,data[@"commentcount"],nil,nil);
                }
                
                [self showToastMsg:@"评论成功" Duration:3.0];
                [self httpRequestForGetCommentListisRefresh:YES isCallBack:YES];
            
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 采纳帖子
/**
 点赞
 
 @param postID 帖子id
 @param commid 回答id
 */
- (void)httpRequestForAgreeAnswerWithPostid:(NSString *)postID
                                  commentID:(NSString *)commentID {
    
    [L_NewMinePresenters agreeAnswerWithPostid:postID commentid:commentID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                [self showToastMsg:data Duration:3.0];
                [_tableView.mj_header beginRefreshing];
            }else {
                [self showToastMsg:data Duration:3.0];
            }
        });
    }];
}
// MARK: - 点赞
/**
 点赞
 
 @param type 0点赞 1取消点赞
 @param commid 回答id
 */
- (void)httpRequestForPraiseOrNot:(NSString *)isPraise
                       withcommid:(NSString *)commid
                           answer:(QuestionAnswerModel *)answer{
    
    [L_NewMinePresenters addQuestionPraiseType:isPraise withcommentid:commid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                int praiseCount;
                NSString *praise;
                
                if ([isPraise isEqualToString:@"0"]) {
                    praise = @"0";
                    praiseCount = [answer.praisecount intValue];
                    praiseCount ++ ;
                }else{
                    praise = @"1";
                    praiseCount = [answer.praisecount intValue];
                    praiseCount -- ;
                    
                    if (praiseCount < 0) {
                        
                        praiseCount = 0;
                    }
                }
                
                NSString *count = [NSString stringWithFormat:@"%d",praiseCount];
                
                [self showToastMsg:[data objectForKey:@"errmsg"] Duration:3.0];
                
                if ([count isKindOfClass:[NSString class]]) {
                    
                    if (count.integerValue >= 0) {
                        
                        if (self.praiseAndCommentCallBack) {
                            //type 0已点赞 1 未点赞
                            self.praiseAndCommentCallBack(count,nil,nil,praise);
                            
                        }
                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 请求回复列表
/**
 请求回复列表

 @param isRefresh 是否为刷新
 */
- (void)httpRequestForGetCommentListisRefresh:(BOOL)isRefresh isCallBack:(BOOL)isCallBack {
    
    if (isRefresh) {
        _page = 1;
        isRefreshBeginning = YES;
    }else {
        
        if (isRefreshBeginning == YES) {
            [_tableView.mj_footer endRefreshing];
            return;
        }
        
        _page++;
    }
    
    [BBSMainPresenters getUserPostCommentWithID:_postID withPage:_page withCommentID:_commentID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!isCallBack) {
                if (_page == 1) {
                    [_tableView.mj_header endRefreshing];
                }else {
                    [_tableView.mj_footer endRefreshing];
                }
            }
            
            if (resultCode == SucceedCode) {
                
                isRefreshBeginning = NO;
                
                if (isRefresh) {
                    [_dataArray removeAllObjects];
                    if ([self.isAnswerPost isEqualToString:@"1"]) {
                        
                        QuestionAnswerModel *model = [QuestionAnswerModel mj_objectWithKeyValues:data[@"map"]];
                        [_dataArray addObject:model];
                    }else{
                        
                        L_TieziCommentModel *model = [L_TieziCommentModel mj_objectWithKeyValues:data[@"map"]];
                        [_dataArray addObject:model];
                    }
                }
                
                NSArray *array = [L_TieziCommentModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];

                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                
                if (array.count == 0) {
                    _page = _page - 1;
                }
                
                if (isCallBack) {
                    
                    NSString *commentcount = [NSString stringWithFormat:@"%ld",_dataArray.count - 1];
                    if (self.praiseAndCommentCallBack) {
                        
                        self.praiseAndCommentCallBack( nil, commentcount, nil, nil);
                    }
                }
                
            }else {
                
                if (isRefresh) {
                    _page = 1;
                }else {
                    _page = _page - 1;
                }
                
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}


//- (void)scrollViewToBottom:(BOOL)animated {
//    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
//
//        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
//        [self.tableView setContentOffset:offset animated:animated];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [_commentTextView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentTextView.layer.cornerRadius = 10;
    _commentTextView.clipsToBounds = YES;
    _commentTextView.delegate = self;
    _commentTextView.enablesReturnKeyAutomatically = YES;
    
    [self setupPlaceHolder];
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailCommentTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailCommentTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"answerTableViewCell" bundle:nil] forCellReuseIdentifier:@"answerTableViewCell"];
    
    @WeakObj(self)
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetCommentListisRefresh:YES isCallBack:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetCommentListisRefresh:NO isCallBack:NO];
    }];
    [_tableView.mj_header beginRefreshing];


}
#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //    if (self.picking) return;
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (keyboardF.origin.y >= self.view.height_sd) { // 键盘的Y值已经远远超过了控制器view的高度
        _bottomConstraint.constant = 0;
        _tableBottomConstraint.constant = 0;
        if (_TFBgViewHeightConstraint.constant == 84) {
            _tableBottomConstraint.constant = 34;
        }
    }else {
        _bottomConstraint.constant = keyboardF.size.height;
        _tableBottomConstraint.constant = keyboardF.size.height;
        if (_TFBgViewHeightConstraint.constant == 84) {
            _tableBottomConstraint.constant = keyboardF.size.height + 34;
        }
    }
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)textViewDidChange:(UITextView *)textView {
    
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    
    [self limitWordCountsWithTextView:textView];
    
    if (!_currentTextViewContentSize.width) {
        _currentTextViewContentSize = textView.contentSize;
    } else {
        if (_currentTextViewContentSize.height < textView.contentSize.height) {
            [self updateHeight:textView isInput:YES];
        } else if (_currentTextViewContentSize.height > textView.contentSize.height) {
            [self updateHeight:textView isInput:NO];
        }
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    [self limitWordCountsWithTextView:textView];

}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    
    [self limitWordCountsWithTextView:textView];
}

- (void)updateHeight:(UITextView *)textView isInput:(BOOL)isInput {
    isInput ? ++_textLine : --_textLine;
    
    _currentTextViewContentSize = textView.contentSize;
    CGFloat height = kChatInputViewHeight + _textLine * kChatInputTextViewHeight;
    
    if (height >= 84) {
        height = 84;
        _tableBottomConstraint.constant = keyboardF.size.height + 34;

    }else {
        height = 50;
        _tableBottomConstraint.constant = keyboardF.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        _TFBgViewHeightConstraint.constant = height;
    }];
}

// MARK: - 限制字数
/**
 限制字数
 */
- (void)limitWordCountsWithTextView:(UITextView *)textView {
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > CommentMAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:CommentMAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    //    textView.text = [NSString stringWithFormat:@"%ld/%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum),(long)MAX_LIMIT_NUMS];
    
    
}


// MARK: - 给textView添加一个UILabel子控件
- (void)setupPlaceHolder {
    placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 285, 21)];
    placeHolder.text = [NSString stringWithFormat:@"回复%@:",[XYString IsNotNull:_commentNickName]];
    placeHolder.textColor = TEXT_COLOR;
    placeHolder.numberOfLines = 1;
    placeHolder.font = DEFAULT_FONT(14);
    [self.commentTextView addSubview:placeHolder];
}

// MARK: - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送");
        [textView endEditing:YES];
        
        [self httpRequestForAddCommentWithContent:textView.text];
        
        return NO;
    }else {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //获取高亮部分内容
        //NSString * selectedtext = [textView textInRange:selectedRange];
        
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            
            if (offsetRange.location < CommentMAX_LIMIT_NUMS) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = CommentMAX_LIMIT_NUMS - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = @"";
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                }
                else
                {
                    __block NSInteger idx = 0;
                    __block NSString  *trimString = @"";//截取出的字串
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                              
                                              if (idx >= rg.length) {
                                                  *stop = YES; //取出所需要就break，提高效率
                                                  return ;
                                              }
                                              
                                              trimString = [trimString stringByAppendingString:substring];
                                              
                                              idx++;
                                          }];
                    
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
                //既然是超出部分截取了，哪一定是最大限制了。
                //                textView.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            }
            return NO;
        }

        
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 8;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = BLACKGROUND_COLOR;
//    return view;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if ([self.isAnswerPost isEqualToString:@"1"]) {
            
            return self.QuestionAnswerModel.height;
        }
    }
    L_TieziCommentModel *model = _dataArray[indexPath.section];
    return model.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataArray.count > 0) {
        
        if (indexPath.section == 0) {
            
            if ([self.isAnswerPost isEqualToString:@"1"]) {
                
                answerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerTableViewCell"];
                
                if (_dataArray.count > 0 ) {
                    
                    QuestionAnswerModel *model = self.QuestionAnswerModel;
                    
                    QuestionAnswerModel *model1 = _dataArray[indexPath.section];
                    model.commentcount = model1.commentcount;
                    
                    cell.model = model;
                    

                    
                    cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex){
                        //1.头像 2.评论列表
                        if (buttonIndex == 1) {
                            
                            personListViewController *personList = [[personListViewController alloc]init];
                            [personList getuserID:model.userid];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:personList animated:YES];
                            
                        }
                        if (buttonIndex == 3) {
                            
                            [self httpRequestForPraiseOrNot:model.ispraise withcommid:model.theID answer:model];
                        }
                        if (buttonIndex == 4) {
                            
                            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                            [alertVC ShowAlert:self Title:@"采纳答案" Msg:@"是否采纳该答案？" oneBtn:@"取消" otherBtn:@"确定"];
                            
                            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                                
                                if (index == 1000) {
                                    //确定
                                    [self httpRequestForAgreeAnswerWithPostid:_postID commentID:model.theID];
                                }
                            };
                        }
                        if (buttonIndex == 5) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if ([XYString isBlankString:model.userid]) {
                                    [self showToastMsg:@"获得用户信息失败" Duration:3.0];
                                    return;
                                }
                                AppDelegate *appDelegate = GetAppDelegates;
                                if ([model.userid isEqualToString:appDelegate.userData.userID]) {
                                    [self showToastMsg:@"不能和自己聊天" Duration:3.0];
                                    return;
                                }
                                
                                ChatViewController *chatC =[[ChatViewController alloc]initWithChatType:XMMessageChatSingle];
                                chatC.navigationItem.title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.nickname]];
                                chatC.ReceiveID = model.userid;
                                
                                [self.navigationController pushViewController:chatC animated:YES];
                            });
                        }
                    };
                }
                return cell;
            }else{
                
                L_TieziCommentModel *model = _dataArray[indexPath.section];
                L_NormalDetailCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailCommentTVC"];
                cell.type = 1;
                cell.model = model;
                
                cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex) {
                    
                    //1.头像 2.评论列表
                    if (buttonIndex == 1) {
                        
                        personListViewController *personList = [[personListViewController alloc]init];
                        [personList getuserID:model.userid];
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:personList animated:YES];
                        
                    }
                    if (buttonIndex == 2) {
                        
                        if (indexPath.section > 0) {
                            
                            AppDelegate *appDlgt = GetAppDelegates;
                            
                            if (![appDlgt.userData.userID isEqualToString:model.userid]) {
                                return ;
                            }
                            
                            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                            [alertVC ShowAlert:self Title:@"删除评论" Msg:@"是否删除评论？" oneBtn:@"取消" otherBtn:@"确定"];
                            
                            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                                
                                if (index == 1000) {
                                    //确定
                                    
                                    [self httpRequestForDeleteCommentWithPostid:_postID commentID:model.theID callBack:^{
                                        
                                        [_dataArray removeObject:model];
                                        [_tableView reloadData];
                                    }];
                                }
                            };
                        }
                        
                    }
                };
                return cell;
            }
        }else {
            
            L_TieziCommentModel *model = _dataArray[indexPath.section];
            L_NormalDetailCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailCommentTVC"];
            cell.type = 2;
            cell.model = model;
            
            cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex) {
                
                //1.头像 2.评论列表
                if (buttonIndex == 1) {
                    
                    personListViewController *personList = [[personListViewController alloc]init];
                    [personList getuserID:model.userid];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:personList animated:YES];
                    
                }
                if (buttonIndex == 2) {
                    
                    if (indexPath.section > 0) {
                        
                        AppDelegate *appDlgt = GetAppDelegates;
                        
                        if (![appDlgt.userData.userID isEqualToString:model.userid]) {
                            return ;
                        }
                        
                        CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                        [alertVC ShowAlert:self Title:@"删除评论" Msg:@"是否删除评论？" oneBtn:@"取消" otherBtn:@"确定"];
                        
                        alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                            
                            if (index == 1000) {
                                //确定
                                
                                [self httpRequestForDeleteCommentWithPostid:_postID commentID:model.theID callBack:^{
                                    
                                    [_dataArray removeObject:model];
                                    [_tableView reloadData];
                                    
                                }];
                            }
                        };
                    }
                }
            };
            return cell;
        }
    }
    return nil;
}

@end
