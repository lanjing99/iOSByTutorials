//
//  DownloadCell.h
//  ProgressChallenge
//
//  Created by Matt Galloway on 25/08/2013.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Download;

@interface DownloadCell : UITableViewCell

- (void)setupWithDownload:(Download*)download;
- (void)setProgress:(NSProgress*)progress;

@end
