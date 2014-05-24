// NSSortDescriptor+WilsonRank.m
// 
// Copyright (c) 2014 Mattt Thompson
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

#import "NSSortDescriptor+WilsonRank.h"

static double const WilsonRankDefaultConfidenceLevel = 0.95;

static inline double InverseNormalCDF(double q) {
    static double b[] = {
        1.570796288,
        0.03706987906,
        -0.8364353589e-3,
        -0.2250947176e-3,
        0.6841218299e-5,
        0.5824238515e-5,
        -0.104527497e-5,
        0.8360937017e-7,
        -0.3231081277e-8,
        0.3657763036e-10,
        0.6936233982e-12
    };

    if (q < 0.0 || 1.0 < q || q == 0.5) {
        return 0.0;
    }

    double w1 = q;
    if (q > 0.5)  {
        w1 = 1.0 - q;
    }

    double w3 = -log(4.0 * w1 * (1.0 - w1));
    w1 = b[0];
    for (int i = 1; i < 11; i++) {
        w1 += b[i] * pow(w3, i);
    }

    return q > 0.5 ? sqrt(w1 * w3) : -sqrt(w1 * w3);
}

static inline double WilsonConfidenceIntervalLowerBound(NSUInteger positive, NSUInteger negative, double confidence) {
    NSUInteger n = positive + negative;
    if (n == 0) {
        return 0.0;
    };

    double z = InverseNormalCDF(1.0 - confidence / 2.0);
    double p_hat = 1.0 * positive / n;
    return (p_hat + z * z / (2 * n) -
            z * sqrt((p_hat * (1 - p_hat) + z * z / (4 * n)) / n)) /
            (1 + z * z / n);
}

@implementation NSSortDescriptor (WilsonRank)

+ (instancetype)wilsonRankSortDescriptorWithPositiveKey:(NSString *)positiveRatingsKey
                                            negativeKey:(NSString *)negativeRatingsKey
                                              ascending:(BOOL)ascending
{
    return [self wilsonRankSortDescriptorWithPositiveKey:positiveRatingsKey negativeKey:negativeRatingsKey confidence:WilsonRankDefaultConfidenceLevel ascending:ascending];
}

+ (instancetype)wilsonRankSortDescriptorWithPositiveKey:(NSString *)positiveRatingsKey
                                            negativeKey:(NSString *)negativeRatingsKey
                                             confidence:(double)confidence
                                              ascending:(BOOL)ascending
{
    return [[super alloc] initWithKey:nil ascending:ascending comparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *up1 = [obj1 valueForKeyPath:positiveRatingsKey];
        NSNumber *up2 = [obj2 valueForKeyPath:positiveRatingsKey];

        NSNumber *down1 = [obj1 valueForKeyPath:negativeRatingsKey];
        NSNumber *down2 = [obj2 valueForKeyPath:negativeRatingsKey];

        double wcilb1 = WilsonConfidenceIntervalLowerBound([up1 unsignedIntegerValue], [down1 unsignedIntegerValue], confidence);
        double wcilb2 = WilsonConfidenceIntervalLowerBound([up2 unsignedIntegerValue], [down2 unsignedIntegerValue], confidence);

        if (wcilb1 < wcilb2) {
            return NSOrderedAscending;
        } else if (wcilb1 > wcilb2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

@end
