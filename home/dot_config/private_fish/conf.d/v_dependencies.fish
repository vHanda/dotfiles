function vishDeps
    set -l deps fd ag git fzf bat
    for dep in $deps
        if not type -q $dep
            echo "Missing $dep"
            return 1
        end
    end

    echo "All dependencies satisfied"
end
