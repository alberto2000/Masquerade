//
// MasqAppDelegate.m
// Masquerade
//
// Created by Riccardo Lardi on 28/07/14.
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Riccardo Lardi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MasqAppDelegate.h"
#import "MasqClearView.h"
#import <QuartzCore/CoreAnimation.h>
#import "FrameUtils.h"
#import "UIView+FrameUtils.h"

@implementation MasqAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initApp];
}

-(void)initApp
{

    // hide menu bar and dock
    [[NSApplication sharedApplication] setPresentationOptions: NSApplicationPresentationHideMenuBar | NSApplicationPresentationHideDock];
    
    // create main window
    NSRect mainWindowFrame = [[NSScreen mainScreen] frame];
    _window  = [[NSWindow alloc] initWithContentRect:mainWindowFrame
                                                     styleMask:NSTexturedBackgroundWindowMask | NSTitledWindowMask | NSClosableWindowMask
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
    
    // setup main window
    [_window setAlphaValue:0.0];
    [_window setTitle:@""];
    [_window setOpaque:NO];
    [_window setMovable:NO];
    [_window setHasShadow:NO];
    [_window setBackgroundColor:[NSColor clearColor]];
    [_window setCollectionBehavior:NSWindowCollectionBehaviorManaged];
    [_window setDelegate:self];
    [_window setLevel:NSNormalWindowLevel];
    [_window makeKeyAndOrderFront:self];
    
    // create main view
    _view = [[MasqClearView alloc] initWithFrame:NSMakeRect(0, 0, _window.frame.size.width, _window.frame.size.height)];
    [_view setMainController:self];
    [self.window.contentView addSubview:_view];
    
    // create titlebar background window
    NSRect titleBarBackgroundWindowFrame = NSMakeRect(_window.frame.origin.x, _window
                                                      .frame.origin.y + _window.frame.size.height - 22, _window.frame.size.width, 22);
    _titlebarBackgroundWindow = [[NSWindow alloc] initWithContentRect:titleBarBackgroundWindowFrame
                                                        styleMask:NSBorderlessWindowMask
                                                          backing:NSBackingStoreBuffered
                                                            defer:NO];
    
    // setup titlebar background window
    [_titlebarBackgroundWindow setAlphaValue:0.0];
    [_titlebarBackgroundWindow setMovable:NO];
    [_titlebarBackgroundWindow setHasShadow:NO];
    [_titlebarBackgroundWindow setBackgroundColor:[NSColor blackColor]];
    [_titlebarBackgroundWindow setLevel:NSNormalWindowLevel];
    [_window addChildWindow:_titlebarBackgroundWindow ordered:NSWindowBelow];
    
    // add masking subviews
    [self addMaskingSubviews];
    
    // reset masking subviews tracking areas
    [self resetAllTrackingAreas];
    
    // create cursors
    [self createCursors];
    
    // fade in app
    [NSTimer scheduledTimerWithTimeInterval:0.15
                                     target:self
                                   selector:@selector(fadeInApp:)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void)fadeInApp:(NSTimer*)theTimer
{
    [self maskingViewsTranslucent:NO];
}

-(void)addMaskingSubviews
{
    int quarterWidth = _window.frame.size.width * 0.25;
    int quarterHeight = _window.frame.size.height * 0.25;
    
    // create top masking subview
    _topMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(quarterWidth, _window.frame.size.height - quarterHeight, _window.frame.size.width - quarterWidth * 2, quarterHeight)];
    [[_window contentView] addSubview:_topMaskingView];
    [_topMaskingView setMainController:self];
    [_topMaskingView setSideId:@"top"];
    
    // create bottom masking subview
    _bottomMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(quarterWidth, 0, _window.frame.size.width - quarterWidth * 2, quarterHeight)];
    [[_window contentView] addSubview:_bottomMaskingView];
    [_bottomMaskingView setMainController:self];
    [_bottomMaskingView setSideId:@"bottom"];
    
    // create right masking subview
    _rightMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(_window.frame.size.width - quarterWidth, quarterHeight, quarterWidth, _window.frame.size.height - quarterHeight * 2)];
    [[_window contentView] addSubview:_rightMaskingView];
    [_rightMaskingView setMainController:self];
    [_rightMaskingView setSideId:@"right"];
    
    // create left masking subview
    _leftMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(0, quarterHeight, quarterWidth, _window.frame.size.height - quarterHeight * 2)];
    [[_window contentView] addSubview:_leftMaskingView];
    [_leftMaskingView setMainController:self];
    [_leftMaskingView setSideId:@"left"];
    
    // CORNERS:
    
    // create topleft masking subview
    _topLeftMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(0, _window.frame.size.height - quarterHeight, quarterWidth, quarterHeight)];
    [[_window contentView] addSubview:_topLeftMaskingView];
    [_topLeftMaskingView setMainController:self];
    [_topLeftMaskingView setSideId:@"topleft"];
    
    // create topright masking subview
    _topRightMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(_window.frame.size.width - quarterWidth, _window.frame.size.height - quarterHeight, quarterWidth, quarterHeight)];
    [[_window contentView] addSubview:_topRightMaskingView];
    [_topRightMaskingView setMainController:self];
    [_topRightMaskingView setSideId:@"topright"];
    
    // create bottomleft masking subview
    _bottomLeftMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(0, 0, quarterWidth, quarterHeight)];
    [[_window contentView] addSubview:_bottomLeftMaskingView];
    [_bottomLeftMaskingView setMainController:self];
    [_bottomLeftMaskingView setSideId:@"bottomleft"];
    
    // create bottomright masking subview
    _bottomRightMaskingView = [[MasqMaskingView alloc] initWithFrame:NSMakeRect(_window.frame.size.width - quarterWidth, 0, quarterWidth, quarterHeight)];
    [[_window contentView] addSubview:_bottomRightMaskingView];
    [_bottomRightMaskingView setMainController:self];
    [_bottomRightMaskingView setSideId:@"bottomright"];
    
}

-(void)createCursors
{
    NSImage *imgEastWestCursor = [NSImage imageNamed:@"cursor_resizeeastwest.pdf"];
    // NSDictionary *infoEastWestCursor = [NSDictionary dictionaryWithContentsOfFile:@"info_resizeeastwest.plist"];
    _cursorEastWest = [[NSCursor alloc] initWithImage:imgEastWestCursor hotSpot:NSMakePoint(9, 9)];
    
    NSImage *imgNorthEastSouthWestCursor = [NSImage imageNamed:@"cursor_resizenortheastsouthwest.pdf"];
    // NSDictionary *infoNorthEastSouthWestCursor = [NSDictionary dictionaryWithContentsOfFile:@"info_resizenortheastsouthwest.plist"];
    _cursorNorthEastSouthWest = [[NSCursor alloc] initWithImage:imgNorthEastSouthWestCursor hotSpot:NSMakePoint(9, 9)];
    
    NSImage *imgNorthSouthCursor = [NSImage imageNamed:@"cursor_resizenorthsouth.pdf"];
    // NSDictionary *infoNorthSouthCursor = [NSDictionary dictionaryWithContentsOfFile:@"info_resizenorthsouth.plist"];
    _cursorNorthSouth = [[NSCursor alloc] initWithImage:imgNorthSouthCursor hotSpot:NSMakePoint(9, 9)];
    
    NSImage *imgNorthWestSouthEastCursor = [NSImage imageNamed:@"cursor_resizenorthwestsoutheast.pdf"];
    // NSDictionary *infoNorthWestSouthEast = [NSDictionary dictionaryWithContentsOfFile:@"info_resizenorthwestsoutheast.plist"];
    _cursorNorthWestSouthEast = [[NSCursor alloc] initWithImage:imgNorthWestSouthEastCursor hotSpot:NSMakePoint(9, 9)];
}

-(NSDictionary *)getAreasWhereCursorIs
{
    NSDictionary *dict = @{@"barTopLeft": [NSNumber numberWithBool:_cursorInTopLeftMaskingView],
                           @"barTopRight": [NSNumber numberWithBool:_cursorInTopRightMaskingView],
                           @"barBottomLeft": [NSNumber numberWithBool:_cursorInBottomLeftMaskingView],
                           @"barBottomRight": [NSNumber numberWithBool:_cursorInBottomRightMaskingView],
                           @"barTop": [NSNumber numberWithBool:_cursorInTopMaskingView],
                           @"barRight": [NSNumber numberWithBool:_cursorInRightMaskingView],
                           @"barLeft": [NSNumber numberWithBool:_cursorInLeftMaskingView],
                           @"barBottom": [NSNumber numberWithBool:_cursorInBottomMaskingView]};
    
    return dict;
}

-(void)updateCursor
{
    
    NSDictionary * dict = [self getAreasWhereCursorIs];
    
    if ([[dict objectForKey:@"barTopLeft"] boolValue] || [[dict objectForKey:@"barBottomRight"] boolValue]) {
        [_cursorNorthWestSouthEast set];
    } else if ([[dict objectForKey:@"barTopRight"] boolValue] || [[dict objectForKey:@"barBottomLeft"] boolValue]) {
        [_cursorNorthEastSouthWest set];
    } else if ([[dict objectForKey:@"barTop"] boolValue] || [[dict objectForKey:@"barBottom"] boolValue]) {
        [_cursorNorthSouth set];
    } else if ([[dict objectForKey:@"barLeft"] boolValue] || [[dict objectForKey:@"barRight"] boolValue]) {
        [_cursorEastWest set];
    }
    
}

-(void)resetAllCursorFlags
{
    _cursorInTopMaskingView = NO;
    _cursorInLeftMaskingView = NO;
    _cursorInRightMaskingView = NO;
    _cursorInBottomMaskingView = NO;
    
    _cursorInTopLeftMaskingView = NO;
    _cursorInTopRightMaskingView = NO;
    _cursorInBottomLeftMaskingView = NO;
    _cursorInBottomRightMaskingView = NO;
}

-(void)resizeAllAreas:(NSEvent *)theEvent
{
    if (_dragging && ![_draggingArea isEqual: @""]) {
        
        NSPoint cursorInView = [_view convertPoint:[theEvent locationInWindow] fromView:nil];
        
        [self resetAllTrackingAreas];
        
        if ([_draggingArea isEqual: @"barTop"]) {
            
            // top bar
            [_topMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // topleft bar
            [_topLeftMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topLeftMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // topright bar
            [_topRightMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topRightMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // left bar
            [_leftMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topLeftMaskingView.frame.size.height - _bottomLeftMaskingView.frame.size.height)];
            
            // right bar
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height - _bottomRightMaskingView.frame.size.height)];
            
        }
        
        if ([_draggingArea isEqual: @"barLeft"]) {
            
            // left bar
            [_leftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            
            // topleft bar
            [_topLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            
            // bottomleft bar
            [_bottomLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            [_topMaskingView frameMoveToX:floor(cursorInView.x)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:floor(_window.frame.size.width - _bottomLeftMaskingView.frame.size.width - _bottomRightMaskingView.frame.size.width)];
            [_bottomMaskingView frameMoveToX:floor(cursorInView.x)];
            
        }
        
        if ([_draggingArea isEqual: @"barBottom"]) {
            
            // bottom bar
            [_bottomMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // bottomleft bar
            [_bottomLeftMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // bottomright bar
            [_bottomRightMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // left bar
            [_leftMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topLeftMaskingView.frame.size.height - _bottomLeftMaskingView.frame.size.height)];
            [_leftMaskingView frameMoveToY:floor(_bottomLeftMaskingView.frame.size.height)];
            
            // right bar
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height - _bottomRightMaskingView.frame.size.height)];
            [_rightMaskingView frameMoveToY:floor(_bottomRightMaskingView.frame.size.height)];
            
        }
        
        if ([_draggingArea isEqual: @"barRight"]) {
            
            // right bar
            [_rightMaskingView frameResizeToWidth:ceil(_window.frame.size.width - cursorInView.x)];
            [_rightMaskingView frameMoveToX:floor(cursorInView.x)];
            
            // topright bar
            [_topRightMaskingView frameResizeToWidth:floor(_window.frame.size.width - cursorInView.x)];
            [_topRightMaskingView frameMoveToX:floor(cursorInView.x)];
            
            // bottomright bar
            [_bottomRightMaskingView frameResizeToWidth:floor(_window.frame.size.width - cursorInView.x)];
            [_bottomRightMaskingView frameMoveToX:floor(cursorInView.x)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:floor(_window.frame.size.width - _bottomLeftMaskingView.frame.size.width - _bottomRightMaskingView.frame.size.width)];
            
        }
        
        if ([_draggingArea isEqual: @"barTopLeft"]) {
            
            // topleft bar
            [_topLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            [_topLeftMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topLeftMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // left bar
            [_leftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            [_leftMaskingView frameResizeToHeight:floor(_window.frame.size.height - _bottomLeftMaskingView.frame.size.height - _topLeftMaskingView.frame.size.height)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            [_topMaskingView frameMoveToX:floor(_topLeftMaskingView.frame.size.width)];
            [_topMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topMaskingView frameMoveToY:floor(_window.frame.size.height - _topLeftMaskingView.frame.size.height)];
            
            // topright bar
            [_topRightMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topRightMaskingView frameMoveToY:floor(_window.frame.size.height - _topLeftMaskingView.frame.size.height)];
            
            // right bar
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _bottomRightMaskingView.frame.size.height - _topRightMaskingView.frame.size.height)];
            
            // bottomleft bar
            [_bottomLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:floor(_window.frame.size.width - _bottomLeftMaskingView.frame.size.width - _bottomRightMaskingView.frame.size.width)];
            [_bottomMaskingView frameMoveToX:floor(_bottomLeftMaskingView.frame.size.width)];
            
        }
        
        if ([_draggingArea isEqual: @"barTopRight"]) {
            
            // topright bar
            [_topRightMaskingView frameResizeToWidth:ceil(_window.frame.size.width - cursorInView.x)];
            [_topRightMaskingView frameMoveToX:floor(cursorInView.x)];
            [_topRightMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topRightMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // right bar
            [_rightMaskingView frameResizeToWidth:ceil(_window.frame.size.width - cursorInView.x)];
            [_rightMaskingView frameMoveToX:floor(cursorInView.x)];
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _bottomRightMaskingView.frame.size.height - _topRightMaskingView.frame.size.height)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            [_topMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topMaskingView frameMoveToY:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height)];
            
            // topleft bar
            [_topLeftMaskingView frameResizeToHeight:floor(_window.frame.size.height - cursorInView.y)];
            [_topLeftMaskingView frameMoveToY:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height)];
            
            // left bar
            [_leftMaskingView frameResizeToHeight:floor(_window.frame.size.height - _bottomLeftMaskingView.frame.size.height - _topLeftMaskingView.frame.size.height)];
            
            // bottomright bar
            [_bottomRightMaskingView frameResizeToWidth:floor(_rightMaskingView.frame.size.width)];
            [_bottomRightMaskingView frameMoveToX:floor(cursorInView.x)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:floor(_window.frame.size.width - _bottomRightMaskingView.frame.size.width - _bottomLeftMaskingView.frame.size.width)];
            
        }
        
        if ([_draggingArea isEqual: @"barBottomLeft"]) {
            
            // bottomleft bar
            [_bottomLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            [_bottomLeftMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // left bar
            [_leftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            [_leftMaskingView frameResizeToHeight:ceil(_window.frame.size.height - _topLeftMaskingView.frame.size.height - cursorInView.y)];
            [_leftMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:ceil(_window.frame.size.width - _bottomRightMaskingView.frame.size.width - cursorInView.x)];
            [_bottomMaskingView frameMoveToX:floor(cursorInView.x)];
            [_bottomMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // bottom right bar
            [_bottomRightMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // right bar
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height - _bottomRightMaskingView.frame.size.height)];
            [_rightMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // topleft bar
            [_topLeftMaskingView frameResizeToWidth:floor(cursorInView.x)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            [_topMaskingView frameMoveToX:floor(cursorInView.x)];
            
        }
        
        if ([_draggingArea isEqual: @"barBottomRight"]) {
            
            // bottomright bar
            [_bottomRightMaskingView frameResizeToWidth:ceil(_window.frame.size.width - cursorInView.x)];
            [_bottomRightMaskingView frameMoveToX:floor(cursorInView.x)];
            [_bottomRightMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // right bar
            [_rightMaskingView frameResizeToWidth:floor(_bottomRightMaskingView.frame.size.width)];
            [_rightMaskingView frameMoveToX:floor(_bottomRightMaskingView.frame.origin.x)];
            [_rightMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topRightMaskingView.frame.size.height - _bottomRightMaskingView.frame.size.height)];
            [_rightMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // bottom bar
            [_bottomMaskingView frameResizeToWidth:floor(_window.frame.size.width - _bottomLeftMaskingView.frame.size.width - _bottomRightMaskingView.frame.size.width)];
            [_bottomMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // bottomleft bar
            [_bottomLeftMaskingView frameResizeToHeight:floor(cursorInView.y)];
            
            // left bar
            [_leftMaskingView frameResizeToHeight:floor(_window.frame.size.height - _topLeftMaskingView.frame.size.height - _bottomLeftMaskingView.frame.size.height)];
            [_leftMaskingView frameMoveToY:floor(cursorInView.y)];
            
            // topright bar
            [_topRightMaskingView frameResizeToWidth:floor(_rightMaskingView.frame.size.width)];
            [_topRightMaskingView frameMoveToX:floor(_rightMaskingView.frame.origin.x)];
            
            // top bar
            [_topMaskingView frameResizeToWidth:floor(_window.frame.size.width - _topLeftMaskingView.frame.size.width - _topRightMaskingView.frame.size.width)];
            
        }
        
    }
    
}

-(void)trackingMouseEntered:(NSEvent *)theEvent fromId:(NSString *)fromId
{
    if ([fromId isEqualToString:@"top"]) {
        _cursorInTopMaskingView = YES;
    } else if ([fromId isEqualToString:@"left"]) {
        _cursorInLeftMaskingView = YES;
    } else if ([fromId isEqualToString:@"right"]) {
        _cursorInRightMaskingView = YES;
    } else if ([fromId isEqualToString:@"bottom"]) {
        _cursorInBottomMaskingView = YES;
    } else if ([fromId isEqualToString:@"topleft"]) {
        _cursorInTopLeftMaskingView = YES;
    } else if ([fromId isEqualToString:@"topright"]) {
        _cursorInTopRightMaskingView = YES;
    } else if ([fromId isEqualToString:@"bottomleft"]) {
        _cursorInBottomLeftMaskingView = YES;
    } else if ([fromId isEqualToString:@"bottomright"]) {
        _cursorInBottomRightMaskingView = YES;
    }
}

-(void)trackingMouseMoved:(NSEvent *)theEvent fromId:(NSString *)fromId
{
    [self updateCursor];
}

-(void)trackingMouseExited:(NSEvent *)theEvent fromId:(NSString *)fromId
{
    [self resetAllCursorFlags];
    [[NSCursor arrowCursor] set];
}

-(void)mouseDown:(NSEvent *)event fromId:(NSString *)fromId
{
    [self checkDrag];
}

-(void)mouseDragged:(NSEvent *)theEvent fromId:(NSString *)fromId
{
    [self resizeAllAreas:theEvent];
}

-(void)mouseUp:(NSEvent *)event fromId:(NSString *)fromId
{
    [self releaseDrag];
}

-(void)resetAllTrackingAreas
{
    [_topMaskingView resetTrackingArea];
    [_leftMaskingView resetTrackingArea];
    [_rightMaskingView resetTrackingArea];
    [_bottomMaskingView resetTrackingArea];
    
    [_topLeftMaskingView resetTrackingArea];
    [_topRightMaskingView resetTrackingArea];
    [_bottomLeftMaskingView resetTrackingArea];
    [_bottomRightMaskingView resetTrackingArea];
}

-(void)checkDrag
{
    NSDictionary *dict = [self getAreasWhereCursorIs];
    
    for (NSString *key in dict) {
        id val = [dict objectForKey:key];
        if ((long)[val integerValue] == 1) {
            _dragging = YES;
            _draggingArea = key;
            [self maskingViewsTranslucent:YES];
        }
    }
}

-(void)releaseDrag
{
    _dragging = NO;
    _draggingArea = @"";
    [self maskingViewsTranslucent:NO];
}

-(void)maskingViewsTranslucent:(BOOL)flag
{
    if (flag == YES) {
        [[_window animator] setAlphaValue:0.5f];
        [[_titlebarBackgroundWindow animator] setAlphaValue:0.5f];
    } else {
        [[_window animator] setAlphaValue:1.0f];
        [[_titlebarBackgroundWindow animator] setAlphaValue:1.0f];
    }
}

-(void)clearViewMouseMoved:(NSEvent *)theEvent fromId:(NSString *)fromId
{
    if (_mouseHideTimer != nil) {
        [_mouseHideTimer invalidate];
    }
    
    _mouseHideTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideMouse:) userInfo:nil repeats:NO];
}

-(void)hideMouse:(NSTimer *)timer
{
    if (_dragging) {
        return;
    }
    
	[NSCursor setHiddenUntilMouseMoves:YES];
	_mouseHideTimer = nil;
}

- (void)onMenuAboutClick:(id)sender
{
    // TODO
    NSLog(@"Open About Dialog");
}

-(void)windowWillClose:(NSNotification *)notification
{
    [_titlebarBackgroundWindow close];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
    return YES;
}

@end
