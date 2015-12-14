//
//  XYPieChart.h
//  CGContent_Demo
//
//  Created by shiyaorong on 15/12/3.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 🎸1.属性声明
//typedef void (^ReturnSectedBlock)(NSUInteger selectedIndex);

@interface XYPieChart : UIView {
    UIView  *_pieView;
    
    //animation control
    NSTimer *_animationTimer;
    NSMutableArray *_animations;
    
    NSUInteger returnSelectedIndex;
    void (^ReturnSectedBlock)(NSUInteger selectedIndex);
    
}

// 🎸2.定义属性
//@property (nonatomic, copy) ReturnSectedBlock returnBlock;

- (void)returnSelected:(void (^)(NSUInteger selectedIndex))block;

- (id)initWithFrame:(CGRect)frame;
- (void)refreshData:(NSMutableArray *)angels;

@end
