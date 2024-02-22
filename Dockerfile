FROM node:20

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# 필요한 패키지를 설치합니다.
RUN apt-get update && apt-get install -y locales && apt-get install -y build-essential

ARG USERNAME=node

# /etc/locale.gen 파일에 ko_KR.UTF-8 로케일을 추가
RUN echo "ko_KR.UTF-8 UTF-8" > /etc/locale.gen

# locale-gen 명령을 사용하여 로케일을 생성
RUN locale-gen

# 환경 변수 설정
ENV LC_ALL=ko_KR.UTF-8
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR.UTF-8

# RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \ && chmod 0440 /etc/sudoers.d/$USERNAME
ENV DEVCONTAINER=true

# Nest.js 앱을 빌드하기 위한 추가적인 패키지를 설치합니다.
RUN npm install -g @nestjs/cli

# 앱 의존성을 설치하기 위해 package.json 및 package-lock.json을 복사합니다.
COPY package*.json ./

# 의존성 설치를 실행합니다.
RUN npm ci

# 소스 코드를 복사합니다.
COPY . .

# 앱을 실행합니다.
CMD [ "npm", "run", "start:dev" ]