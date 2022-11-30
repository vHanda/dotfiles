function devlog
    # set fish_trace 1
    set DATE $(date --iso-8601)
    set FILE "$HOME/notes/DevLog/$DATE.md"

    if not test -e "$FILE"
        echo "Creating $FILE"
        echo "# DevLog $DATE" >> $FILE
        echo >>$FILE
        echo "## Medl" >>$FILE
        echo >>$FILE
    else
        echo "Opening $FILE"
    end

    open $FILE
end

function devlog-prev
    set TODAY $(date --iso-8601)
    set FILE $(ls ~/notes/DevLog/ | sort -u | grep -v $TODAY | tail -n 1)

    open $HOME/notes/DevLog/$FILE
end
