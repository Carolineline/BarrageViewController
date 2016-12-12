//
//  BarrageView.h
//  BarrageViewController
//
//  Created by 晓琳 on 16/12/9.
//  Copyright © 2016年 xiaolin.han. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveStatus){
    Start,
    Enter,
    End
};

@interface BarrageView : UIView

@property (nonatomic, assign) NSInteger trajectory;//弹道
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);//弹幕状态回调

//初始化弹道
- (instancetype) initWithComment:(NSString *)comment;

//开始动画
- (void) startAnimation;
//结束动画
- (void) stopAnimation;





@end
