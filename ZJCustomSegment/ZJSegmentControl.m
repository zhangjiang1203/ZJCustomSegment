//
//  ZJSegmentControl.m
//  CroquetBallAPP
//
//  Created by pg on 2017/1/7.
//  Copyright © 2017年 DZHFCompany. All rights reserved.
//

#import "ZJSegmentControl.h"

#define KTAG 10
#define KANIMATION 0.5
@interface ZJSegmentControl ()<UIScrollViewDelegate>
{
    NSInteger maxWidth;
}

//添加视觉差动画效果显示
@property (strong,nonatomic)UIView *bottomView;

@property (strong,nonatomic)UIView *centerView;

@property (strong,nonatomic)UIView *topView;

@property (strong,nonatomic)UIScrollView *myScrollView;

@property (strong,nonatomic)NSArray<NSString*> *titlesArr;

@property (strong,nonatomic)UILabel *lineLabel;

@property (strong,nonatomic)UIButton *selectedBtn;

@end

@implementation ZJSegmentControl

-(void)setTitleNorColor:(UIColor *)titleNorColor{
    _titleNorColor = titleNorColor;
    for (UIView *view in self.bottomView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = _titleNorColor;
        }
    }
}

-(void)setTitleSelColor:(UIColor *)titleSelColor{
    _titleSelColor = titleSelColor;
    for (UIView *view in self.topView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = _titleSelColor;
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray<NSString*>*)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleNorColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.titleSelColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        self.isShowLineLabel = YES;
        self.fontSize = 14;
        self.titlesArr = titles;
        [self setUpMyScrollView];
    }
    return self;
}

-(void)setUpMyScrollView{
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat viewWidth = self.bounds.size.width;
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.myScrollView.delegate = self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.bounces = YES;
    [self addSubview:self.myScrollView];
    
    //计算当前所有标题的最大长度
    NSMutableArray *widthArr = [NSMutableArray array];
    [self.titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self getSuitSizeWidthWithString:obj fontSize:14 height:viewHeight];
        [widthArr addObject:@(height)];
    }];
    
    //拿出标题最大的宽度
    [widthArr enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxWidth < [obj integerValue]) {
            maxWidth = [obj integerValue];
        }
    }];
    maxWidth = maxWidth*widthArr.count > viewWidth?maxWidth:(viewWidth/widthArr.count);
    CGFloat contentWidth = maxWidth*widthArr.count;
    _myScrollView.contentSize = CGSizeMake(contentWidth, 0);
    
    //初始化三个显示的视图
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, viewHeight)];
    [self.myScrollView addSubview:_bottomView];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, maxWidth, viewHeight)];
    self.centerView.clipsToBounds = YES;
    [self.myScrollView addSubview:self.centerView];
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, viewHeight)];
    [self.centerView addSubview:self.topView];

    
    //添加按钮
    __weak typeof(self) weakSelf = self;
    [self.titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //添加文字标签
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(idx*maxWidth, 0, maxWidth, viewHeight)];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.text = obj;
        bottomLabel.font = [UIFont systemFontOfSize:weakSelf.fontSize];
        bottomLabel.textColor = weakSelf.titleNorColor;
        [weakSelf.bottomView addSubview:bottomLabel];
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(idx*maxWidth, 0, maxWidth, viewHeight)];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = obj;
        topLabel.font = [UIFont systemFontOfSize:weakSelf.fontSize];
        topLabel.textColor = weakSelf.titleSelColor;
        [weakSelf.topView addSubview:topLabel];

        UIButton *titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(idx*maxWidth, 0, maxWidth, viewHeight)];
        titleBtn.tag = idx + KTAG;
//        titleBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
//        [titleBtn setTitle:obj forState:UIControlStateNormal];
//        [titleBtn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
//        [titleBtn setTitleColor:self.titleSelColor forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_myScrollView addSubview:titleBtn];
    }];
    //默认选中第一个
    [self titleButtonClickAction:[self viewWithTag:KTAG]];
    
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewHeight-1, maxWidth, 1)];
    self.lineLabel.backgroundColor = self.titleSelColor;
    [self.myScrollView addSubview:self.lineLabel];
}

-(void)setIsShowLineLabel:(BOOL)isShowLineLabel{
    _isShowLineLabel = isShowLineLabel;
    self.lineLabel.hidden = !_isShowLineLabel;
}

-(void)titleButtonClickAction:(UIButton*)sender{
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    CGRect lineRect = self.lineLabel.frame;
    lineRect.origin.x = maxWidth*(sender.tag-KTAG);
    
    //改变centerView和topView的相对位置
    CGRect centerRect = self.centerView.frame;
    centerRect.origin.x = maxWidth*(sender.tag-KTAG);
    
    CGRect topRect = self.topView.frame;
    topRect.origin.x = -maxWidth*(sender.tag-KTAG);
    
    [UIView animateWithDuration:KANIMATION animations:^{
        self.centerView.frame = centerRect;
        self.topView.frame = topRect;
        self.lineLabel.frame = lineRect;
    }];
    [self setScrollOffset:sender.tag];
    self.segmentBlock?self.segmentBlock(sender.tag-KTAG):nil;
    
}

-(void)setSegmentMoveToIndex:(NSInteger)index{
    UIButton *sender = (UIButton*)[self viewWithTag:index+KTAG];
    [self titleButtonClickAction:sender];
}

//设置scrollview的移动位置
- (void)setScrollOffset:(NSInteger)index{
    UIButton *sender = (UIButton*)[self viewWithTag:index];
    CGRect rect = sender.frame;
    float midX = CGRectGetMidX(rect);
    float offset = 0;
    float contentWidth = _myScrollView.contentSize.width;
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    [UIView animateWithDuration:KANIMATION animations:^{
        [_myScrollView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

/**
 *  @brief 计算文字的宽度
 */
 -(CGFloat)getSuitSizeWidthWithString:(NSString *)text fontSize:(float)fontSize height:(float)height{
 
     UIFont *font = [UIFont systemFontOfSize:fontSize];
     CGSize constraint = CGSizeMake(MAXFLOAT, height);
     NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
     // 返回文本绘制所占据的矩形空间。
     CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
     return contentSize.width+15;
 }

@end
