//
//  AppDelegate.h
//  XDWRTMPSender
//
//  Created by zangyanan on 16/12/18.
//  Copyright © 2016年 xindawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

