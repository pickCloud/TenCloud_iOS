//
//  TCSetJoinSettingRequest.h
//  功能:设置员工加入条件
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCSetJoinSettingRequest : YTKRequest

//- (instancetype) initWithSetting:(NSString *)setting;
@property (nonatomic, strong)   NSString    *setting;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
