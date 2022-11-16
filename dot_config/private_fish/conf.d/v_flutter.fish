#!/usr/bin/env fish

export NDK="$HOME/Library/Android/sdk/ndk-bundle"

fish_add_path $HOME/src/flutter/flutter/bin
fish_add_path $HOME/src/flutter/flutter/bin/cache/dart-sdk/bin

export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_AVD_HOME=$HOME/.android/avd

fish_add_path $ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools
fish_add_path $ANDROID_SDK_ROOT/platform-tools
fish_add_path $HOME/.pub-cache/bin

alias fa='flutter analyze'

function fr
    if [[ -f ./scripts/flutter_run.sh ]]
        then
        ./scripts/flutter_run.sh "$argv"
    else
        ./flutterw run "$argv"
    end
end

function __dart_getTestFiles
    if [[ -z $argv ]]
        set FILE_NAME $(fd '.*_test.dart' | fzf)
    else
        set FILE_NAME $(fd '.*_test.dart' | fzf -1 -q $argv)
    end

    echo $FILE_NAME
end

function dt
    set TEST_FILE $(__dart_getTestFiles $argv)
    if [[ -z "$TEST_FILE" ]]
        return
    end

    echo "dart test $TEST_FILE"
    print -s "dart test $TEST_FILE"
    dart test "$TEST_FILE"
end

function ft
    set TEST_FILE $(__dart_getTestFiles $argv)
    if [[ -z "$TEST_FILE" ]]
        return
    end

    echo "flutter test $TEST_FILE"
    print -s "flutter test $TEST_FILE"
    flutter test "$TEST_FILE"
end
