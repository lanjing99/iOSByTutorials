//
//  CENoteEditorControllerViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "Note.h"
#import "TimeIndicatorView.h"

@interface NoteEditorViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) TimeIndicatorView *timeView;

@end

@implementation NoteEditorViewController
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = self.note.contents;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [self.view addSubview:self.timeView];
}

-(void)viewDidLayoutSubviews
{
    [self updateTimeIndicatorFrame];
}

-(void)updateTimeIndicatorFrame
{
    [self.timeView updateSize];
    self.timeView.frame = CGRectOffset(self.timeView.frame, self.view.frame.size.width - self.timeView.frame.size.width, 0);
    UIBezierPath *exclusionPath = [_timeView curvePathWithOrigin:self.timeView.center];
    _textView.textContainer.exclusionPaths = @[exclusionPath];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // copy the updated note text to the underlying model.
    self.note.contents = textView.text;
}

-(void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self updateTimeIndicatorFrame];
}

-(TimeIndicatorView *)timeView
{
   if(!_timeView)
   {
       _timeView = [[TimeIndicatorView alloc] init:self.note.timestamp];
   }
    return _timeView;
}

@end







