
ioc=${1}
start=${2}
thisdir=$(realpath $(dirname ${BASH_SOURCE[0]}))

if [ -z $(which docker 2> /dev/null) ]
then
    # try podman if we dont see docker installed
    shopt -s expand_aliases
    alias docker='podman'
fi

image=gcr.io/diamond-pubreg/controls/python3/s03_utils/epics/edm:latest
environ="-e DISPLAY=$DISPLAY -e EDMDATAFILES=/screens"
volumes="-v ${thisdir}/${ioc}:/screens -v /tmp:/tmp"

docker run ${environ} ${volumes} -ti ${image} edm -x -noedit ${start}
