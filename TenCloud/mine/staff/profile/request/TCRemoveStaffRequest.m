//
//  TCRemoveStaffRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRemoveStaffRequest.h"

@interface TCRemoveStaffRequest()

@end

@implementation TCRemoveStaffRequest


- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //此处属于本应服务端传回出错消息，服务端传回内容不对，客户端修正
        //NSNumber *statusNum = [request.responseJSONObject objectForKey:@"status"];
        //if (statusNum && statusNum.integerValue == 10003)
        if(message && [message isEqualToString:@"非公司员工"])
        {
            failure ? failure(@"该员工已离开企业") : nil;
            return ;
        }
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/application/dismission";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"id":@(_staffID)};
}

@end
