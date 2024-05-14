function devlog
    # set fish_trace 1
    set DATE $(date --iso-8601)
    set FILE "$HOME/notes/GoGo/DevLog/$DATE.md"

    if not test -e "$FILE"
        echo "Creating $FILE"
        echo "# DevLog $DATE" >>$FILE
        echo >>$FILE
    else
        echo "Opening $FILE"
    end

    open $FILE
end
