//
//  JSObjDelegate.h
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/24.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSObjDelegate <JSExport>//协议需要继承JSExport。这个协议官方也写的很清楚，JS调用原生方法的时候，这个方法需要被外部看到，通过这个协议来让外部看到。这个协议并没有方法，使用的时候需要继承这个协议来使用。

- (void)callCamera;
- (void)share:(NSString *)shareInfo;
- (void)check:(NSString *)name;

@end
