function devlog-prev
    set TODAY $(date --iso-8601)
    set FILE $(ls ~/notes/GoGo/DevLog/ | sort -u | grep -v $TODAY | tail -n 1)

    open $HOME/notes/GoGo/DevLog/$FILE
end
