//
//  BarrageManager.h
//  BarrageViewController
//
//  Created by 晓琳 on 16/12/9.
//  Copyright © 2016年 xiaolin.han. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BarrageView;
@interface BarrageManager : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(BarrageView *view);

- (void) barrageStart;

- (void) barrageStop;

@end
