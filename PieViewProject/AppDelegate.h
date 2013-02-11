//
//  AppDelegate.h
//  PieViewProject
//
//  Created by Maciej Gregorczyk on 02.02.2013.
//  Copyright (c) 2013 Maciej Gregorczyk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PieView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property  PieView *pieview;
@property  id ds;

@end
