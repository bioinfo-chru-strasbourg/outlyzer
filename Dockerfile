FROM centos
MAINTAINER Antony Le Bechec <antony.lebechec@gmail.com>

##############################################################
# Dockerfile Version:   1.0
# Software:             OUTLYZER
# Software Version:     2
# Software Website:     https://github.com/EtieM/outLyzer
# Description:          SAMTOOLS
##############################################################


#######
# YUM #
#######

#RUN yum update -y
RUN yum install -y zlib-devel zlib \
                  zlib2-devel zlib2 \
                  bzip2-devel bzip2 \
                  lzma-devel lzma \
                  xz-devel xz \
                  ncurses-devel \
                  wget \
                  gcc \
                  python2-pip \
                  python2-setuptools \
                  epel-release \
                  make ;
RUN yum clean all ;

# python2-wheel


##########
# HTSLIB #
##########

ENV TOOLS=/home/TOOLS/tools
ENV TOOL_NAME=htslib
ENV TOOL_VERSION=1.8
ENV TARBALL_LOCATION=https://github.com/samtools/$TOOL_NAME/releases/download/$TOOL_VERSION/
ENV TARBALL=$TOOL_NAME-$TOOL_VERSION.tar.bz2
ENV DEST=$TOOLS/$TOOL_NAME/$TOOL_VERSION
ENV PATH=$TOOLS/$TOOL_NAME/$TOOL_VERSION/bin:$PATH

# INSTALL
RUN wget $TARBALL_LOCATION/$TARBALL ; \
    tar xf $TARBALL ; \
    rm -rf $TARBALL ; \
    cd $TOOL_NAME-$TOOL_VERSION ; \
    make prefix=$TOOLS/$TOOL_NAME/$TOOL_VERSION install ; \
    cd ../ ; \
    rm -rf $TOOL_NAME-$TOOL_VERSION


############
# BCFTOOLS #
############

ENV TOOLS=/home/TOOLS/tools
ENV TOOL_NAME=bcftools
ENV TOOL_VERSION=1.8
ENV TARBALL_LOCATION=https://github.com/samtools/$TOOL_NAME/releases/download/$TOOL_VERSION/
ENV TARBALL=$TOOL_NAME-$TOOL_VERSION.tar.bz2
ENV DEST=$TOOLS/$TOOL_NAME/$TOOL_VERSION
ENV PATH=$TOOLS/$TOOL_NAME/$TOOL_VERSION/bin:$PATH

# INSTALL
RUN wget $TARBALL_LOCATION/$TARBALL ; \
    tar xf $TARBALL ; \
    rm -rf $TARBALL ; \
    cd $TOOL_NAME-$TOOL_VERSION ; \
    make prefix=$TOOLS/$TOOL_NAME/$TOOL_VERSION install ; \
    cd ../ ; \
    rm -rf $TOOL_NAME-$TOOL_VERSION


############
# SAMTOOLS #
############

ENV TOOLS=/home/TOOLS/tools
ENV TOOL_NAME=samtools
ENV TOOL_VERSION=1.8
ENV TARBALL_LOCATION=https://github.com/samtools/$TOOL_NAME/releases/download/$TOOL_VERSION/
ENV TARBALL=$TOOL_NAME-$TOOL_VERSION.tar.bz2
ENV DEST=$TOOLS/$TOOL_NAME/$TOOL_VERSION
ENV PATH=$TOOLS/$TOOL_NAME/$TOOL_VERSION/bin:$PATH

# INSTALL
RUN wget $TARBALL_LOCATION/$TARBALL ; \
    tar xf $TARBALL ; \
    rm -rf $TARBALL ; \
    cd $TOOL_NAME-$TOOL_VERSION ; \
    make prefix=$TOOLS/$TOOL_NAME/$TOOL_VERSION install ; \
    cd ../ ; \
    rm -rf $TOOL_NAME-$TOOL_VERSION



############
# OUTLYSER #
############

ENV TOOLS=/home/TOOLS/tools
ENV TOOL_NAME=outlyzer
ENV TOOL_VERSION=2
ENV FILE_LOCATION=https://raw.githubusercontent.com/EtieM/outLyzer/master
ENV FILE=outLyzer.py
ENV DEST=$TOOLS/$TOOL_NAME/$TOOL_VERSION
ENV PATH=$TOOLS/$TOOL_NAME/$TOOL_VERSION/bin:$PATH

RUN yum install -y python2-pip;
RUN pip install --upgrade pip;

RUN wget $FILE_LOCATION/$FILE ; \
    mkdir -p $TOOLS/$TOOL_NAME/$TOOL_VERSION/bin ; \
    cp $FILE $TOOLS/$TOOL_NAME/$TOOL_VERSION/bin/ ;

RUN pip install numpy scipy argparse

RUN cd /

RUN wget https://github.com/uqfoundation/pathos/archive/master.tar.gz ; \
    tar -xvzf master.tar.gz ; \
    chmod 0775 pathos-master -R ; \
    cd pathos-master ; \
    python ./setup.py build ; \
    python ./setup.py install ; \
    cd .. ; \
    rm -rf pathos-master ;


# subprocess numpy scipy argparse multiprocessing

#######
# YUM #
#######

RUN yum erase -y zlib-devel \
                  zlib2-devel \
                  bzip2-devel \
                  lzma-devel \
                  xz-devel \
                  ncurses-devel \
                  wget \
                  gcc \
                  make ;
RUN yum clean all ;

WORKDIR "$TOOLS/$TOOL_NAME/$TOOL_VERSION/bin"

CMD ["/bin/bash"]
