//
//  TCSearchMessageRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSearchMessageRequest.h"
#import "TCMessage+CoreDataClass.h"

@interface TCSearchMessageRequest()
//@property (nonatomic, assign)       NSInteger        status;
@end

@implementation TCSearchMessageRequest

- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCMessage*> *messageArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArrayDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *msgArray = [TCMessage mj_objectArrayWithKeyValuesArray:dataArrayDict context:context];
        success ? success(msgArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/messages/search";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    if (_keywords == nil)
    {
        _keywords = @"";
    }
    if (_mode == 0)
    {
        return @{@"keywords":_keywords};
    }
    return @{@"mode":@(_mode),
             @"keywords":_keywords
             };
}
@end
