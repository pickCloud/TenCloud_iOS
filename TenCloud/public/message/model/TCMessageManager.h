//
//  TCMessageManager.h
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCMessageManagerDelegate <NSObject>
- (void) messageCountChanged:(NSInteger)count;
@end

@interface TCMessageManager : NSObject

@property (nonatomic, assign)   NSInteger   count;

+ (instancetype) shared;

- (void) start;

- (void) stop;

- (void) clearMessageCount;

- (void) addObserver:(id<TCMessageManagerDelegate>)obs;

- (void) removeObserver:(id<TCMessageManagerDelegate>)obs;

@end
