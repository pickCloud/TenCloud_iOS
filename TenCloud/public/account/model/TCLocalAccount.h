//
//  TCLocalAccount.h
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCLocalAccount;
@class TCUser;
@protocol TCLocalAccountDelegate<NSObject>
- (void) accountLoggedIn:(TCLocalAccount*)account;
- (void) accountLogout:(TCLocalAccount*)account;
- (void) accountModified:(TCLocalAccount*)account;
@end

@interface TCLocalAccount : NSObject<NSCoding>

@property (nonatomic, assign)   NSInteger   userID;
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *mobile;
@property (nonatomic, strong)   NSString    *token;
@property (nonatomic, strong)   NSString    *avatar;
@property (nonatomic, strong)   NSString    *email;
@property (nonatomic, assign)   NSInteger   gender;
@property (nonatomic, assign)   NSInteger   birthday;
@property (nonatomic, strong)   NSString    *createTime;

+ (TCLocalAccount *) shared;

- (void) addObserver:(id<TCLocalAccountDelegate>)obs;

- (void) removeObserver:(id<TCLocalAccountDelegate>)obs;

- (BOOL) isLogin;

- (void) loginSuccess:(TCUser*)user;

- (void) modified;

- (void) logout;

- (NSString *) hiddenMobile;

- (void) save;
@end
