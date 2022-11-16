export GOPATH=$HOME/go
fish_add_path /usr/local/opt/go/libexec/bin
fish_add_path $(go env GOPATH)/bin

function gr
    set COUNT `ls -1 *.go 2>/dev/null | wc -l`
    if [[ $COUNT == 0 ]]
        if [ -d cmd ]
            cd cmd/consumer
        else
            echo "Could not find go files"
            return
        end
    end

    pwd
    EXE_NAME=`basename $PWD`

    time go build
    if [ $status -eq 0 ]
    else
        osascript -e "display notification \"Build Failed\" with title \"$EXE_NAME\""
        return
    end
    ./"$EXE_NAME"
end
