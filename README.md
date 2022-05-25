Nextcloud com Raspberry Pi, Docker e Let's Encrypt
==========================================

Trata-se de uma implantação leve e completa do NextCloud em Docker usando Nginx, PostgreSQL, fpm, acme-companion e docker-gen.
Implementado para arquiteturas ARM e testado com Raspberry Pi, podendo funcionar para outras SBC's (Single Board Computer).

- https://github.com/nginx-proxy/nginx-proxy
- https://github.com/nginx-proxy/acme-companion

#  Aplicação

##  Passo I
Criar manualmente os arquivos **.env** e **.conf** conforme exemplos. 
Certificar que os arquivos citados estejam presentes ao iniciar a implantação.

- .env (link simbólico)

- ./env-files/env  
    PREFIX_INSTANCE=  
    IP=  
    PATH_NGINX_PROXY=./nginx-proxy  
    PATH_NEXTCLOUD=./nextcloud  
    NGINX_PROXY_LOG_DRIVER=json-file  
    NGINX_PROXY_LOG_MAX_SIZE=4m  
    NGINX_PROXY_LOG_MAX_FILE=10   
    DOCKER_GEN_LOG_DRIVER=json-file  
    DOCKER_GEN_LOG_MAX_SIZE=2m  
    DOCKER_GEN_LOG_MAX_FILE=10  
    ACME_COMPANION_LOG_DRIVER=json-file  
    ACME_COMPANION_LOG_MAX_SIZE=2m  
    ACME_COMPANION_LOG_MAX_FILE=10  
    SSL_POLICY=Mozilla-Modern  

- ./env-files/nextcloud-app.env  
    POSTGRES_DB=  
    POSTGRES_USER=  
    POSTGRES_PASSWORD=  
    NEXTCLOUD_ADMIN_PASSWORD=  
    NEXTCLOUD_ADMIN_USER=  
    NEXTCLOUD_TRUSTED_DOMAINS=  

- ./env-files/nextcloud-database.env  
    POSTGRES_DB=  
    POSTGRES_USER=  
    POSTGRES_PASSWORD=  

- ./env-files/nextcloud-web.env  
    VIRTUAL_HOST=  
    LETSENCRYPT_HOST=  
    LETSENCRYPT_EMAIL=  
    VIRTUAL_PORT=  

- ./config-files/nextcloud-web/nginx.conf
- ./config-files/nextcloud-web/reallip.conf (opcional)
- ./config-files/nextcloud-web/servertokens.conf (opcional)
- ./config-files/nextcloud-web/uploadsize.conf (opcional)

##  Etapa II
Execute o comando: chmod +x config-files/cloud-start.sh

##  Etapa III
Executar **./scripts/cloud-start.sh** para iniciar a implantação.