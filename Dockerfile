FROM centos:7.2.1511

ADD . /usr/convert/
WORKDIR /usr/convert/

# author label
LABEL maintainer="libo@datagrand.com"

COPY ./Python-3.7.3.tar.xz /
COPY ./simsun.ttf /tmp/

# install related packages
RUN cd / && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum makecache \
    && yum install -y wget aclocal automake autoconf make gcc gcc-c++ python-devel mysql-devel bzip2 libffi-devel epel-release\
    # && wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz \
    && tar -xvf Python-3.7.3.tar.xz -C /usr/local/\
    && rm -rf Python-3.7.3.tar.xz \
    && cd /usr/local/Python-3.7.3 \
    && ./configure && make && make install 
    # && yum clean all

RUN rpm --rebuilddb && yum install unoconv openoffice.org-headless openoffice.org-writer openoffice.org-calc openoffice.org-impress -y

RUN yum install mkfontscale fontconfig -y && \
    mkdir /usr/share/fonts/chinese && \
    cp /tmp/simsun.ttf /usr/share/fonts/chinese && \
    mkfontscale && \
    mkfontdir && \
    fc-cache -fv && \
    source /etc/profile

# install related packages
RUN pip3 install --upgrade pip -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com \
    && pip3 install setuptools -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com \
    && pip3 install  -r requirements.txt -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com

EXPOSE 9875

CMD ["bash","./start.sh"]


