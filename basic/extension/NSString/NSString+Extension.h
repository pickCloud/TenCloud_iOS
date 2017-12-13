//
//  NSString+Extension.h
//  YE
//
//  Created by huangdx on 2017/10/24.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSDate *) date;

+ (NSString *) dateStringFromTimeInterval:(NSInteger)timeInterval;

+ (NSString *) timeStringFromInteger:(NSInteger)timeInteger;

+ (NSString *) periodStringFromTimeInterval:(NSInteger)startTime to:(NSInteger)endTime;

+ (NSString *) UUID;

+ (NSString *) weekDayStringFromInteger:(NSInteger)dayInteger;

@end
