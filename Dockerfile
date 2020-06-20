#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dockerfile for python AI actions, overrides and extends ActionRunner from actionProxy
FROM ubuntu:bionic

ENV FLASK_PROXY_PORT 8080
ENV PYTHONIOENCODING "UTF-8"
ENV PATH="/usr/local/saclient/bin:${PATH}"

COPY actionProxy pythonAction requirements.txt /tmp/ 

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        gcc \
        libc-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev \
        libssl-dev \
        zip \
        unzip \
        curl python3 python3-pip \
        && rm -rf /var/lib/apt/lists/* \
        && pip3 install --no-cache-dir -r /tmp/requirements.txt \
        &&  curl -o saclient.zip -sL "https://cloud.appscan.com/api/SCX/StaticAnalyzer/SAClientUtil?os=linux" \
        &&  unzip saclient.zip && rm -rf saclient.zip && mv SAClientUtil* /usr/local/saclient \
        && bash -c 'mkdir -p {/actionProxy,/pythonAction}' && mv /tmp/actionproxy.py /actionProxy && mv /tmp/pythonrunner.py pythonAction


CMD cd /pythonAction && python3 -u pythonrunner.py
