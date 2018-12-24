//
//  JSObjDelegate.h
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/24.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSObjDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareInfo;
- (void)check:(NSString *)name;

@end
