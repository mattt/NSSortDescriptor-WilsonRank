// main.m
//
// Copyright (c) 2014 – 2018 Mattt
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

#import <Foundation/Foundation.h>

#import "NSSortDescriptor+WilsonRank.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *fruits = @[@{@"name": @"apple", @"up": @(77), @"down": @(14)},
                            @{@"name": @"banana", @"up": @(90), @"down": @(78)},
                            @{@"name": @"cherry", @"up": @(28), @"down": @(6)},
                            @{@"name": @"durian", @"up": @(2), @"down": @(43)},
                            @{@"name": @"elderberry", @"up": @(81), @"down": @(42)},
                            @{@"name": @"fig", @"up": @(70), @"down": @(93)},
                            @{@"name": @"grape", @"up": @(48), @"down": @(89)},
                            @{@"name": @"honeydew", @"up": @(65), @"down": @(26)},
                            ];

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor wilsonRankSortDescriptorWithPositiveKey:@"up" negativeKey:@"down" ascending:NO];
        for (id fruit in [fruits sortedArrayUsingDescriptors:@[sortDescriptor]]) {
            NSLog(@"%@ (%@↑ / %@↓)", fruit[@"name"], fruit[@"up"], fruit[@"down"]);
        }
    }

    return 0;
}
