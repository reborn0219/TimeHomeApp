//
//  RaiN_QuestionPostVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface RaiN_QuestionPostVC : THBaseViewController
//顶部问题描述背景
@property (weak, nonatomic) IBOutlet UIView *topQuestionBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topQuestionBGToTop;
//红包图标
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;

/**
 顶部问题相关
 */
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewH;

//textView
@property (weak, nonatomic) IBOutlet UITextView *topPlacehodelTV;
@property (weak, nonatomic) IBOutlet UITextView *topShowTV;

@property (weak, nonatomic) IBOutlet UITextView *bottomPHTV;
@property (weak, nonatomic) IBOutlet UITextView *bottomShowTV;

//显示字数label
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomNumerLabel;
@property (weak, nonatomic) IBOutlet UIView *bottonShowLabelBG;
@property (weak, nonatomic) IBOutlet UIButton *changeMoneyBtn;


@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
@property (weak, nonatomic) IBOutlet UIView *colloctionBGView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

/**
  奖励相关
*/
@property (weak, nonatomic) IBOutlet UIView *moneyBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet UICollectionView *labelCollection;

//标签的列表
@property (weak, nonatomic) IBOutlet UITableView *labelTableView;
//发布按钮
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
//清空按钮
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
//tableView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;



/**
 区分问答帖与普通帖
 0是普通，1是问答
 */
@property(nonatomic,copy)NSString *isQuestion;
/**
 添加标签
 */
@property (weak, nonatomic) IBOutlet UIView *tagsTFBgView;
@property (weak, nonatomic) IBOutlet UITextField *tagsTF;
@property (weak, nonatomic) IBOutlet UIButton *addTagsBtn;

@end
