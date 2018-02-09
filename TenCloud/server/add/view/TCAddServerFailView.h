//
//  TCAddServerFailView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TCAddServerBlock)(void);

@interface TCAddServerFailView : UIView

- (IBAction) onContinueButton:(id)sender;

@property (nonatomic, copy) TCAddServerBlock    continueBlock;

@end
