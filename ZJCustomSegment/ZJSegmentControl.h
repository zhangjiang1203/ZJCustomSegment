//
//  ZJSegmentControl.h
//  CroquetBallAPP
//
//  Created by pg on 2017/1/7.
//  Copyright © 2017年 DZHFCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SegmentBlock)(NSInteger clickTag);

@interface ZJSegmentControl : UIView

/**
 显示底部的横线
 */
@property (nonatomic,assign)BOOL isShowLineLabel;

/**
 未选中颜色
 */
@property (nonatomic,strong)UIColor *titleNorColor;

/**
 选中颜色
 */
@property (nonatomic,strong)UIColor *titleSelColor;

/**
 字体大小
 */
@property (assign,nonatomic)CGFloat fontSize;


@property (nonatomic,copy)SegmentBlock segmentBlock;


-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray<NSString*>*)titles;


/**
 切换segment的选择

 @param index 当前的位置
 */
-(void)setSegmentMoveToIndex:(NSInteger)index;
@end
