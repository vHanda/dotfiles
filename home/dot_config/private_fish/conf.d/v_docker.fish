
function getContainerName
    if [[ -z $argv ]]
        set CONTAINER`dps | fzf`
    else
        set CONTAINER `dps | fzf -1 -q $argv`
    end

    echo $CONTAINER
end

function dk
    set CONTAINER `getContainerName $argv`
    docker kill $CONTAINER
end

function dl
    set CONTAINER `getContainerName $argv`
    docker logs --tail=500 $CONTAINER
end

function dlf
    set CONTAINER `getContainerName $argv`
    docker logs --tail=500 -f $CONTAINER
end

function dps
    if [ -z "$argv" ]
        docker ps | awk '{ print $NF }' | tail -n +2
    else
        docker ps | awk '{ print $NF }' | tail -n +2 | grep --color=always -i $argv
    end
end

function de
    set CONTAINER `getContainerName $argv`
    docker exec -ti $CONTAINER bash
end

function dstop-all
    docker stop $(docker ps -a -q)
end

function dkill-all
    docker kill $(docker ps -a -q)
end

function drm-all
    docker rm $(docker ps -a -q)
end
