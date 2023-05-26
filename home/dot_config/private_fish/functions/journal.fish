function journal
    set TIME $(date +%Y-%m-%dT%H:%M:%S%z)
    set FILE "$HOME/notes/Journal/$TIME.md"
    touch "$FILE"

    echo --- >>$FILE
    echo 'type: Journal' >>$FILE
    echo "created: $TIME" >>$FILE
    echo --- >>$FILE
    echo >>$FILE

    if which focuswriter &>/dev/null
        focuswriter "$FILE"
    else
        /Applications/FocusWriter.app/Contents/MacOS/FocusWriter "$FILE"
    end

    cd ~/notes/ &>/dev/null
    git add "$FILE"
    set COMMIT_FILE /tmp/journal-commit-msg
    echo 'New Journal Entry' >$COMMIT_FILE
    git commit -F $COMMIT_FILE
    rm $COMMIT_FILE
    cd - &>/dev/null
end
