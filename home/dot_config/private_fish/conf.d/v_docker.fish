function _docker
    set -l os (uname)
    if test "$os" = Darwin
        docker $argv
    else if groups | grep -q docker
        docker $argv
    else
        sudo docker $argv
    end
end

function getContainerName
    if test -z $argv
        set CONTAINER $(dps | fzf)
    else
        set CONTAINER $(dps | fzf -1 -q $argv)
    end

    echo $CONTAINER
end

function dk
    set CONTAINER $(getContainerName $argv)
    _docker kill $CONTAINER
end

function dl
    set CONTAINER $(getContainerName $argv)
    _docker logs --tail=500 $CONTAINER
end

function dlf
    set CONTAINER $(getContainerName $argv)
    _docker logs --tail=500 -f $CONTAINER
end

function dps
    if test -z "$argv"
        _docker ps | awk '{ print $NF }' | tail -n +2
    else
        _docker ps | awk '{ print $NF }' | tail -n +2 | grep --color=always -i $argv
    end
end

function de
    set CONTAINER $(getContainerName $argv)
    set SHELL $(getContainerShell $CONTAINER)
    set WD $(getContainerWorkingDir $CONTAINER)

    if test $status -eq 0
        _docker exec -it -w $WD $CONTAINER $SHELL
    else
        _docker exec -it $CONTAINER $SHELL
    end
end

function getContainerShell
    set CONTAINER $(getContainerName $argv)
    if _docker exec -it $CONTAINER fish --version &>/dev/null
        echo fish
    else if _docker exec -it $CONTAINER bash --version &>/dev/null
        echo bash
    else
        echo sh
    end
end

function getContainerWorkingDir
    set CONTAINER $(getContainerName $argv)

    set WORKSPACE $(docker exec -it $CONTAINER ls /workspaces 2>&1)
    if test $status -eq 0
        set WORKSPACE $(string trim $WORKSPACE)
        echo "/workspaces/$WORKSPACE"
        return 0
    end

    if _docker exec -it $CONTAINER ls /code &>/dev/null
        echo /code
        return 0
    end

    return 1
end

function dstop-all
    _docker stop $(_docker ps -a -q)
end

function dkill-all
    _docker kill $(_docker ps -a -q)
end

function drm-all
    _docker rm $(_docker ps -a -q)
end
