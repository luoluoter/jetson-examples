#!/bin/bash

BASE_PATH=/home/$USER/reComputer
JETSON_REPO_PATH="$BASE_PATH/jetson-containers"

# check data files TODO: support params to force download
DATA_PATH="$JETSON_REPO_PATH/data/datasets/coco/2017"
if [ ! -d $DATA_PATH ]; then
    mkdir -p $DATA_PATH
fi
cd $DATA_PATH
# check val2017.zip
if [ ! -d "$DATA_PATH/val2017" ]; then
    if [ ! -f "val2017.zip" ]; then
        check_disk_space $DATA_PATH 1
        wget http://images.cocodataset.org/zips/val2017.zip
    else
        echo "val2017.zip existed."
    fi
    check_disk_space $DATA_PATH 19
    unzip val2017.zip && rm val2017.zip
else
    echo "val2017/ existed."
fi
# check train2017.zip
if [ ! -d "$DATA_PATH/train2017" ]; then
    if [ ! -f "train2017.zip" ]; then
        check_disk_space $DATA_PATH 19
        wget http://images.cocodataset.org/zips/train2017.zip
    else
        echo "train2017.zip existed."
    fi
    check_disk_space $DATA_PATH 19
    unzip train2017.zip && rm train2017.zip
else
    echo "train2017/ existed."
fi
if [ ! -d "$DATA_PATH/unlabeled2017" ]; then
    # check unlabeled2017.zip
    if [ ! -f "unlabeled2017.zip" ]; then
        check_disk_space $DATA_PATH 19
        wget http://images.cocodataset.org/zips/unlabeled2017.zip
    else
        echo "unlabeled2017.zip existed."
    fi
    check_disk_space $DATA_PATH 19
    unzip unlabeled2017.zip && rm unlabeled2017.zip
else
    echo "unlabeled2017/ existed."
fi

# check index files
INDEX_PATH="$JETSON_REPO_PATH/data/nanodb/coco/2017"
if [ ! -d $INDEX_PATH ]; then
    cd $JETSON_REPO_PATH/data/
    check_disk_space $JETSON_REPO_PATH 1
    wget https://nvidia.box.com/shared/static/icw8qhgioyj4qsk832r4nj2p9olsxoci.gz -O nanodb_coco_2017.tar.gz
    tar -xzvf nanodb_coco_2017.tar.gz
fi

# RUN
cd $JETSON_REPO_PATH
./run.sh $(./autotag nanodb) \
python3 -m nanodb \
--path /data/nanodb/coco/2017 \
--server --port=7860