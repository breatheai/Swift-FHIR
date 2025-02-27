#!/bin/bash

# https://mokacoding.com/blog/running-tests-from-the-terminal/

xcodebuild \
  -workspace SwiftFHIR.xcworkspace \
  -scheme ModelTests \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2' \
  test \
  | xcbeautify
