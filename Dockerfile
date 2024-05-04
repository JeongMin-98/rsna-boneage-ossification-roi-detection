FROM tensorflow/tensorflow:1.4.1-gpu-py3
MAINTAINER Sven Koitka<sven.koitka@uk-essen.de>

# Install additional software
RUN apt-get update && apt-get install -y \
  nano git protobuf-compiler wget
# Install and upgrade dependency
RUN apt-get install -y libgl1-mesa-glx libglib2.0-0
RUN pip install --upgrade pip==20.3.4



RUN pip install \
  lxml \
  Pillow \
  tk \
  matplotlib \
  opencv-python\
  opencv-python-headless \
  pandas \
  progressbar2

RUN git clone https://github.com/tensorflow/models/ /tf-models && \
    cd /tf-models && \
    git checkout 69e1c50433c6cf7843a7cd337558efbb85656f07 && \
    cd /

#COPY patches/eval.proto /tf-models/research/object_detection/protos/
#COPY patches/evaluator.py /tf-models/research/object_detection/

RUN cd /tf-models/research && \
    protoc object_detection/protos/*.proto --python_out=. && \
    touch object_detection/metrics/__init__.py && \
    touch object_detection/inference/__init__.py && \
    cd /

#RUN chmod -R a+wr /tf-models

ENV PYTHONPATH $PYTHONPATH:/tf-models/research:/tf-models/research/slim

COPY source /source

COPY annotations /annotations

WORKDIR /source

ENTRYPOINT /bin/bash
