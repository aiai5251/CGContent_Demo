//
//  CGContextView.h
//  CGContent_Demo
//
//  Created by shiyaorong on 15/11/26.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    BaseContextType,
    BaseLineChartType, //折现图
    BaseBarChartType,  //柱状图
    BasePieChartType,  //饼状图
    BasePathType,
}BaseViewType;

@interface CGContextView : UIView
@property (nonatomic, assign) BaseViewType baseType;


@property (nonatomic, strong) NSMutableArray *pathArray;

@end
