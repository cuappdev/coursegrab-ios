#!/bin/sh

#  ci_post_clone.sh
#  CourseGrab
#
#  Created by Vin Bui on 1/4/24.
#  Copyright © 2024 Cornell AppDev. All rights reserved.

echo "Downloading Secrets"
brew install wget
cd $CI_WORKSPACE/ci_scripts
wget -O ../CourseGrab/Supporting/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"
wget -O ../CourseGrab/Supporting/Keys.plist "$KEYS_PLIST"
