function vdek
    wakeonlan fc:aa:14:30:8a:7c &>/dev/null

    set old_home "$HOME"
    set new_dir "$(pwd)"
    set result$(pwd | sed "s#$old_home##")

    ssh vdek -t "cd \$HOME$result; exec \$SHELL --login"
end
