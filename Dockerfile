# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/pyspark-notebook

MAINTAINER Ankit <ankit@googlegroups.com>

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils
    \fonts-dejavu \
    less \
    nano \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*





###################################
# JUPYTER RELATED

# Dependencies
RUN chown jovyan /opt
# Main notebook user
USER jovyan
# install libs
RUN pip install --upgrade pip \
    plumbum jinja2 tweepy version_information \
    elasticsearch ujson certifi requests certifi \
    pandasticsearch[pandas]



###############################
# Live slideshows
RUN mkdir -p /root/.jupyter/nbconfig && \
    wget https://github.com/pdonorio/RISE/archive/master.tar.gz \
    && tar xvzf *.gz && cd *master && \
    python setup.py install

###############################

USER $NB_USER


# Apache Toree kernel
RUN pip --no-cache-dir install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
RUN jupyter toree install --sys-prefix

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.2*' && \
    conda clean -tipsy
RUN python -m spylon_kernel install --sys-prefix
