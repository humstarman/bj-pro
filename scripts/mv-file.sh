#!/bin/bash
set -e
DEFAULT_S="default"
show_help () {
cat << USAGE
usage: $0 [ -P POD-NAME ] [ -S NAMESPACE ] [ -F SOURCE-PATH ] [ -T DESTINATION-PATH ] 
       [ -c CLEARANCE-OR-NOT ]
    -p : Specify the pod name.
    -s : Specify the namespace. If not specified, use '${DEFAULT_S}' by default.
    -f : Specify the source path.
    -t : Specify the destination path.
    -c : Specify clearance or not.
USAGE
exit 0
}
# Get Opts
while getopts "hp:s:f:t:c" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    p)  POD=$OPTARG
        ;;
    s)  NAMESPACE=$OPTARG
        ;;
    f)  FROM=$OPTARG
        ;;
    t)  TO=$OPTARG
        ;;
    c)  CLEAR=true
        ;;
    ?)  # 当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
[[ -z $* ]] && show_help
chk_var () {
if [ -z "$2" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
  sleep 3
  exit 1
fi
}
chk_var -n $POD
chk_install () {
if [ ! -x "$(command -v $1)" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no $1 installed !!!"
  sleep 3
  exit 1
fi
}
NEEDS="kubectl"
for NEED in $NEEDS; do
  chk_install $NEED
done
NAMESPACE=${NAMESPACE:-"${DEFAULT_S}"}
FLAG=0
while (( ${FLAG} != 1 )); do
  if kubectl get po pro-v1-0 | awk -F ' ' '{print $3}' | grep Running; then
    FLAG=1
    echo OKAY
  else
    sleep 1
  fi
done
kubectl -n ${NAMESPACE} exec -it ${POD} -- cp -rf ${FROM}/. ${TO}
