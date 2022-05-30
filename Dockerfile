FROM httpd:2.4.48-buster
RUN apt-get update

# Install PowerShell
RUN apt-get install -y wget apt-transport-https software-properties-common default-mysql-client

RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y powershell
RUN rm packages-microsoft-prod.deb


ENV ENV_SQL_HOSTNAME="127.0.0.1"
ENV ENV_SQL_USERNAME="username"
ENV ENV_SQL_PASSWORD="password"
ENV ENV_SQL_DATABASE="database"
ENV ENV_SQL_TABLE="table"

# HTTP Docs /usr/local/apache2/htdocs
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /powershell/html/api/v1/status
WORKDIR /powershell
RUN mkdir /powershell/html/status
RUN mkdir /powershell/html/status/available
RUN mkdir /powershell/html/status/unavailable
RUN mkdir /powershell/html/status/ok
RUN mkdir /powershell/html/status/replace
COPY powershell.ps1 /powershell/powershell.ps1
COPY index.html /powershell/html
CMD httpd && pwsh ./powershell.ps1
